//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Denis on 09.07.2024.
//

import Foundation

extension Date {
	var dateNoTimeString: String {
		DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .none)
	}
}
