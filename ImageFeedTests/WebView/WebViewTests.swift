//
//  WebViewTests.swift
//  WebViewTests
//
//  Created by Denis on 19.09.2024.
//
@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
	
	func testViewControllerCallsViewDidLoad() {
		let sut = WebViewViewController()
		let presenter = WebViewPresenterSpy()
		sut.presenter = presenter
		presenter.view = sut
		
		_ = sut.view
		
		XCTAssertTrue(presenter.viewDidLoadCalled)
	}
	
	func testPresenterCallsLoadRequest() {
		let viewController = WebViewViewControllerSpy()
		let sut = WebViewPresenter(authHelper: AuthHelper())
		viewController.presenter = sut
		sut.view = viewController
	
		sut.viewDidLoad()
		
		XCTAssertTrue(viewController.loadRequestCalled)
	}
	
	func testProgressVisibleWhenLessThenOne() {
		let sut = WebViewPresenter(authHelper: AuthHelper())
		let progress: Float = 0.6
		
		let shouldHideProgress = sut.shouldHideProgress(for: progress)
		
		XCTAssertFalse(shouldHideProgress)
	}
	
	func testProgressHiddenWhenOne() {
		let sut = WebViewPresenter(authHelper: AuthHelper())
		let progress: Float = 1.0
		
		let shouldHideProgress = sut.shouldHideProgress(for: progress)
		
		XCTAssertTrue(shouldHideProgress)
	}
	
	func testAuthHelperAuthURL() {
		let configuration = AuthConfiguration.standard
		let sut = AuthHelper(configuration: configuration)
		let url = sut.authURL()
		
		guard let urlString = url?.absoluteString else {
			XCTFail("Auth URL is nil")
			return
		}
		
		XCTAssertTrue(urlString.contains(configuration.authURLString))
		XCTAssertTrue(urlString.contains(configuration.accessKey))
		XCTAssertTrue(urlString.contains(configuration.redirectURI))
		XCTAssertTrue(urlString.contains(configuration.accessScope))
		XCTAssertTrue(urlString.contains("code"))
	}
	
	func testCodeFromURL() {
		guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native") else {
			XCTFail("Can't build URLComponents from string")
			return
		}
		urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
		guard let url = urlComponents.url else {
			XCTFail("Can't get URL from URLComponents")
			return
		}
		let sut = AuthHelper()
		let code = sut.code(from: url)
		XCTAssertEqual(code, "test code")
	}
}

