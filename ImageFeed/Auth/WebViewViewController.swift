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
	private let webView: WKWebView = .init()
	private let progressView: UIProgressView = .init(progressViewStyle: .bar)
	private let requestBuilder: RequestsBuilderService = .shared
	private var estimatedProgressObservation: NSKeyValueObservation?
	
	weak var delegate: WebViewViewControllerDelegate?
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .ypWhite
		progressView.progressTintColor = .ypBlack
		setUpSubViews()
		setLayoutSubviews()
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
	
	//MARK: - Private UI methods
	private func setUpSubViews() {
		[
			webView,
			progressView
		].forEach { subView in
			view.addSubview(subView)
		}
	}
	
	private func setLayoutSubviews() {
		webView.translatesAutoresizingMaskIntoConstraints = false
		progressView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate(
			[
				webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			]
		)
	}
	
	//MARK: Private Methods
	private func updateProgress() {
		let status = fabs(webView.estimatedProgress - 1.0) <= 0.0001
		progressView.setProgress( status ? 0 : Float(webView.estimatedProgress), animated: true)
		progressView.isHidden = status
	}
	
	private func loadAuthView() {
		if let request = requestBuilder.madeRequest(for: .auth) {
			webView.load(request)
		} else {
			preconditionFailure("Wrong Auth request! \(#function) line - \(#line)")
		}
	}
}

//MARK: - WKNavigationDelegate Implementation
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
