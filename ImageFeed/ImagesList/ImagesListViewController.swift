//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Denis on 06.07.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
	@IBOutlet private var tableView: UITableView!
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.rowHeight = 200
		tableView.contentInset = UIEdgeInsets(
			top: 16,
			left: 0,
			bottom: 16,
			right: 0
		)
	}
	
	func configCell(for cell: ImagesListCell) {
		
	}
}

//MARK: - UITableViewDataSource Implementation
extension ImagesListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier)
		guard let imageListCell = cell as? ImagesListCell else {
			return UITableViewCell()
		}
		configCell(for: imageListCell)
		return imageListCell
	}
	
	
}

//MARK: - UITableViewDelegate Implementation
extension ImagesListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}
