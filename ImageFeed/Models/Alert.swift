//
//  Alert.swift
//  ImageFeed
//
//  Created by Denis on 19.08.2024.
//

import Foundation

struct Alert {
	let title: String
	let message: String
	let buttonText: String
	let action: () -> Void
}
