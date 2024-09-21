//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Denis on 06.07.2024.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
	var presenter: ImagesListViewPresenterProtocol? { get set }
	func indexPathForCell(_ cell: UITableViewCell) -> IndexPath?
	func updateTableViewAnimated(with indexPaths: [IndexPath])
	func present(_ viewController: UIViewController)
}

final class ImagesListViewController: UITableViewController, ImagesListViewControllerProtocol {
	var presenter: ImagesListViewPresenterProtocol?
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter?.viewDidLoad()
		tableView.backgroundColor = .ypBlack
		tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
		tableView.contentInset = UIEdgeInsets(
			top: Sizes.TableView.ContentInsets.top,
			left: Sizes.TableView.ContentInsets.left,
			bottom: Sizes.TableView.ContentInsets.bottom,
			right: Sizes.TableView.ContentInsets.right
		)
	}
	
	func indexPathForCell(_ cell: UITableViewCell) -> IndexPath? {
		tableView.indexPath(for: cell)
	}
	
	func present(_ viewController: UIViewController) {
		present(viewController, animated: true)
	}
	
	func updateTableViewAnimated(with indexPaths: [IndexPath]) {
		tableView.performBatchUpdates {
			tableView.insertRows(at: indexPaths, with: .automatic)
		}
	}
}
//MARK: - UITableViewDataSource Implementation
extension ImagesListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter?.setNumberOfRows() ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let imageListCell = tableView.dequeueReusableCell(
			withIdentifier: ImagesListCell.reuseIdentifier,
			for: indexPath
		) as? ImagesListCell else {
			return UITableViewCell()
		}
		presenter?.configureCell(for: imageListCell, with: indexPath)
		return imageListCell
	}
}

//MARK: - UITableViewDelegate Implementation
extension ImagesListViewController {
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let imageInsets = UIEdgeInsets(
			top: Sizes.TableView.ImageInsets.top,
			left: Sizes.TableView.ImageInsets.left,
			bottom: Sizes.TableView.ImageInsets.bottom,
			right: Sizes.TableView.ImageInsets.right
		)
		let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
		if let imageSize = presenter?.getImageSize(at: indexPath) {
			let imageWidth = imageSize.width
			let imageHeight = imageSize.height
			let scale = imageViewWidth / imageWidth
			let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
			return cellHeight
		}
		return 200
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.didSelectedCell(at: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		presenter?.fetchNextPage(indexPath.row)
	}
}
