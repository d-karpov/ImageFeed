//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Denis on 19.09.2024.
//

import Foundation


protocol WebViewPresenterProtocol: AnyObject {
	var view: WebViewViewControllerProtocol? { get set }
	func viewDidLoad()
	func didUpdateProgress(_ newValue: Double)
	func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
	weak var view: WebViewViewControllerProtocol?
	private let authHelper: AuthHelperProtocol
	
	init(authHelper: AuthHelperProtocol) {
		self.authHelper = authHelper
	}
	
	func viewDidLoad() {
		if let request = authHelper.authRequest() {
			view?.load(request: request)
		} else {
			preconditionFailure("Wrong Auth request! \(#function) line - \(#line)")
		}
	}
	
	func didUpdateProgress(_ newValue: Double) {
		let newProgressValue = Float(newValue)
		let shouldHideProgress = abs(newProgressValue - 1.0) <= 0.0001
		view?.setProgressValue(shouldHideProgress ? 0 : newProgressValue)
		view?.setProgressHidden(shouldHideProgress)
	}
	
	func code(from url: URL) -> String? {
		authHelper.code(from: url)
	}
}

