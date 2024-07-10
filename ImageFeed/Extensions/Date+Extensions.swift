//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Denis on 09.07.2024.
//

import Foundation

extension Date {
	var dateNoTimeString: String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ru_RU")
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter.string(from: self)
	}
}
