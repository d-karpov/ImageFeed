//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Denis on 21.08.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		let storyboard = UIStoryboard(name: Constants.Storyboards.main, bundle: .main)
		let imagesListViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboards.imagesList)
		
		let profileViewController = ProfileViewController()
		profileViewController.tabBarItem = UITabBarItem(
			title: .none,
			image: .profileTab,
			selectedImage: .none
		)
		
		self.viewControllers = [imagesListViewController, profileViewController]
		
	}
}
