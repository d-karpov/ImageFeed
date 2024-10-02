//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Denis on 22.09.2024.
//
@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
	private enum TestSettings {
		static let tableSize = CGSize(width: 500, height: 500)
		static let indexPath = IndexPath(row: 5, section: 0)
	}
	
	func testViewControllerCallsViewDidLoad() {
		let sut = ImagesListViewController()
		let presenter = ImagesListViewPresenterSpy()
		sut.presenter = presenter
		presenter.view = sut
		_ = sut.view
		XCTAssertTrue(presenter.viewDidLoadCalled)
	}
	
	func testViewControllerCallsFetchNextPage() {
		let sut = ImagesListViewController()
		let presenter = ImagesListViewPresenterSpy()
		sut.presenter = presenter
		presenter.view = sut
		_ = sut.view
		sut.tableView(sut.tableView, willDisplay: .init(), forRowAt: TestSettings.indexPath)
		XCTAssertTrue(presenter.fetchNextPageDidCalled)
	}
	
	func testViewControllerGetNumberOfRows() {
		let sut = ImagesListViewController()
		let presenter = ImagesListViewPresenterSpy()
		sut.presenter = presenter
		presenter.view = sut
		_ = sut.view
		XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 10)
	}
	
	func testViewControllerGetNotDefaultRowHeight() {
		let sut = ImagesListViewController()
		let presenter = ImagesListViewPresenterSpy()
		sut.presenter = presenter
		presenter.view = sut
		_ = sut.view
		sut.tableView.bounds.size = TestSettings.tableSize
		let rowHeight = sut.tableView(sut.tableView, heightForRowAt: TestSettings.indexPath)
		XCTAssertNotEqual(rowHeight, 200)
	}
	
	func testViewControllerCallsCellDidSelected() {
		let sut = ImagesListViewController()
		let presenter = ImagesListViewPresenterSpy()
		sut.presenter = presenter
		presenter.view = sut
		_ = sut.view
		sut.tableView(sut.tableView, didSelectRowAt: TestSettings.indexPath)
		XCTAssertTrue(presenter.didSelectCellDidCalled)
	}
	
	func testViewControllerCallsCellConfiguration() {
		let sut = ImagesListViewController()
		let presenter = ImagesListViewPresenterSpy()
		sut.presenter = presenter
		presenter.view = sut
		_ = sut.view
		sut.tableView.bounds.size = TestSettings.tableSize
		_ = sut.tableView(sut.tableView, cellForRowAt: TestSettings.indexPath)
		XCTAssertTrue(presenter.configureCellDidCalled)
	}
	
	func testPresenterCallIndexPathForCell() {
		let sut = ImagesListViewPresenter()
		let viewController = ImagesListViewControllerSpy()
		viewController.presenter = sut
		sut.view = viewController
		let cell = ImagesListCell()
		cell.delegate = sut
		cell.delegate?.imageListCellDidTapLike(cell)
		XCTAssertEqual(viewController.indexPathForCell(cell), TestSettings.indexPath)
	}
}
