//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Denis on 26.07.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
	let accessToken: String
	let tokenType: String
	let scope: String
	let createdAt: UInt
}
