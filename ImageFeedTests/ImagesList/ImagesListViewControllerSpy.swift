//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Denis on 22.09.2024.
//
@testable import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
	var presenter: ImagesListViewPresenterProtocol?
	var presentDidCalled: Bool = false
	var updateTableViewAnimatedDidCalled: Bool = false
	
	func indexPathForCell(_ cell: UITableViewCell) -> IndexPath? {
		.init(row: 5, section: 0)
	}
	
	func updateTableViewAnimated(with indexPaths: [IndexPath]) {
		updateTableViewAnimatedDidCalled.toggle()
	}
	
	func present(_ viewController: UIViewController) {
		presentDidCalled.toggle()
	}
	
}
