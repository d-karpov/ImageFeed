//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Denis on 26.07.2024.
//

import UIKit

//MARK: - NetworkErrors
enum NetworkError: Error, LocalizedError {
	case httpStatusCode(Int)
	case urlRequestError(Error)
	case urlSessionError
	
	var errorDescription: String? {
		switch self {
		case .httpStatusCode(let code):
			return "[\(#fileID)]:[\(#function)] -> HTTP Status Code Error - code \(code)"
		case .urlRequestError(let error):
			return "[\(#fileID)]:[\(#function)] -> Request Error - \(error.localizedDescription)"
		case .urlSessionError:
			return "[\(#fileID)]:[\(#function)] -> URL Session Error"
		}
	}
}
//MARK: - DecoderErrors
enum DecoderError: Error, LocalizedError {
	case decodingError(Error)
	
	var errorDescription: String? {
		switch self {
		case .decodingError(let error):
			guard let error = error as? DecodingError else {
				return "[\(#fileID)]:[\(#function)] -> Error while try decode - \(error)"
			}
			switch error {
			case .typeMismatch(let type, let context):
				return "[\(#fileID)]:[\(#function)] -> Type mismatch - used \(type) for codingPath:\n\(context.codingPath)"
			case .valueNotFound(let value, let context):
				return "[\(#fileID)]:[\(#function)] -> Value - \(value) wasn't found!\nCodingPath: \(context.codingPath)"
			case .keyNotFound(let key, let context):
				return "[\(#fileID)]:[\(#function)] -> Key - \(key) wasn't found!\nCodingPath: \(context.codingPath)"
			case .dataCorrupted(let context):
				return "[\(#fileID)]:[\(#function)] -> Data corrupted - \(context)"
			@unknown default:
				return "[\(#fileID)]:[\(#function)] -> Unknown Decoding error - \(error)"
			}
		}
	}
}

//MARK: - Network methods implementation
extension URLSession {
	static let decoder: JSONDecoder = .init()
	
	func objectTask<T: Decodable>(
		for request: URLRequest,
		completion: @escaping(Result<T,Error>) -> Void
	) -> URLSessionTask {
		let decoder = URLSession.decoder
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let task = data(for: request) { result in
			switch result {
			case .success(let data):
				do {
					let responseBody = try decoder.decode(T.self, from: data)
					completion(.success(responseBody))
				} catch {
					print("\(DecoderError.decodingError(error).localizedDescription)")
					completion(.failure(DecoderError.decodingError(error)))
				}
			case .failure(let error):
				print("\(error.localizedDescription)")
				completion(.failure(error))
			}
		}
		return task
	}
	
	//MARK: Private methods
	private func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
		let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
			DispatchQueue.main.async {
				completion(result)
			}
		}
		
		let task = dataTask(with: request) { data, response, error in
			if
				let data = data,
				let response = response,
				let statusCode = (response as? HTTPURLResponse)?.statusCode
			{
				if 200..<300 ~= statusCode {
					fulfillCompletionOnTheMainThread(.success(data))
				} else {
					print("\(NetworkError.httpStatusCode(statusCode).localizedDescription)")
					fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
				}
			} else if let error = error {
				print("\(NetworkError.urlRequestError(error).localizedDescription)")
				fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
			} else {
				print("\(NetworkError.urlSessionError.localizedDescription)")
				fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
			}
		}
		
		return task
	}
}
