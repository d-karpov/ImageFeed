//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Denis on 11.08.2024.
//

import Foundation

enum ProfileImageServiceError: Error, LocalizedError {
	case invalidRequest
	case noImageUrl
	
	var errorDescription: String? {
		switch self {
		case .invalidRequest: return "[\(#fileID)]:[\(#function)] Invalid or doubled request from ProfileImageService"
		case .noImageUrl: return "[\(#fileID)]:[\(#function)] No URL for profile image at response"
		}
	}
}

final class ProfileImageService {
	static let shared: ProfileImageService = .init()
	static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
	private var task: URLSessionTask?
	private let requestBuilder: RequestsBuilderService = .shared
	private(set) var profileImageURLString: String?
	
	private init() {}
	
	func fetchProfileImage(userName: String, completion: @escaping(Result<String, Error>) -> Void) {
		assert(Thread.isMainThread, "\(#function) called not in main thread")
		guard
			let request = requestBuilder.madeRequest(for: .userImage(userName)),
			task == nil
		else {
			completion(.failure(ProfileImageServiceError.invalidRequest))
			return
		}
		
		task?.cancel()
		
		let task = URLSession.shared
			.objectTask(for: request) { [weak self] (result: Result<UserResponseBody, Error>) in
				guard let self else { preconditionFailure("No ProfileImageService initialized") }
				self.task = nil
				switch result {
				case .success(let responseBody):
					guard
						let profileImageURLString = responseBody.profileImage[Constants.ImageSizes.profileImage]
					else {
						return completion(.failure(ProfileImageServiceError.noImageUrl))
					}
					self.profileImageURLString = profileImageURLString
					completion(.success(profileImageURLString))
					NotificationCenter.default.post(
						name: ProfileImageService.didChangeNotification,
						object: self,
						userInfo: nil
					)
				case .failure(let error):
					completion(.failure(error))
				}
			}
		
		self.task = task
		task.resume()
	}
}
