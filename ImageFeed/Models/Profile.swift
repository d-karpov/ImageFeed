//
//  Profile.swift
//  ImageFeed
//
//  Created by Denis on 11.08.2024.
//

import Foundation

struct Profile {
	let username: String
	let name: String
	let bio: String?
	
	var loginName: String {
		"@\(username)"
	}
}
