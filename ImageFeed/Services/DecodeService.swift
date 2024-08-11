//
//  DecodeService.swift
//  ImageFeed
//
//  Created by Denis on 11.08.2024.
//

import Foundation

enum DecoderError: Error, LocalizedError {
	case decodingError(Error)
	
	var errorDescription: String? {
		switch self {
		case .decodingError(let error):
			guard let error = error as? DecodingError else {
				return "Error while try decode - \(error)"
			}
			switch error {
			case .typeMismatch(let type, let context):
				return "Type mismatch - used \(type) for codingPath:\n\(context.codingPath)"
			case .valueNotFound(let value, let context):
				return "Value - \(value) wasn't found!\nCodingPath: \(context.codingPath)"
			case .keyNotFound(let key, let context):
				return "Key - \(key) wasn't found!\nCodingPath: \(context.codingPath)"
			case .dataCorrupted(let context):
				return "Data corrupted - \(context)"
			@unknown default:
				return "Unknown Decoding error - \(error)"
			}
		}
	}
}

final class DecodeService {
	static let shared: DecodeService = .init()
	
	private let decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}()
	
	private init() { }
	
	func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
		try decoder.decode(type, from: data)
	}
}
