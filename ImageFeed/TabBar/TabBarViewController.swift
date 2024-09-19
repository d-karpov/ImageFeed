//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Denis on 21.08.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tabBar.barTintColor = .ypBlack
		tabBar.tintColor = .ypWhite
		let imagesListViewController = ImagesListViewController()
		imagesListViewController.tabBarItem = UITabBarItem(
			title: .none,
			image: .mainTab,
			selectedImage: .none
		)
		let profileViewController = assemblyProfileViewController()
		viewControllers = [imagesListViewController, profileViewController]
	}
	
	private func assemblyProfileViewController() -> ProfileViewController {
		let profileViewController = ProfileViewController()
		let presenter = ProfileViewPresenter()
		presenter.view = profileViewController
		profileViewController.presenter = presenter
		profileViewController.tabBarItem = UITabBarItem(
			title: .none,
			image: .profileTab,
			selectedImage: .none
		)
		return profileViewController
	}
}
