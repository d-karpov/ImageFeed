//
//  RequestsBuilderService.swift
//  ImageFeed
//
//  Created by Denis on 18.08.2024.
//

import Foundation

enum RequestPath {
	case token(String)
	case userBaseData
	case userImage(String)
	
	var URLString: String {
		switch self {
		case .token(_):
			return Constants.Token.baseURLString
		case .userBaseData:
			return Constants.URLs.baseURLString + Constants.APIPaths.userData
		case .userImage(let userName):
			return Constants.URLs.baseURLString + Constants.APIPaths.userPublicData + userName
		}
	}
}

final class RequestsBuilderService {
	static let shared: RequestsBuilderService = .init()
	private let tokenStorage = OAuth2TokenStorageService.shared
	
	private init() {}
	
	func madeRequest(for path: RequestPath) -> URLRequest? {
		switch path {
		case .token(let code):
			return getTokenURLRequest(code: code, urlString: path.URLString)
		case .userBaseData, .userImage(_):
			return getUserInformationRequest(urlString: path.URLString)
		}
	}
	
	private func getTokenURLRequest(code: String, urlString: String) -> URLRequest? {
		guard var urlComponents = URLComponents(string: urlString) else { return nil }
		
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: Constants.API.accessKey),
			URLQueryItem(name: "client_secret", value: Constants.API.secretKey),
			URLQueryItem(name: "redirect_uri", value: Constants.API.redirectURI),
			URLQueryItem(name: "code", value: code),
			URLQueryItem(name: "grant_type", value: Constants.Token.grantType)
		]
		
		guard let url = urlComponents.url else { return nil }
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		
		return request
	}
	
	private func getUserInformationRequest(urlString: String) -> URLRequest? {
		guard
			let url = URL(string: urlString),
			let token = tokenStorage.token
		else {
			return nil
		}
		var request = URLRequest(url: url)
		request.setValue("Bearer \(token)", forHTTPHeaderField: Constants.Token.requestHeader)
		return request
	}
}
