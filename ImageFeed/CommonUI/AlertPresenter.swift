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
				buttonText: Constants.AlertTexts.buttonOk,
				action: { }
			),
			at: view
		)
	}
	
	static func showDownloadError(at view: UIViewController, with action: @escaping () -> Void) {
		let alert = UIAlertController(
			title: Constants.AlertTexts.title,
			message: Constants.AlertTexts.downloadMessage,
			preferredStyle: .alert
		)
		let noAction = UIAlertAction(title: Constants.AlertTexts.noButton, style: .default)
		let againAction = UIAlertAction(title: Constants.AlertTexts.againButton, style: .default) { _ in
			action()
		}
		alert.addAction(noAction)
		alert.addAction(againAction)
		alert.preferredAction = againAction
		view.present(alert, animated: true)
	}
}
