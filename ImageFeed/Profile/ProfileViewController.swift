//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Denis on 10.07.2024.
//

import UIKit


final class ProfileViewController: UIViewController {
	//MARK: - Private variables
	private let profileService: ProfileService = .shared
	private let profileImageService: ProfileImageService = .shared
	private var profileImageServiceObserver: NSObjectProtocol?
	
	private lazy var profileImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		if let image = UIImage(named: "Mock User") {
			imageView.image = image
		} else {
			imageView.tintColor = .ypGray
			imageView.image = UIImage(systemName: "person.crop.circle.fill")
		}
		imageView.layer.cornerRadius = Sizes.ProfileImage.cornerRadius
		return imageView
	}()
	
	private lazy var exitButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "Exit"), for: .normal)
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
				profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.leading),
				profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Sizes.top),
				profileImage.heightAnchor.constraint(equalToConstant: Sizes.ProfileImage.size),
				profileImage.widthAnchor.constraint(equalToConstant: Sizes.ProfileImage.size)
			]
		)
	}
	
	private func setUpConstraintsExitButton() {
		NSLayoutConstraint.activate(
			[
				exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Sizes.ExitButton.trailing),
				exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Sizes.ExitButton.top),
				exitButton.heightAnchor.constraint(equalToConstant: Sizes.ExitButton.size),
				exitButton.widthAnchor.constraint(equalToConstant: Sizes.ExitButton.size)
			]
		)
	}
	
	private func setUpConstraintsNameLabel() {
		NSLayoutConstraint.activate(
			[
				nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.leading),
				nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: Sizes.spacing),
				nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: Sizes.trailing)
			]
		)
	}
	
	private func setUpConstraintsNickLabel() {
		NSLayoutConstraint.activate(
			[
				loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.leading),
				loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Sizes.spacing),
				loginLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: Sizes.trailing)
			]
		)
	}
	
	private func setUpConstraintsInfoLabel() {
		NSLayoutConstraint.activate(
			[
				infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.leading),
				infoLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: Sizes.spacing),
				infoLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: Sizes.trailing)
			]
		)
	}
	
	private func makeLabel(with text: String) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = text
		return label
	}
	
	private func updateAvatar() {
		guard
			let profileImageURLString = profileImageService.profileImageURLString,
			let url = URL(string: profileImageURLString)
		else {
			print(ProfileImageServiceError.noImageUrl.localizedDescription)
			return
		}
		
	}
}
