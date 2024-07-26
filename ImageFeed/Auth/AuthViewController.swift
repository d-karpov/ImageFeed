//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Denis on 25.07.2024.
//

import UIKit

final class AuthViewController: UIViewController {
	
	private let webViewSegueIdentifier = "ShowWebView"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureBackButton()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if 
			segue.identifier == webViewSegueIdentifier,
			let webViewViewController = segue.destination as? WebViewViewController {
			webViewViewController.delegate = self
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}
	
	private func configureBackButton() {
		navigationController?.navigationBar.backIndicatorImage = .navBackButton
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = .navBackButton
		navigationItem.backBarButtonItem = UIBarButtonItem(
			title: "",
			style: .plain,
			target: .none,
			action: #selector(webViewViewControllerDidCancel)
		)
		navigationItem.backBarButtonItem?.tintColor = .ypBlack
	}

}

extension AuthViewController: WebViewViewControllerDelegate {
	
	func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
		
	}
	
	@objc
	func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
		dismiss(animated: true)
	}
	
	
}
