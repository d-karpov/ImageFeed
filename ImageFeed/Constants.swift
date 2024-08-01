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
		static let accessScope: String = "public"
	}
	
	enum Token {
		static let grantType: String = "authorization_code"
		static let storageKey: String = "token"
		static let baseURLString: String =  "https://unsplash.com/oauth/token"
	}
	
	enum URLs {
		static let authorizeURLString: String = "https://unsplash.com/oauth/authorize"
		static let defaultBaseURL: URL? = .init(string: "https://api.unsplash.com/")
	}
	
	enum Segues {
		static let authScene: String = "ShowAuthScene"
		static let webView: String = "ShowWebView"
		static let singleImage: String = "ShowSingleImage"
	}
	
	enum Storyboards {
		static let tabBar: String = "TabBarViewController"
		static let main: String = "Main"
	}
}
