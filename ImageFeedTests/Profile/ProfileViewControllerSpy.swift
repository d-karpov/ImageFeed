//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Denis on 21.09.2024.
//
@testable import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
	var presenter: ProfileViewPresenterProtocol?
	var presetDidCalled: Bool = false
	var setImageDidCalled: Bool = false
	var setNameDidCalled: Bool = false
	var setLoginDidCalled: Bool = false
	var setInfoDidCalled: Bool = false
	
	func setProfileImage(from url: URL) {
		setImageDidCalled.toggle()
	}
	
	func setName(_ name: String) {
		setNameDidCalled.toggle()
	}
	
	func setLogin(_ login: String) {
		setLoginDidCalled.toggle()
	}
	
	func setInfo(_ info: String) {
		setInfoDidCalled.toggle()
	}
	
	func present(_ viewController: UIViewController) {
		presetDidCalled.toggle()
	}
	
}
