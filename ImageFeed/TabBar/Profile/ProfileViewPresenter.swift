//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Denis on 19.09.2024.
//

import UIKit

protocol ProfileViewPresenterProtocol: AnyObject {
	var view: ProfileViewControllerProtocol? { get set }
	func viewDidLoad()
	func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
	weak var view: ProfileViewControllerProtocol?
	private var profileImageServiceObserver: NSObjectProtocol?
	private var profileHelper: ProfileHelperProtocol?
	
	init(profileHelper: ProfileHelperProtocol) {
		self.profileHelper = profileHelper
		profileImageServiceObserver = NotificationCenter.default.addObserver(
			forName: ProfileImageService.didChangeNotification,
			object: nil,
			queue: .main,
			using: { [weak self] _ in
				guard let self else { return }
				updateProfileImage()
			}
		)
	}
	
	func viewDidLoad() {
		updateProfileImage()
		updateProfileDetails()
	}
	
	func logout() {
		profileHelper?.logOut()
		let splashView = SplashViewController()
		splashView.modalPresentationStyle = .fullScreen
		view?.present(splashView)
	}
	
	private func updateProfileImage() {
		if let url = profileHelper?.getProfileImageUrl() {
			view?.setProfileImage(from: url)
		}
	}
	
	private func updateProfileDetails() {
		guard let profile = profileHelper?.getProfile() else { return }
		view?.setName(profile.name)
		view?.setLogin(profile.loginName)
		if let info = profile.bio {
			view?.setInfo(info)
		}
	}
	
}
