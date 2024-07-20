//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Denis on 06.07.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
	@IBOutlet private var tableView: UITableView!
	
	private let photosNames = (0..<20).map{ "\($0)" }
	private let singleImageSegueIdentifier = "ShowSingleImage"
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == singleImageSegueIdentifier {
			guard
				let viewController = segue.destination as? SingleImageViewController,
				let indexPath = sender as? IndexPath
			else {
				assertionFailure("Invalid segue destination")
				return
			}
			
			if let imageName = photosNames[safe: indexPath.row], let image = UIImage(named: imageName) {
				viewController.image = image
			}
			
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}

}

//MARK: - Private Methods
private extension ImagesListViewController {
	func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
		guard let imageName = photosNames[safe: indexPath.row], let image = UIImage(named: imageName) else {
			return
		}
		cell.cellImage.image = image
		cell.likeButton.setImage(indexPath.row.isMultiple(of: 2) ? .activeLike : .noActiveLike, for: .normal)
		cell.dateLabel.text = Date().dateNoTimeString
	}
}

//MARK: - UITableViewDataSource Implementation
extension ImagesListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		photosNames.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
extension ImagesListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let image = UIImage(named: photosNames[indexPath.row]) else {
			return 0
		}
		
		let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
		let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
		let imageWidth = image.size.width
		let scale = imageViewWidth / imageWidth
		let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
		return cellHeight
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: singleImageSegueIdentifier, sender: indexPath)
	}
}
