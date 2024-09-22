//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Denis on 21.09.2024.
//
@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {

	func testViewControllerCallsViewDidLoad() {
		let sut = ProfileViewController()
		let presenter = ProfileViewPresenterSpy()
		sut.presenter = presenter
		presenter.view = sut
		_ = sut.view
		XCTAssertTrue(presenter.didLoadCalled)
	}
	
	func testPresenterCallsPresent() {
		let profileHelperStub = ProfileHelperStub()
		let sut = ProfileViewPresenter(profileHelper: profileHelperStub)
		let viewController = ProfileViewControllerSpy()
		viewController.presenter = sut
		sut.view = viewController
		sut.logout()
		XCTAssertTrue(viewController.presetDidCalled)
	}
	
	func testPresenterUpdateProfile() {
		let profileHelperStub = ProfileHelperStub()
		let sut = ProfileViewPresenter(profileHelper: profileHelperStub)
		let viewController = ProfileViewControllerSpy()
		viewController.presenter = sut
		sut.view = viewController
		sut.viewDidLoad()
		XCTAssertTrue(viewController.setImageDidCalled)
		XCTAssertTrue(viewController.setInfoDidCalled)
		XCTAssertTrue(viewController.setNameDidCalled)
		XCTAssertTrue(viewController.setLoginDidCalled)
	}
}
