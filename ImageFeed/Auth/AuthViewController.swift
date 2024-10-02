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
	private let loginButton: UIButton = .init(type: .system)
	private let logoView: UIImageView = .init(image: .unsplashLogo)
	private let oAuth2Service = OAuth2Service.shared
	private let oAuth2Storage = OAuth2TokenStorageService.shared
	
	weak var delegate: AuthViewControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .ypBlack
		logoView.contentMode = .scaleAspectFill
		setUpSubViews()
		setLayoutSubviews()
		configureBackButton()
		configureLogInButton()
	}
	
	//MARK: - Private UI methods
	private func setUpSubViews() {
		[
			logoView,
			loginButton
		].forEach { subView in
			view.addSubview(subView)
		}
	}
	
	private func setLayoutSubviews() {
		logoView.translatesAutoresizingMaskIntoConstraints = false
		loginButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(
			[
				logoView.heightAnchor.constraint(equalToConstant: Sizes.AuthView.LogoView.size),
				logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor),
				logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
				loginButton.heightAnchor.constraint(equalToConstant: Sizes.AuthView.LogInButton.height),
				loginButton.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: Sizes.AuthView.LogInButton.leading
				),
				loginButton.trailingAnchor.constraint(
					equalTo: view.trailingAnchor,
					constant: Sizes.AuthView.LogInButton.trailing
				),
				loginButton.bottomAnchor.constraint(
					equalTo: view.bottomAnchor,
					constant: Sizes.AuthView.LogInButton.bottom
				)
			]
		)
		
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
	
	private func configureLogInButton() {
		loginButton.accessibilityIdentifier = UIElementsIdentifiers.loginButton
		loginButton.setTitle("Войти", for: .normal)
		loginButton.titleLabel?.font = Fonts.bold17
		loginButton.tintColor = .ypBlack
		loginButton.backgroundColor = .ypWhite
		loginButton.layer.cornerRadius = Sizes.AuthView.LogInButton.cornerRadius
		loginButton.addTarget(self, action: #selector(didTapedLogInButton), for: .touchUpInside)
	}
	
	@objc private func didTapedLogInButton() {
		let presenter = WebViewPresenter(authHelper: AuthHelper())
		let webView = WebViewViewController()
		webView.presenter = presenter
		webView.delegate = self
		presenter.view = webView
		self.navigationController?.pushViewController(webView, animated: true)
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
			UIBlockingProgressHUD.dismiss()
			guard let self, let delegate = self.delegate else {
				preconditionFailure("No more self or self.delegate exist at the moment. Caller - \(#function)")
			}
			switch result {
			case .success(let token):
				self.oAuth2Storage.token = token
				delegate.didAuthenticate(self)
			case .failure(let error):
				print("[\(#fileID)]:[\(#function)] -> " + error.localizedDescription)
				AlertPresenter.showAuthError(at: self)
			}
		}
	}
}
