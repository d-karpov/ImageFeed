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
	private let activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(style: .large)
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.hidesWhenStopped = true
		indicator.color = .ypWhite
		return indicator
	}()
	private lazy var blur: UIView = {
		let blur = UIView()
		blur.frame = view.frame
		blur.backgroundColor = .ypBackground
		blur.isHidden = true
		return blur
	}()
	
	weak var delegate: AuthViewControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureBackButton()
		setUpSubviews()
		setUpConstraints()
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
	
	private func setUpSubviews() {
		[
			blur,
			activityIndicator
		].forEach { subview in
			view.addSubview(subview)
		}
	}
	
	private func setUpConstraints() {
		NSLayoutConstraint.activate(
			[
				activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			]
		)
	}
	
	private func startWaitingMode() {
		activityIndicator.startAnimating()
		blur.isHidden = false
	}
	
	private func stopWaitingMode() {
		activityIndicator.stopAnimating()
		blur.isHidden = true
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
		startWaitingMode()
		viewController.navigationController?.popToRootViewController(animated: true)
		oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
			guard let self, let delegate = self.delegate else {
				preconditionFailure("No more self or self.delegate exist at the moment. Caller - \(#function)")
			}
			switch result {
			case .success(let token):
				self.oAuth2Storage.token = token
				delegate.didAuthenticate(self)
			case .failure(let error):
				stopWaitingMode()
				print(error.localizedDescription)
			}
		}
	}
}
