//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Denis on 19.09.2024.
//

import Foundation

struct AuthConfiguration {
	let accessKey: String
	let secretKey: String
	let redirectURI: String
	let accessScope: String
	let defaultBaseURL: String
	let authURLString: String
	
	static var standard: AuthConfiguration {
		AuthConfiguration(
			accessKey: Constants.API.accessKey,
			secretKey: Constants.API.secretKey,
			redirectURI: Constants.API.redirectURI,
			accessScope: Constants.API.accessScope,
			defaultBaseURL: Constants.URLs.baseURLString,
			authURLString: Constants.URLs.authorizeURLString
		)
	}
}
