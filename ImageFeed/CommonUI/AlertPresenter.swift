//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Denis on 19.08.2024.
//

import UIKit

struct AlertPresenter {
	static func showAuthError(at view: UIViewController) {
		let alert = UIAlertController(
			title: Constants.AlertTexts.errorTitle,
			message: Constants.AlertTexts.authMessage,
			preferredStyle: .alert
		)
		let alertAction = UIAlertAction(title: Constants.AlertTexts.okButton, style: .default)
		alert.addAction(alertAction)
		view.present(alert, animated: true)
	}
	
	static func showDownloadError(at view: UIViewController, with action: @escaping () -> Void) {
		let alert = UIAlertController(
			title: Constants.AlertTexts.errorTitle,
			message: Constants.AlertTexts.downloadMessage,
			preferredStyle: .alert
		)
		let noAction = UIAlertAction(title: Constants.AlertTexts.noNeedButton, style: .default)
		let againAction = UIAlertAction(title: Constants.AlertTexts.againButton, style: .default) { _ in
			action()
		}
		alert.addAction(noAction)
		alert.addAction(againAction)
		alert.preferredAction = againAction
		view.present(alert, animated: true)
	}
	
	static func logout(at view: UIViewController, with action: @escaping () -> Void) {
		let alert = UIAlertController(
			title: Constants.AlertTexts.logoutTitle,
			message: Constants.AlertTexts.logoutMessage,
			preferredStyle: .alert
		)
		let noAction = UIAlertAction(title: Constants.AlertTexts.noButton, style: .default)
		let yesAction = UIAlertAction(title: Constants.AlertTexts.yesButton, style: .default) { _ in
			action()
		}
		alert.addAction(yesAction)
		alert.addAction(noAction)
		alert.preferredAction = noAction
		view.present(alert, animated: true)
	}
}
