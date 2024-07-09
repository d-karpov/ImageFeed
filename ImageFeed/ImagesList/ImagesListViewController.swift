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
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.rowHeight = 200
		tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
	}

}

//MARK: - Private Methods
private extension ImagesListViewController {
	func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
		guard let name = photosNames[safe: indexPath.row], let image = UIImage(named: name) else {
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
		let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier)
		guard let imageListCell = cell as? ImagesListCell else {
			return UITableViewCell()
		}
		configCell(for: imageListCell, with: indexPath)
		return imageListCell
	}
	
}

//MARK: - UITableViewDelegate Implementation
extension ImagesListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
	
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
}
