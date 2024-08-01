//
//  OAuth2TokenStorageService.swift
//  ImageFeed
//
//  Created by Denis on 26.07.2024.
//

import Foundation

final class OAuth2TokenStorageService {
	static let shared = OAuth2TokenStorageService()
	private init() { }
	
	var token: String? {
		get {
			UserDefaults.standard.string(forKey: Constants.Token.storageKey)
		} set {
			UserDefaults.standard.setValue(newValue, forKey: Constants.Token.storageKey)
		}
	}
}
