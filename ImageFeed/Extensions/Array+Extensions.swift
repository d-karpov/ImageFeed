//
//  Array+Extensions.swift
//  ImageFeed
//
//  Created by Denis on 09.07.2024.
//

import Foundation

extension Array {
	subscript(safe index: Index) -> Element? {
		indices ~= index ? self[index] : nil
	}
}
