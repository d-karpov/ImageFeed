//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Denis on 20.09.2024.
//

import XCTest
import ImageFeed

final class ImageFeedUITests: XCTestCase {
	private let app = XCUIApplication()
	private enum TestSettings {
		static let loading: TimeInterval = 5
		static let maxScale: Double = 3
		static let minScale: Double = 0.5
		static let velocity: Double = 1
		
		/// Необходимо вписать свои данные учетки для тестирования
		enum Credentials {
			static let login = ""
			static let password = ""
		}
	}
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		app.launchEnvironment = ["isUITesting": "YES"]
		app.launch()
		
	}
	
	@MainActor
	func testAuth() throws {
		let authButton = app.buttons[UIElementsIdentifiers.loginButton]
		XCTAssertTrue(authButton.waitForExistence(timeout: TestSettings.loading))
		authButton.tap()
		let webView = app.webViews[UIElementsIdentifiers.webView]
		XCTAssertTrue(webView.waitForExistence(timeout: TestSettings.loading))
		let loginTextField = webView.descendants(matching: .textField).element
		XCTAssertTrue(loginTextField.waitForExistence(timeout: TestSettings.loading))
		loginTextField.tap()
		loginTextField.typeText(TestSettings.Credentials.login)
		let passwordTextField = webView.descendants(matching: .secureTextField).element
		XCTAssertTrue(passwordTextField.waitForExistence(timeout: TestSettings.loading))
		passwordTextField.tap()
		passwordTextField.typeText(TestSettings.Credentials.password)
		webView.buttons[UIElementsIdentifiers.webViewLoginButton].tap()
		let tableQuery = app.tables
		let cell = tableQuery.cells.element(boundBy: 0)
		XCTAssertTrue(cell.waitForExistence(timeout: TestSettings.loading))
	}
	
	@MainActor
	func testFeed() throws {
		let tableQuery = app.tables
		let cell = tableQuery.cells.element(boundBy: 0)
		XCTAssertTrue(cell.waitForExistence(timeout: TestSettings.loading))
		cell.swipeUp()
		let cellToLike = tableQuery.cells.element(boundBy: 2)
		XCTAssertTrue(cellToLike.waitForExistence(timeout: TestSettings.loading))
		let onLikeButton = cellToLike.buttons[UIElementsIdentifiers.likeButtonOn]
		XCTAssertTrue(onLikeButton.waitForExistence(timeout: TestSettings.loading))
		onLikeButton.tap()
		let offLikeButton = cellToLike.buttons[UIElementsIdentifiers.likeButtonOff]
		XCTAssertTrue(offLikeButton.waitForExistence(timeout: TestSettings.loading))
		offLikeButton.tap()
		XCTAssertTrue(onLikeButton.waitForExistence(timeout: TestSettings.loading))
		cellToLike.tap()
		let image = app.scrollViews.images.element(boundBy: 0)
		XCTAssertTrue(image.waitForExistence(timeout: TestSettings.loading))
		image.pinch(withScale: TestSettings.maxScale, velocity: TestSettings.velocity)
		image.pinch(withScale: TestSettings.minScale, velocity: -TestSettings.velocity)
		let backButton = app.buttons[UIElementsIdentifiers.backButton]
		backButton.tap()
		XCTAssertTrue(cellToLike.waitForExistence(timeout: TestSettings.loading))
	}
	
	@MainActor
	func testProfile() throws {
		let tabBarItemProfile = app.tabBars.buttons.element(boundBy: 1)
		XCTAssertTrue(tabBarItemProfile.waitForExistence(timeout: TestSettings.loading))
		tabBarItemProfile.tap()
		XCTAssertTrue(app.staticTexts[UIElementsIdentifiers.loginLabel].exists)
		XCTAssertTrue(app.staticTexts[UIElementsIdentifiers.nameLabel].exists)
		XCTAssertTrue(app.staticTexts[UIElementsIdentifiers.infoLabel].exists)
		XCTAssertTrue(app.images[UIElementsIdentifiers.profileImage].exists)
		let logoutButton = app.buttons[UIElementsIdentifiers.logoutButton]
		XCTAssertTrue(logoutButton.waitForExistence(timeout: TestSettings.loading))
		logoutButton.tap()
		let logoutAlert = app.alerts[UIElementsIdentifiers.logoutTitle]
		XCTAssertTrue(logoutAlert.waitForExistence(timeout: TestSettings.loading))
		logoutAlert.scrollViews.otherElements.buttons[UIElementsIdentifiers.yesButton].tap()
		let authButton = app.buttons[UIElementsIdentifiers.loginButton]
		XCTAssertTrue(authButton.waitForExistence(timeout: TestSettings.loading))
	}
	
}
