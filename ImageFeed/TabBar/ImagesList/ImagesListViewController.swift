//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Denis on 06.07.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UITableViewController {
	private var imageListServiceObserver: NSObjectProtocol?
	private let photosService = ImageListService()
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		photosService.fetchPhotosNextPage()
		tableView.backgroundColor = .ypBlack
		tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
		tableView.contentInset = UIEdgeInsets(
			top: Sizes.TableView.ContentInsets.top,
			left: Sizes.TableView.ContentInsets.left,
			bottom: Sizes.TableView.ContentInsets.bottom,
			right: Sizes.TableView.ContentInsets.right
		)
		imageListServiceObserver = NotificationCenter.default.addObserver(
			forName: ImageListService.didChangeNotification,
			object: nil,
			queue: .main,
			using: { [weak self] _ in
				self?.updateTableViewAnimated()
			}
		)
	}
}

//MARK: - Private Methods
private extension ImagesListViewController {
	func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
		guard let photo = photosService.photos[safe: indexPath.row] else {
			return
		}
		let imageName = photo.thumbImageURL
		cell.delegate = self
		cell.configure(
			image: imageName,
			date: photo.createdAt?.dateNoTimeString ?? Date().dateNoTimeString,
			likeState: photo.isLiked
		)
	}
	
	func updateTableViewAnimated() {
		let currentPhotosCount = tableView.numberOfRows(inSection: 0)
		let newPhotosCount = photosService.photos.count
		if currentPhotosCount != newPhotosCount {
			tableView.performBatchUpdates {
				let indexPaths = (currentPhotosCount..<newPhotosCount).map { index in
					IndexPath(row: index, section: 0)
				}
				tableView.insertRows(at: indexPaths, with: .automatic)
			}
		}
	}
}

//MARK: - UITableViewDataSource Implementation
extension ImagesListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		photosService.photos.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let imageListCell = tableView.dequeueReusableCell(
			withIdentifier: ImagesListCell.reuseIdentifier,
			for: indexPath
		) as? ImagesListCell else {
			return UITableViewCell()
		}
		configCell(for: imageListCell, with: indexPath)
		return imageListCell
	}
	
}

//MARK: - UITableViewDelegate Implementation
extension ImagesListViewController {
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let image = photosService.photos[safe: indexPath.row]
		let imageInsets = UIEdgeInsets(
			top: Sizes.TableView.ImageInsets.top,
			left: Sizes.TableView.ImageInsets.left,
			bottom: Sizes.TableView.ImageInsets.bottom,
			right: Sizes.TableView.ImageInsets.right
		)
		let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
		if let imageWidth = image?.size.width, let imageHeight = image?.size.height  {
			let scale = imageViewWidth / imageWidth
			let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
			return cellHeight
		}
		return 200
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let singleImageViewController = SingleImageViewController()
		if let imageURLString = photosService.photos[safe: indexPath.row]?.largeImageURL {
			singleImageViewController.imageURLString = imageURLString
		}
		singleImageViewController.modalPresentationStyle = .fullScreen
		present(singleImageViewController, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == photosService.photos.count - 1 {
			photosService.fetchPhotosNextPage()
		}
	}
}

//MARK: - ImagesListCellDelegate Implementation
extension ImagesListViewController: ImagesListCellDelegate {
	func imageListCellDidTapLike(_ cell: ImagesListCell) {
		if let photoIndex = tableView.indexPath(for: cell), let photo = photosService.photos[safe: photoIndex.row] {
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
