//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Denis on 25.07.2024.
//

import UIKit
import WebKit

protocol WebViewViewControllerProtocol: AnyObject {
	var presenter: WebViewPresenterProtocol? { get set }
	func load(request: URLRequest)
	func setProgressValue(_ newValue: Float)
	func setProgressHidden(_ isHidden: Bool)
}

protocol WebViewViewControllerDelegate: AnyObject {
	func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
	private let webView: WKWebView = .init()
	private let progressView: UIProgressView = .init(progressViewStyle: .bar)
	private var estimatedProgressObservation: NSKeyValueObservation?
	var presenter: WebViewPresenterProtocol?
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
					presenter?.didUpdateProgress(webView.estimatedProgress)
				}
			}
		)
		presenter?.viewDidLoad()
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
	
	func load(request: URLRequest) {
		webView.load(request)
	}
	
	func setProgressValue(_ newValue: Float) {
		progressView.setProgress(newValue, animated: true)
	}
	
	func setProgressHidden(_ isHidden: Bool) {
		progressView.isHidden = isHidden
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
		if let url = navigationAction.request.url {
			return presenter?.code(from: url)
		} else {
			return .none
		}
	}
}
