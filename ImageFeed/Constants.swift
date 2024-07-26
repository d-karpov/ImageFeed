//
//  Constants.swift
//  ImageFeed
//
//  Created by Denis on 25.07.2024.
//

import Foundation

enum Constants {
	static let accessKey: String = "zD94Nskkw-ORsKnrZEhfJpxDNDsQfOZgvB24DjNFAMw"
	static let secretKey: String = "xL9uaqAgQAGS9QliU8KfuMAqPuO4LR-PYZPAo6p_R4w"
	static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
	static let accessScope: String = "public"
	static let grantType: String = "authorization_code"
	static let tokenStorageKey: String = "token"
	static let tokenBaseURLString: String =  "https://unsplash.com/oauth/token"
	static let unsplashAuthorizeURLString: String = "https://unsplash.com/oauth/authorize"
	static let defaultBaseURL: URL? = .init(string: "https://api.unsplash.com/")
}
