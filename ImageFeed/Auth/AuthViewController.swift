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
			action: #selector(didTapedBackButton)
		)
		navigationItem.backBarButtonItem?.tintColor = .ypBlack
	}
	
	
	@objc private func didTapedBackButton() {
		dismiss(animated: true)
	}
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
	
	func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String) {
		UIBlockingProgressHUD.show()
		viewController.navigationController?.popToRootViewController(animated: true)
		oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
			guard let self, let delegate = self.delegate else {
				preconditionFailure("No more self or self.delegate exist at the moment. Caller - \(#function)")
			}
			UIBlockingProgressHUD.dismiss()
			switch result {
			case .success(let token):
				self.oAuth2Storage.token = token
				delegate.didAuthenticate(self)
			case .failure(let error):
				AlertPresenter.show(
					with: Alert(
						title: Constants.AlertTexts.title,
						message: Constants.AlertTexts.authMessage,
						buttonText: Constants.AlertTexts.buttonText,
						action: {
							print(error.localizedDescription)
						}
					),
					at: self
				)
			}
		}
	}
}
