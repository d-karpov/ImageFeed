//
//  Constants.swift
//  ImageFeed
//
//  Created by Denis on 25.07.2024.
//

import Foundation

enum Constants {
	enum API {
		static let accessKey: String = "ejqijlQzts9kTelhZ9TMCa1zIXl4SHlqllhflccFeUk"
		static let secretKey: String = "jJLxC3Rc4Qg_mt-fTucq66LpBHwH5uSrUcl5_de39t0"
		static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
		static let accessScope: String = "public+read_user+write_likes"
	}
	
	enum Token {
		static let key: String = "Auth token"
		static let grantType: String = "authorization_code"
		static let storageKey: String = "token"
		static let baseURLString: String =  "https://unsplash.com/oauth/token"
		static let requestHeader: String = "Authorization"
	}
	
	enum URLs {
		static let authorizeURLString: String = "https://unsplash.com/oauth/authorize"
		static let baseURLString: String = "https://api.unsplash.com/"
	}
	
	enum APIPaths {
		static let userData: String = "me"
		static let userPublicData: String = "users/"
		static let photos: String = "photos/"
		static let like: String = "/like"
	}
	
	enum ImageSizes {
		static let profileImage: String = "small"
	}
	
	enum AlertTexts {
		static let errorTitle: String = "Что-то пошло не так("
		static let authMessage: String = "Не удалось войти в систему"
		static let okButton: String = "Ок"
		static let downloadMessage: String = "Попробовать ещё раз?"
		static let againButton: String = "Повторить"
		static let noNeedButton: String = "Не надо"
		static let yesButton: String = "Да"
		static let noButton: String = "Нет"
		static let logoutMessage: String = "Уверены что хотите выйти"
		static let logoutTitle: String = "Пока, пока!"
	}
}
