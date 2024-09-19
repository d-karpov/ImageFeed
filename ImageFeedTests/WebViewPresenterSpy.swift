//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Denis on 19.09.2024.
//

@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
	var viewDidLoadCalled: Bool = false
	var view: WebViewViewControllerProtocol?
	
	func viewDidLoad() {
		viewDidLoadCalled = true
	}
	func didUpdateProgress(_ newValue: Double) { }
	func code(from url: URL) -> String? { nil }
}
