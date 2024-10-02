//
//  ProfileHelperStub.swift
//  ImageFeedTests
//
//  Created by Denis on 22.09.2024.
//
@testable import ImageFeed
import Foundation

final class ProfileHelperStub: ProfileHelperProtocol {
	func getProfileImageUrl() -> URL? {
		let testBundle = Bundle(for: ProfileViewTests.self)
		let url = testBundle.url(forResource: "MockUser", withExtension: "png")
		return url
	}
	
	func getProfile() -> ImageFeed.Profile? {
		Profile(
			username: "@testUserName",
			name: "Test User Name",
			bio: "Test user bio"
		)
	}
	
	func logOut() { }
}
