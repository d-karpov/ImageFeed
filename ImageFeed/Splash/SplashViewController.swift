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
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if storage.token != nil {
			fetchProfile()
		} else {
			performSegue(withIdentifier: Constants.Segues.authScene, sender: nil)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if
			segue.identifier == Constants.Segues.authScene,
			let destination = segue.destination as? UINavigationController,
			let authViewController = destination.topViewController as? AuthViewController
		{
			authViewController.delegate = self
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}
	
	private func showTabBarViewController() {
		guard
			let window = UIApplication
				.shared
				.connectedScenes
				.flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
				.last(where: \.isKeyWindow)
		else {
			assertionFailure("Invalid window configuration")
			return
		}
		window.rootViewController = UIStoryboard(name: Constants.Storyboards.main, bundle: .main)
			.instantiateViewController(withIdentifier: Constants.Storyboards.tabBar)
	}
	
	private func fetchProfile() {
		UIBlockingProgressHUD.show()
		profileService.fetchProfile() { [weak self] result in
			UIBlockingProgressHUD.dismiss()
			guard let self else {
				preconditionFailure("No SplashViewController")
			}
			switch result {
			case .success(let profile):
				self.fetchProfileImage(for: profile.username)
				self.showTabBarViewController()
			case .failure(let error):
				print("[\(#fileID)]:[\(#function)] -> " + error.localizedDescription)
			}
		}
	}
	
	private func fetchProfileImage(for userName: String) {
		profileImageService.fetchProfileImage(userName: userName) { result in
			switch result {
			case .success(_): return
			case .failure(let error):
				AlertPresenter.show(
					with: .init(
						title: Constants.AlertTexts.title,
						message: error.localizedDescription,
						buttonText: Constants.AlertTexts.buttonText,
						action: { }
					),
					at: self
				)
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
