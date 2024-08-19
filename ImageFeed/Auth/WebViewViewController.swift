//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Denis on 25.07.2024.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
	func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String)
}


final class WebViewViewController: UIViewController {
	@IBOutlet private weak var webView: WKWebView!
	@IBOutlet private weak var progressView: UIProgressView!
	
	private var estimatedProgressObservation: NSKeyValueObservation?
	
	weak var delegate: WebViewViewControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		webView.navigationDelegate = self
		estimatedProgressObservation = webView.observe(
			\.estimatedProgress,
			changeHandler: { [weak self] _,_ in
				if let self {
					self.updateProgress()
				}
			}
		)
		loadAuthView()
	}
	
	private func updateProgress() {
		let status = fabs(webView.estimatedProgress - 1.0) <= 0.0001
		progressView.setProgress( status ? 0 : Float(webView.estimatedProgress), animated: true)
		progressView.isHidden = status
	}
	
	private func loadAuthView() {
		guard var urlComponents = URLComponents(string: Constants.URLs.authorizeURLString) else { return }
		
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: Constants.API.accessKey),
			URLQueryItem(name: "redirect_uri", value: Constants.API.redirectURI),
			URLQueryItem(name: "response_type", value: "code"),
			URLQueryItem(name: "scope", value: Constants.API.accessScope),
		]
		
		guard let url = urlComponents.url else {
			return
		}
		let request = URLRequest(url: url)
		webView.load(request)
	}
}

extension WebViewViewController: WKNavigationDelegate {
	func webView(
		_ webView: WKWebView,
		decidePolicyFor navigationAction: WKNavigationAction,
		decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
	) {
		if let code = code(from: navigationAction) {
			delegate?.webViewViewController(self, didAuthenticateWithCode: code)
			decisionHandler(.cancel)
		} else {
			decisionHandler(.allow)
		}
	}
	
	private func code(from navigationAction: WKNavigationAction ) -> String? {
		if
			let url = navigationAction.request.url,
			let urlComponents = URLComponents(string: url.absoluteString),
			urlComponents.path == "/oauth/authorize/native",
			let item = urlComponents.queryItems,
			let codeItem = item.first(where: { $0.name == "code"} )
		{
			return codeItem.value
		} else {
			return .none
		}
	}
}
