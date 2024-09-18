//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Denis on 30.07.2024.
//

import UIKit

final class SplashViewController: UIViewController {
	
	private let storage: OAuth2TokenStorageService = .shared
	private let profileService: ProfileService = .shared
	private let profileImageService: ProfileImageService = .shared
	
	private var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.backgroundColor = .ypBlack
		imageView.image = .splashScreen
		imageView.contentMode = .center
		return imageView
	}()
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if storage.token != nil {
			fetchProfile()
		} else {
			presentAuthViewController()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpSubViews()
		setLayoutSubviews()
	}
	
	private func setUpSubViews() {
		[imageView].forEach { subView in
			view.addSubview(subView)
		}
	}
	
	private func setLayoutSubviews() {
		NSLayoutConstraint.activate(
			[
				imageView.topAnchor.constraint(equalTo: view.topAnchor),
				imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			]
		)
	}
	
	private func presentAuthViewController() {
		let authViewController = AuthViewController()
		authViewController.delegate = self
		let navigationViewController = UINavigationController(rootViewController: authViewController)
		navigationViewController.modalPresentationStyle = .fullScreen
		present(navigationViewController, animated: true)
	}
	
	private func showTabBarViewController() {
		let tabBarViewController = TabBarViewController()
		tabBarViewController.modalPresentationStyle = .fullScreen
		present(tabBarViewController, animated: true)
	}
	
	private func fetchProfile() {
		UIBlockingProgressHUD.show()
		profileService.fetchProfile() { [weak self] result in
			guard let self else {
				preconditionFailure("No SplashViewController")
			}
			UIBlockingProgressHUD.dismiss()
			switch result {
			case .success(let profile):
				self.fetchProfileImage(for: profile.username)
				self.showTabBarViewController()
			case .failure(let error):
				print("[\(#fileID)]:[\(#function)] -> " + error.localizedDescription)
				AlertPresenter.showAuthError(at: self)
			}
		}
	}
	
	private func fetchProfileImage(for userName: String) {
		profileImageService.fetchProfileImage(userName: userName) { result in
			switch result {
			case .success(_): return
			case .failure(let error):
				print("[\(#fileID)]:[\(#function)] -> " + error.localizedDescription)
			}
		}
	}
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
	func didAuthenticate(_ viewController: AuthViewController) {
		viewController.dismiss(animated: true)
	}
}
