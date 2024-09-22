//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Denis on 21.09.2024.
//
@testable import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
	weak var view: ProfileViewControllerProtocol?
	var didLoadCalled: Bool = false
	
	func viewDidLoad() {
		didLoadCalled.toggle()
	}
	
	func logout() { }
}
