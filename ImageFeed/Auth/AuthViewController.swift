//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Denis on 25.07.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
	func didAuthenticate(_ viewController: AuthViewController)
}

final class AuthViewController: UIViewController {
	
	private let oAuth2Service = OAuth2Service.shared
	private let oAuth2Storage = OAuth2TokenStorageService.shared
	
	weak var delegate: AuthViewControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureBackButton()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if
			segue.identifier == Constants.Segues.webView,
			let webViewViewController = segue.destination as? WebViewViewController {
			webViewViewController.delegate = self
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}
	
	private func configureBackButton() {
		navigationController?.navigationBar.backIndicatorImage = .navBackButton
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = .navBackButton
		navigationItem.backBarButtonItem = UIBarButtonItem(
			title: "",
			style: .plain,
			target: .none,
			action: #selector(webViewViewControllerDidCancel)
		)
		navigationItem.backBarButtonItem?.tintColor = .ypBlack
	}
	
	@objc private func webViewViewControllerDidCancel() {
		dismiss(animated: true)
	}
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
	
	func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String) {
		viewController.dismiss(animated: true)
		oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
			guard let self, let delegate = self.delegate else { return }
			switch result {
			case .success(let token):
				self.oAuth2Storage.token = token
				delegate.didAuthenticate(self)
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
}
