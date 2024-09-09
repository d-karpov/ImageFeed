//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Denis on 06.07.2024.
//

import UIKit

final class ImagesListViewController: UITableViewController {
	private let photosNames = (0..<20).map{ "\($0)" }
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.backgroundColor = .ypBlack
		tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
		tableView.contentInset = UIEdgeInsets(
			top: Sizes.TableView.ContentInsets.top,
			left: Sizes.TableView.ContentInsets.left,
			bottom: Sizes.TableView.ContentInsets.bottom,
			right: Sizes.TableView.ContentInsets.right
		)
	}
}

//MARK: - Private Methods
private extension ImagesListViewController {
	func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
		guard let imageName = photosNames[safe: indexPath.row], let image = UIImage(named: imageName) else {
			return
		}
		cell.configure(
			image: image,
			date: Date().dateNoTimeString,
			likeState: indexPath.row.isMultiple(of: 2) ? .activeLike : .noActiveLike
		)
	}
}

//MARK: - UITableViewDataSource Implementation
extension ImagesListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		photosNames.count
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
		guard let image = UIImage(named: photosNames[indexPath.row]) else {
			return 0
		}
		
		let imageInsets = UIEdgeInsets(
			top: Sizes.TableView.ImageInsets.top,
			left: Sizes.TableView.ImageInsets.left,
			bottom: Sizes.TableView.ImageInsets.bottom,
			right: Sizes.TableView.ImageInsets.right
		)
		let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
		let imageWidth = image.size.width
		let scale = imageViewWidth / imageWidth
		let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
		return cellHeight
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let singleImageViewController = SingleImageViewController()
		if let imageName = photosNames[safe: indexPath.row], let image = UIImage(named: imageName) {
			singleImageViewController.image = image
		}
		singleImageViewController.modalPresentationStyle = .fullScreen
		present(singleImageViewController, animated: true)
	}
}
