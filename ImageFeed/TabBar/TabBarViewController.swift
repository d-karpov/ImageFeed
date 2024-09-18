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
		
		let profileViewController = ProfileViewController()
		profileViewController.tabBarItem = UITabBarItem(
			title: .none,
			image: .profileTab,
			selectedImage: .none
		)
		
		viewControllers = [imagesListViewController, profileViewController]
	}
}
