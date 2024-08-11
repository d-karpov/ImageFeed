//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Denis on 11.08.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
	private static var window: UIWindow? {
		UIApplication
			.shared
			.connectedScenes
			.flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
			.last(where: \.isKeyWindow)
	}
	
	static func show() {
		window?.isUserInteractionEnabled = false
		ProgressHUD.show()
	}
	
	static func dismiss() {
		window?.isUserInteractionEnabled = true
		ProgressHUD.dismiss()
	}
}
