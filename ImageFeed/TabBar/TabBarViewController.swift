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
		let imagesListViewController = assemblyImagesListViewController()
		let profileViewController = assemblyProfileViewController()
		viewControllers = [imagesListViewController, profileViewController]
	}
	
	private func assemblyProfileViewController() -> ProfileViewController {
		let profileViewController = ProfileViewController()
		let presenter = ProfileViewPresenter(profileHelper: ProfileHelper())
		presenter.view = profileViewController
		profileViewController.presenter = presenter
		profileViewController.tabBarItem = UITabBarItem(
			title: .none,
			image: .profileTab,
			selectedImage: .none
		)
		return profileViewController
	}
	
	private func assemblyImagesListViewController() -> ImagesListViewController {
		let imagesListViewController = ImagesListViewController()
		let presenter = ImagesListViewPresenter()
		presenter.view = imagesListViewController
		imagesListViewController.presenter = presenter
		imagesListViewController.tabBarItem = UITabBarItem(
			title: .none,
			image: .mainTab,
			selectedImage: .none
		)
		return imagesListViewController
	}
}
