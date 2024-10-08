//
//  Sizes.swift
//  ImageFeed
//
//  Created by Denis on 19.07.2024.
//

import Foundation

enum Sizes {

	enum TableView {
		enum ContentInsets {
			static let top: CGFloat = 12
			static let bottom: CGFloat = 12
			static let left: CGFloat = 0
			static let right: CGFloat = 0
		}
		
		enum ImageInsets {
			static let top: CGFloat = 4
			static let bottom: CGFloat = 4
			static let left: CGFloat = 16
			static let right: CGFloat = 16
		}
		
	}
	
	enum SingleImageView {
		enum BackButton {
			static let size: CGFloat = 24
			static let top: CGFloat = 55
			static let leading: CGFloat = 9
		}
		
		enum ShareButton {
			static let size: CGFloat = 50
			static let cornerRadius: CGFloat = size/2
			static let bottom: CGFloat = -51
		}
	}
	
	enum ImageCell {
		enum LikeButton {
			static let size: CGFloat = 44
		}
		
		enum GradientView {
			static let height: CGFloat = 30
		}
		
		enum DateLabel {
			static let top: CGFloat = 4
			static let bottom: CGFloat = -8
			static let leading: CGFloat = 8
			static let trailing: CGFloat = -8
		}
		
		enum Image {
			static let top: CGFloat = 4
			static let bottom: CGFloat = -4
			static let leading: CGFloat = 16
			static let trailing: CGFloat = -16
			static let cornerRadius: CGFloat = 16
		}
	}
	
	enum ProfileView {
		enum ProfileImage {
			static let size: CGFloat = 70
			static let cornerRadius: CGFloat = 35
			static let top: CGFloat = 32
			static let leading: CGFloat = 16
		}
		
		enum ExitButton {
			static let size: CGFloat = 24
			static let trailing: CGFloat = -24
			static let top: CGFloat = 55
		}
		
		enum Label {
			static let leading: CGFloat = 16
			static let trailing: CGFloat = -16
			static let spacing: CGFloat = 8
		}
	}
	
	enum AuthView {
		enum LogoView {
			static let size: CGFloat = 60
		}
		enum LogInButton {
			static let height: CGFloat = 48
			static let bottom: CGFloat = -90
			static let leading: CGFloat = 16
			static let trailing: CGFloat = -16
			static let cornerRadius: CGFloat = 16
		}
	}
}

