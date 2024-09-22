//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Denis on 22.09.2024.
//
@testable import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
	var view: ImagesListViewControllerProtocol?
	var viewDidLoadCalled: Bool = false
	var fetchNextPageDidCalled: Bool = false
	var didSelectCellDidCalled: Bool = false
	var configureCellDidCalled: Bool = false
	
	func viewDidLoad() {
		viewDidLoadCalled.toggle()
	}
	
	func setNumberOfRows() -> Int {
		10
	}
	
	func getImageSize(at indexPath: IndexPath) -> CGSize? {
		CGSize(width: 3000, height: 2000)
	}
	
	func configureCell(for cell: ImageFeed.ImagesListCell, with indexPath: IndexPath) {
		configureCellDidCalled.toggle()
	}
	
	func didSelectedCell(at indexPath: IndexPath) {
		didSelectCellDidCalled.toggle()
	}
	
	func fetchNextPage(_ currentRow: Int) {
		fetchNextPageDidCalled.toggle()
	}
}

