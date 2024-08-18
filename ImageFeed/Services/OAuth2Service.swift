//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Denis on 26.07.2024.
//

import Foundation

enum OAuth2ServiceError: Error, LocalizedError {
	case invalidRequest
	
	var errorDescription: String? {
		switch self {
		case .invalidRequest: return "Invalid or doubled request from OAuth2Service"
		}
	}
}

final class OAuth2Service {
	static let shared = OAuth2Service()
	private var task: URLSessionTask?
	private var lastCode: String?
	private let decoder = DecodeService.shared
	private let requestBuilder = RequestsBuilderService.shared
	
	private init() {}
	
	func fetchOAuthToken(code: String, completion: @escaping(_ result: Result<String, Error>) -> Void) {
		assert(Thread.isMainThread, "\(#function) called not in main thread")
		guard 
			let request = requestBuilder.madeRequest(for: .token(code)),
			lastCode != code
		else {
			completion(.failure(OAuth2ServiceError.invalidRequest))
			return
		}
		
		task?.cancel()
		lastCode = code
		
		let task = URLSession.shared.data(for: request) { [weak self] result in
			guard let self else {
				preconditionFailure("No OAuthService initialized")
			}
			self.task = nil
			self.lastCode = nil
			switch result {
			case .success(let data):
				do {
					let responseBody = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
					completion(.success(responseBody.accessToken))
				} catch {
					completion(.failure(DecoderError.decodingError(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
		
		self.task = task
		task.resume()
	}
}
