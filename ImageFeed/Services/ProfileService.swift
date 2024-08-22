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
		case .invalidRequest: return "[\(#fileID)]:[\(#function)] -> Invalid or doubled request from ProfileService"
		}
	}
}

final class ProfileService {
	static let shared: ProfileService = .init()
	private var task: URLSessionTask?
	private let requestBuilder: RequestsBuilderService = .shared
	private(set) var profile: Profile?
	
	private init() {}
	
	func fetchProfile(completion: @escaping(Result<Profile, Error>) -> Void) {
		assert(Thread.isMainThread, "\(#function) called not in main thread")
		guard
			let request = requestBuilder.madeRequest(for: .userBaseData),
			task == nil
		else {
			//Принт дублирует вывод ошибки в консоль - добавлен согласно требованиям.
			print("\(ProfileServiceError.invalidRequest.localizedDescription)")
			completion(.failure(ProfileServiceError.invalidRequest))
			return
		}
		
		task?.cancel()
		
		let task = URLSession.shared
			.objectTask(for: request) { [weak self] (result: Result<ProfileResponseBody, Error>) in
				guard let self else { preconditionFailure("No ProfileService initialized") }
				self.task = nil
				switch result {
				case .success(let responseBody):
					let profile = Profile(
						username: responseBody.username,
						name: [responseBody.firstName, responseBody.lastName ?? ""].joined(separator: " "),
						bio: responseBody.bio
					)
					self.profile = profile
					completion(.success(profile))
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
