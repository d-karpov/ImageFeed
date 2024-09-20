//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Denis on 20.09.2024.
//

import UIKit

protocol ImagesListViewPresenterProtocol: AnyObject {
	var view: ImageListViewControllerProtocol? { get set }
	func viewDidLoad()
	func setNumberOfRows() -> Int
	func getImageSize(at indexPath: IndexPath) -> CGSize?
	func configureCell(for cell: ImagesListCell, with indexPath: IndexPath)
	func didSelectedCell(at indexPath: IndexPath)
	func fetchNextPage(_ currentRow: Int)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
	weak var view: ImageListViewControllerProtocol?
	
	private let photosService: ImageListService = .init()
	private var imageListServiceObserver: NSObjectProtocol?
	private var currentPhotosCount = 0
	
	init() {
		imageListServiceObserver = NotificationCenter.default.addObserver(
			forName: ImageListService.didChangeNotification,
			object: nil,
			queue: .main,
			using: { [weak self] _ in
				self?.updateTableViewAnimated()
			}
		)
	}
	
	func viewDidLoad() {
		photosService.fetchPhotosNextPage()
	}
	
	func setNumberOfRows() -> Int {
		photosService.photos.count
	}
	
	func getImageSize(at indexPath: IndexPath) -> CGSize? {
		guard let image = photosService.photos[safe: indexPath.row] else { return nil }
		return image.size
		
	}
	
	func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
		guard let photo = photosService.photos[safe: indexPath.row] else { return }
		let imageName = photo.thumbImageURL
		cell.delegate = self
		cell.configure(
			image: imageName,
			date: photo.createdAt?.dateNoTimeString ?? "",
			likeState: photo.isLiked
		)
	}
	
	func updateTableViewAnimated() {
		let newPhotosCount = photosService.photos.count
		if currentPhotosCount != newPhotosCount {
			let indexes = (currentPhotosCount..<newPhotosCount).map { IndexPath(row: $0, section: 0) }
			currentPhotosCount = newPhotosCount
			view?.updateTableViewAnimated(with: indexes)
		}
	}
	
	func didSelectedCell(at indexPath: IndexPath) {
		let singleImageViewController = SingleImageViewController()
		if let imageURLString = photosService.photos[safe: indexPath.row]?.largeImageURL {
			singleImageViewController.imageURLString = imageURLString
		}
		singleImageViewController.modalPresentationStyle = .fullScreen
		view?.present(singleImageViewController)
	}
	
	func fetchNextPage(_ currentRow: Int) {
		if currentRow == photosService.photos.count - 1 {
			photosService.fetchPhotosNextPage()
		}
	}
}
//MARK: - ImagesListCellDelegate Implementation
extension ImagesListViewPresenter: ImagesListCellDelegate {
	func imageListCellDidTapLike(_ cell: ImagesListCell) {
		if let photoIndex = view?.indexPathForCell(cell), let photo = photosService.photos[safe: photoIndex.row] {
			UIBlockingProgressHUD.show()
			photosService.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
				UIBlockingProgressHUD.dismiss()
				switch result {
				case .success(let photo):
					cell.setLikeImage(isLike: photo.isLiked)
				case .failure(let error):
					print("[\(#fileID)]:[\(#function)] -> " + error.localizedDescription)
				}
			}
		}
	}
}
