//
//  ProfileHelper.swift
//  ImageFeed
//
//  Created by Denis on 22.09.2024.
//

import Foundation

protocol ProfileHelperProtocol: AnyObject {
	func getProfileImageUrl() -> URL?
	func getProfile() -> Profile?
	func logOut()
}

final class ProfileHelper: ProfileHelperProtocol {
	private let profileService: ProfileService = .shared
	private let profileImageService: ProfileImageService = .shared
	private let profileLogoutService: ProfileLogoutService = .shared
	
	func getProfileImageUrl() -> URL? {
		guard
			let profileImageURLString = profileImageService.profileImageURLString,
			let url = URL(string: profileImageURLString)
		else {
			print("[\(#fileID)]:[\(#function)] -> " + ProfileImageServiceError.noImageUrl.localizedDescription)
			return nil
		}
		return url
	}
	
	func logOut() {
		profileLogoutService.logOut()
	}
	
	func getProfile() -> Profile? {
		profileService.profile
	}
	
}
