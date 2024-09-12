//
//  PhotosResponseBody.swift
//  ImageFeed
//
//  Created by Denis on 11.09.2024.
//

import Foundation

struct PhotosResponseBody: Decodable {
	let id: String
	let createdAt: String
	let width: Int
	let height: Int
	let description: String?
	let urls: URLsResult
	let likedByUser: Bool
}

struct URLsResult: Decodable {
	let full: String
	let thumb: String
}
