//
//  ProfileResponseBody.swift
//  ImageFeed
//
//  Created by Denis on 11.08.2024.
//

import Foundation


struct ProfileResponseBody: Codable {
	let username: String
	let firstName: String
	let lastName: String?
	let bio: String?
}
