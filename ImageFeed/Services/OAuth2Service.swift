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
		case .invalidRequest: return "[\(#fileID)]:[\(#function)] -> Invalid or doubled request from OAuthService"
		}
	}
}

final class OAuth2Service {
	static let shared = OAuth2Service()
	private var task: URLSessionTask?
	private var lastCode: String?
	private let requestBuilder = RequestsBuilderService.shared
	
	private init() {}
	
	func fetchOAuthToken(code: String, completion: @escaping(_ result: Result<String, Error>) -> Void) {
		assert(Thread.isMainThread, "\(#function) called not in main thread")
		guard 
			let request = requestBuilder.madeRequest(for: .token(code)),
			lastCode != code
		else {
			//Принт дублирует вывод ошибки в консоль - добавлен согласно требованиям.
			print("\(OAuth2ServiceError.invalidRequest.localizedDescription)")
			completion(.failure(OAuth2ServiceError.invalidRequest))
			return
		}
		
		task?.cancel()
		lastCode = code
		let task = URLSession.shared
			.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
				guard let self else { preconditionFailure("No OAuthService initialized") }
				self.task = nil
				self.lastCode = nil
				switch result {
				case .success(let responseBody):
					completion(.success(responseBody.accessToken))
				case .failure(let error):
					//Принт дублирует вывод ошибки в консоль - добавлен согласно требованиям.
					print("[\(#fileID)]:[\(#function)] -> \(error.localizedDescription)")
					completion(.failure(error))
				}
			}
		
		self.task = task
		task.resume()
	}
}
