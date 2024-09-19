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
	
	private let profileService: ProfileService = .shared
	private let profileImageService: ProfileImageService = .shared
	private let profileLogoutService: ProfileLogoutService = .shared
	private var profileImageServiceObserver: NSObjectProtocol?
	
	init() {
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
		profileLogoutService.logOut()
		let splashView = SplashViewController()
		splashView.modalPresentationStyle = .fullScreen
		view?.present(splashView)
	}
	
	private func updateProfileImage() {
		guard
			let profileImageURLString = profileImageService.profileImageURLString,
			let url = URL(string: profileImageURLString)
		else {
			print("[\(#fileID)]:[\(#function)] -> " + ProfileImageServiceError.noImageUrl.localizedDescription)
			return
		}
		view?.setProfileImage(from: url)
	}
	
	private func updateProfileDetails() {
		guard let profile = profileService.profile else { return }
		view?.setName(profile.name)
		view?.setLogin(profile.loginName)
		if let info = profile.bio {
			view?.setInfo(info)
		}
	}
	
}
