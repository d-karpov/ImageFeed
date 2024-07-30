//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Denis on 30.07.2024.
//

import UIKit

final class SplashViewController: UIViewController {
	
	private let storage = OAuth2TokenStorageService.shared
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if storage.token != nil {
			showTabBarViewController()
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
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
	func didAuthenticate(_ viewController: AuthViewController) {
		viewController.dismiss(animated: true)
		showTabBarViewController()
	}
}
