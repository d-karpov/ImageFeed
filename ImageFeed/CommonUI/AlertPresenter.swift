//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Denis on 19.08.2024.
//

import UIKit

struct AlertPresenter {
	static func show(with model: Alert, at view: UIViewController) {
		let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
		
		let alertAction = UIAlertAction(title: model.buttonText, style: .default) { _ in
			model.action()
		}
		
		alert.addAction(alertAction)
		
		view.present(alert, animated: true)
	}
	
	static func showAuthError(at view: UIViewController) {
		show(
			with: .init(
				title: Constants.AlertTexts.title,
				message: Constants.AlertTexts.authMessage,
				buttonText: Constants.AlertTexts.buttonText,
				action: { }
			),
			at: view
		)
	}
}
