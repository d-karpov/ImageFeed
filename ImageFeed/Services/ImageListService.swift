//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Denis on 11.09.2024.
//

import Foundation

enum ImageListServiceError: LocalizedError {
	case invalidRequest
	
	var errorDescription: String? {
		switch self {
		case .invalidRequest: return "[\(#fileID)]:[\(#function)] Invalid request from ProfileImageService"
		}
	}
}

final class ImageListService {
	static let didChangeNotification: Notification.Name = .init("ImageListServiceDidChange")
	
	private let requestBuilder: RequestsBuilderService = .shared
	private (set) var photos: [Photo] = []
	private var currentPage = 0
	private var task: URLSessionTask?
	
	func fetchPhotosNextPage() {
		if task == nil {
			guard let request = requestBuilder.madeRequest(for: .photos(currentPage+1)) else {
				print(ImageListServiceError.invalidRequest.localizedDescription)
				return
			}
			
			let task = URLSession.shared
				.objectTask(for: request) { [weak self] (result: Result<[PhotosResponseBody], Error>) in
					switch result {
					case .success(let response):
						response.forEach { photoResponseBody in
							let createdAt = ISO8601DateFormatter().date(from: photoResponseBody.createdAt)
							let photo = Photo(
								id: photoResponseBody.id,
								size: .init(width: photoResponseBody.width, height: photoResponseBody.height),
								createdAt: createdAt,
								welcomeDescription: photoResponseBody.altDescription,
								thumbImageURL: photoResponseBody.urls.small,
								largeImageURL: photoResponseBody.urls.full,
								isLiked: photoResponseBody.likedByUser
							)
							self?.photos.append(photo)
						}
						NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
						self?.currentPage += 1 
						self?.task = nil
					case .failure(let error):
						print(error.localizedDescription)
					}
			}
			self.task = task
			task.resume()
		}
	}
}
