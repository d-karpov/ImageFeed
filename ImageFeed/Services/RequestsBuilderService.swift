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
	case auth
	case photos(Int)
	case like(String, Bool)
	
	var URLString: String {
		switch self {
		case .auth:
			return Constants.URLs.authorizeURLString
		case .token(_):
			return Constants.Token.baseURLString
		case .userBaseData:
			return Constants.URLs.baseURLString + Constants.APIPaths.userData
		case .userImage(let userName):
			return Constants.URLs.baseURLString + Constants.APIPaths.userPublicData + userName
		case .photos(_):
			return Constants.URLs.baseURLString + Constants.APIPaths.photos
		case .like(let id, _):
			return Constants.URLs.baseURLString + Constants.APIPaths.photos + id + Constants.APIPaths.like
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
		case .auth:
			return getAuthRequest(urlString: path.URLString)
		case .photos(let page):
			return getPhotosAtPageRequest(at:page, urlString: path.URLString)
		case .like(let id, let isLiked):
			return getPhotoLikeRequest(for: id, currentState: isLiked, urlString: path.URLString)
		}
	}
	
	//MARK: Private Methods
	private func getAuthRequest(urlString: String) -> URLRequest? {
		guard var urlComponents = URLComponents(string: urlString) else { return nil }
		
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: Constants.API.accessKey),
			URLQueryItem(name: "redirect_uri", value: Constants.API.redirectURI),
			URLQueryItem(name: "response_type", value: "code"),
			URLQueryItem(name: "scope", value: Constants.API.accessScope),
		]
		
		guard let url = urlComponents.url else { return nil }
		return URLRequest(url: url)
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
	
	private func getPhotosAtPageRequest(at page: Int, urlString: String) -> URLRequest? {
		guard 
			var urlComponents = URLComponents(string: urlString),
			let token = tokenStorage.token
		else {
			return nil
		}
		
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: Constants.API.accessKey),
			URLQueryItem(name: "page", value: page.description),
			URLQueryItem(name: "per_page", value: 10.description)
		]
		
		guard let url = urlComponents.url else { return nil }
		var request = URLRequest(url: url)
		request.setValue("Bearer \(token)", forHTTPHeaderField: Constants.Token.requestHeader)
		return request
	}
	
	private func getPhotoLikeRequest(for: String, currentState: Bool, urlString: String) -> URLRequest? {
		guard 
			let url = URL(string: urlString),
			let token = tokenStorage.token
		else {
			return nil
		}
		var request = URLRequest(url: url)
		request.setValue("Bearer \(token)", forHTTPHeaderField: Constants.Token.requestHeader)
		request.httpMethod = currentState ? "DELETE" : "POST"
		return request
	}
}
