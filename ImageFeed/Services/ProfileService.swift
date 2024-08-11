//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Denis on 11.08.2024.
//

import Foundation

enum ProfileServiceError: Error, LocalizedError {
	case invalidRequest
	
	var errorDescription: String? {
		switch self {
		case .invalidRequest: return "Invalid or doubled request from ProfileService"
		}
	}
}

final class ProfileService {
	static let shared: ProfileService = .init()
	private var task: URLSessionTask?
	private let decoder: DecodeService = .shared
	private(set) var profile: Profile?
	
	private init() {}
	
	func fetchProfile(token: String, completion: @escaping(Result<Profile, Error>) -> Void) {
		assert(Thread.isMainThread, "\(#function) called not in main thread")
		guard 
			let request = getBaseUserInformationRequest(token: token),
			task == nil
		else {
			completion(.failure(ProfileServiceError.invalidRequest))
			return
		}
		
		task?.cancel()
		
		let task = URLSession.shared.data(for: request) { [weak self] result in
			guard let self else {
				preconditionFailure("No ProfileService initialized")
			}
			self.task = nil
			switch result {
			case .success(let data):
				do {
					let responseBody = try self.decoder.decode(ProfileResponseBody.self, from: data)
					let profile = Profile(
						username: responseBody.username,
						name: [responseBody.firstName, responseBody.lastName ?? ""].joined(separator: " "),
						bio: responseBody.bio
					)
					self.profile = profile
					completion(.success(profile))
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
	
	private func getBaseUserInformationRequest(token: String) -> URLRequest? {
		guard let url = URL(string: Constants.URLs.baseURLString + Constants.APIPaths.baseUser) else { return nil }
		var request = URLRequest(url: url)
		request.setValue("Bearer \(token)", forHTTPHeaderField: Constants.Token.requestHeader)
		return request
	}
}
