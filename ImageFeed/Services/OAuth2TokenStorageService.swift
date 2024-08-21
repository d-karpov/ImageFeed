//
//  OAuth2TokenStorageService.swift
//  ImageFeed
//
//  Created by Denis on 26.07.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorageService {
	static let shared = OAuth2TokenStorageService()
	private init() { }
	
	var token: String? {
		get {
			KeychainWrapper.standard.string(forKey: Constants.Token.key)
		} set {
			if let newValue {
				KeychainWrapper.standard.set(newValue, forKey: Constants.Token.key)
			}
		}
	}
}
