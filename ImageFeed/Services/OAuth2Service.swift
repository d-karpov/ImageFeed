//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Denis on 26.07.2024.
//

import Foundation

enum DecoderError: Error, LocalizedError {
	case decodingError(Error)
	
	var errorDescription: String? {
		switch self {
		case .decodingError(let error):
			return "Decoding error - \(error)"
		}
	}
}

final class OAuth2Service {
	static let shared = OAuth2Service()
	private init() { }
	
	func fetchOAuthToken(code: String, completion: @escaping(_ result: Result<String, Error>) -> Void) {
		guard let request = getTokenURLRequest(code: code) else { return }
		let dataTask = URLSession.shared.data(for: request) { result in
			switch result {
			case .success(let data):
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				do {
					let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
					completion(.success(responseBody.accessToken))
				} catch {
					completion(.failure(DecoderError.decodingError(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
		
		dataTask.resume()
	}
	
	private func getTokenURLRequest(code: String) -> URLRequest? {
		guard var urlComponents = URLComponents(string: Constants.tokenBaseURLString)else { return nil }
		
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: Constants.accessKey),
			URLQueryItem(name: "client_secret", value: Constants.secretKey),
			URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
			URLQueryItem(name: "code", value: code),
			URLQueryItem(name: "grant_type", value: Constants.grantType)
		]
		
		guard let url = urlComponents.url else { return nil }
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		
		return request
	}
}
