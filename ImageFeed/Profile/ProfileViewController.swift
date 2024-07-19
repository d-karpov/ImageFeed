//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Denis on 10.07.2024.
//

import UIKit


class ProfileViewController: UIViewController {
	//MARK: - Private variables
	private lazy var profileImage: UIImageView = makeProfileImage()
	private lazy var exitButton: UIButton = makeExitButton()
	private lazy var nameLabel: UILabel = makeFullNameLabel()
	private lazy var nickLabel: UILabel = makeNickLabel()
	private lazy var infoLabel: UILabel = makeInfoLabel()
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpSubViews()
		setLayoutSubviews()
	}
	
	//MARK: - Private methods
	private func setUpSubViews() {
		[
			profileImage,
			exitButton,
			nameLabel,
			nickLabel,
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
				nickLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.leading),
				nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Sizes.spacing),
				nickLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: Sizes.trailing)
			]
		)
	}
	
	private func setUpConstraintsInfoLabel() {
		NSLayoutConstraint.activate(
			[
				infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.leading),
				infoLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: Sizes.spacing),
				infoLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: Sizes.trailing)
			]
		)
	}
	
	private func makeProfileImage() -> UIImageView {
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
	}
	
	private func makeExitButton() -> UIButton {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "Exit"), for: .normal)
		return button
	}
	
	private func makeLabel(with text: String) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = text
		return label
	}
	
	private func makeFullNameLabel() -> UILabel {
		let label = makeLabel(with: "Екатерина Новикова")
		label.font = Fonts.bold23
		label.textColor = .ypWhite
		return label
	}
	
	private func makeNickLabel() -> UILabel {
		let label = makeLabel(with: "@ekaterina_nov")
		label.font = Fonts.regular13
		label.textColor = .ypGray
		return label
	}
	
	private func makeInfoLabel() -> UILabel {
		let label = makeLabel(with: "Hello World!")
		label.font = Fonts.regular13
		label.textColor = .ypWhite
		return label
	}
}
