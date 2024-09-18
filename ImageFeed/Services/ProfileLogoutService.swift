//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Denis on 13.09.2024.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
	static let shared: ProfileLogoutService = .init()
	private let profileService: ProfileService = .shared
	private let profileImageService: ProfileImageService = .shared
	private init() { }
	
	func logOut() {
		KeychainWrapper.standard.remove(forKey: .init(rawValue: Constants.Token.key))
		cleanCookies()
		cleanServices()
	}
	
	private func cleanCookies() {
		HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
		WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
			records.forEach { record in
				WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes,
														for: [record],
														completionHandler: { }
				)
			}
		}
	}
	
	private func cleanServices() {
		profileService.cleanSavedData()
		profileImageService.cleanSavedData()
	}
}
