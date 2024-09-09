//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Denis on 10.07.2024.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper


final class ProfileViewController: UIViewController {
	//MARK: - Private variables
	private let profileService: ProfileService = .shared
	private let profileImageService: ProfileImageService = .shared
	private var profileImageServiceObserver: NSObjectProtocol?
	
	private lazy var profileImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.tintColor = .ypGray
		return imageView
	}()
	
	private lazy var exitButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "Exit"), for: .normal)
		button.addTarget(self, action: #selector(logout), for: .touchUpInside)
		return button
	}()
	
	private lazy var nameLabel: UILabel = {
		let label = makeLabel(with: "Екатерина Новикова")
		label.font = Fonts.bold23
		label.textColor = .ypWhite
		return label
	}()
	
	private lazy var loginLabel: UILabel = {
		let label = makeLabel(with: "@ekaterina_nov")
		label.font = Fonts.regular13
		label.textColor = .ypGray
		return label
	}()
	
	private lazy var infoLabel: UILabel = {
		let label = makeLabel(with: "")
		label.font = Fonts.regular13
		label.textColor = .ypWhite
		return label
	}()
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .ypBlack
		setUpSubViews()
		setLayoutSubviews()
		updateProfileDetails(profile: profileService.profile)
		
		profileImageServiceObserver = NotificationCenter.default.addObserver(
			forName: ProfileImageService.didChangeNotification,
			object: nil,
			queue: .main,
			using: { [weak self] _ in
				guard let self else { return }
				self.updateAvatar()
			}
		)
		updateAvatar()
	}
	
	//MARK: - Private methods
	private func updateProfileDetails(profile: Profile?) {
		if let profile {
			self.nameLabel.text = profile.name
			self.loginLabel.text = profile.loginName
			self.infoLabel.text = profile.bio
		}
	}
	
	private func updateAvatar() {
		guard
			let profileImageURLString = profileImageService.profileImageURLString,
			let url = URL(string: profileImageURLString)
		else {
			print("[\(#fileID)]:[\(#function)] -> " + ProfileImageServiceError.noImageUrl.localizedDescription)
			return
		}
		
		let processor = RoundCornerImageProcessor(
			cornerRadius: Sizes.ProfileView.ProfileImage.cornerRadius,
			backgroundColor: .ypBlack
		)
		
		profileImage.kf.setImage(
			with: url,
			placeholder: UIImage(systemName: "person.crop.circle.fill"),
			options: [.processor(processor)]
		)
	}
	@objc
	private func logout() {
		KeychainWrapper.standard.removeAllKeys()
	}
	
	private func setUpSubViews() {
		[
			profileImage,
			exitButton,
			nameLabel,
			loginLabel,
			infoLabel
		].forEach { subView in
			view.addSubview(subView)
		}
	}
	
	private func setLayoutSubviews() {
		setUpConstraintsProfileImage()
		setUpConstraintsExitButton()
		setUpConstraintsNameLabel()
		setUpConstraintsNickLabel()
		setUpConstraintsInfoLabel()
	}
	
	//MARK: Constraints Methods
	private func setUpConstraintsProfileImage() {
		NSLayoutConstraint.activate(
			[
				profileImage.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: Sizes.ProfileView.ProfileImage.leading
				),
				profileImage.topAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.topAnchor,
					constant: Sizes.ProfileView.ProfileImage.top
				),
				profileImage.heightAnchor.constraint(equalToConstant: Sizes.ProfileView.ProfileImage.size),
				profileImage.widthAnchor.constraint(equalToConstant: Sizes.ProfileView.ProfileImage.size)
			]
		)
	}
	
	private func setUpConstraintsExitButton() {
		NSLayoutConstraint.activate(
			[
				exitButton.trailingAnchor.constraint(
					equalTo: view.trailingAnchor,
					constant: Sizes.ProfileView.ExitButton.trailing
				),
				exitButton.topAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.topAnchor,
					constant: Sizes.ProfileView.ExitButton.top
				),
				exitButton.heightAnchor.constraint(equalToConstant: Sizes.ProfileView.ExitButton.size),
				exitButton.widthAnchor.constraint(equalToConstant: Sizes.ProfileView.ExitButton.size)
			]
		)
	}
	
	private func setUpConstraintsNameLabel() {
		NSLayoutConstraint.activate(
			[
				nameLabel.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: Sizes.ProfileView.Label.leading
				),
				nameLabel.topAnchor.constraint(
					equalTo: profileImage.bottomAnchor,
					constant: Sizes.ProfileView.Label.spacing
				),
				nameLabel.trailingAnchor.constraint(
					greaterThanOrEqualTo: view.trailingAnchor,
					constant: Sizes.ProfileView.Label.trailing
				)
			]
		)
	}
	
	private func setUpConstraintsNickLabel() {
		NSLayoutConstraint.activate(
			[
				loginLabel.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: Sizes.ProfileView.Label.leading
				),
				loginLabel.topAnchor.constraint(
					equalTo: nameLabel.bottomAnchor,
					constant: Sizes.ProfileView.Label.spacing
				),
				loginLabel.trailingAnchor.constraint(
					greaterThanOrEqualTo: view.trailingAnchor,
					constant: Sizes.ProfileView.Label.trailing
				)
			]
		)
	}
	
	private func setUpConstraintsInfoLabel() {
		NSLayoutConstraint.activate(
			[
				infoLabel.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: Sizes.ProfileView.Label.leading
				),
				infoLabel.topAnchor.constraint(
					equalTo: loginLabel.bottomAnchor,
					constant: Sizes.ProfileView.Label.spacing
				),
				infoLabel.trailingAnchor.constraint(
					greaterThanOrEqualTo: view.trailingAnchor,
					constant: Sizes.ProfileView.Label.trailing
				)
			]
		)
	}
	
	private func makeLabel(with text: String) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = text
		return label
	}
}
