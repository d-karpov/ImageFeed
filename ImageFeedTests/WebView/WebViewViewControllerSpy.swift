//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Denis on 19.09.2024.
//
@testable import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
	var presenter: WebViewPresenterProtocol?
	var loadRequestCalled: Bool = false
	
	func load(request: URLRequest) {
		loadRequestCalled = true
	}
	func setProgressValue(_ newValue: Float) { }
	func setProgressHidden(_ isHidden: Bool) { }
}
