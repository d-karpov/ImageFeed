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
	private let dataFormatter = ISO8601DateFormatter()
	private(set) var photos: [Photo] = []
	private var currentPage = 0
	private var task: URLSessionTask?
	
	func fetchPhotosNextPage() {
		guard task == nil else { return }
		guard let request = requestBuilder.madeRequest(for: .photos(currentPage+1)) else {
			print(ImageListServiceError.invalidRequest.localizedDescription)
			return
		}
		
		let task = URLSession.shared
			.objectTask(for: request) { [weak self] (result: Result<[PhotosResponseBody], Error>) in
				switch result {
				case .success(let response):
					response.forEach { photoResponseBody in
						if let photo = self?.makePhotoFromResponse(from: photoResponseBody) {
							self?.photos.append(photo)
						}
					}
					NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
					self?.currentPage += 1
					self?.task = nil
				case .failure(let error):
					self?.task = nil
					print("[\(#fileID)]:[\(#function)] -> " + error.localizedDescription)
				}
			}
		self.task = task
		task.resume()
	}
	
	func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
		guard let request = requestBuilder.madeRequest(for: .like(photoId, isLike)) else {
			print(ImageListServiceError.invalidRequest.localizedDescription)
			return
		}
		if let photoIndex = photos.firstIndex(where: { $0.id == photoId }) {
			let task = URLSession.shared
				.objectTask(for: request) { [weak self] (result: Result<LikeResponseBody, Error>) in
					switch result {
					case .success(let likeResponseBody):
						if let photo = self?.makePhotoFromResponse(from: likeResponseBody.photo) {
							self?.photos[photoIndex] = photo
							completion(.success(photo))
						}
					case .failure(let error):
						completion(.failure(error))
					}
				}
			task.resume()
		}
	}
	
	private func makePhotoFromResponse(from photoResponseBody: PhotosResponseBody) -> Photo {
		let createdAt = dataFormatter.date(from: photoResponseBody.createdAt)
		let photo = Photo(
			id: photoResponseBody.id,
			size: .init(width: photoResponseBody.width, height: photoResponseBody.height),
			createdAt: createdAt,
			welcomeDescription: photoResponseBody.altDescription,
			thumbImageURL: photoResponseBody.urls.small,
			largeImageURL: photoResponseBody.urls.full,
			isLiked: photoResponseBody.likedByUser
		)
		return photo
	}
	
}
