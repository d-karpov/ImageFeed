//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Denis on 06.07.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
	
	static let reuseIdentifier: String = "ImagesListCell"
	
	private let gradient = CAGradientLayer()
	
	private var likeButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private var dateLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = Fonts.regular13
		label.textColor = .ypWhite
		return label
	}()
	
	private var cellImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.masksToBounds = true
		imageView.layer.cornerRadius = Sizes.ImageCell.Image.cornerRadius
		return imageView
	}()
	
	private var gradientView: UIView = {
		let gradientView = UIView()
		gradientView.translatesAutoresizingMaskIntoConstraints = false
		return gradientView
	}()
	
	private var placeholder: UIImageView {
		let placeholder = UIImageView()
		placeholder.backgroundColor = .ypWhiteAlpha50
		placeholder.image = .imageStub
		placeholder.contentMode = .center
		UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse]) {
			placeholder.tintColor = .ypBlack
			placeholder.tintColor = .ypGray
		}
		return placeholder
	}
	
	//MARK: -Lifecycle
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .clear
		selectionStyle = .none
		setUpSubViews()
		setLayoutSubViews()
		setUpGradientBackground()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		cellImage.kf.cancelDownloadTask()
		cellImage.image = nil
	}
	
	override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		gradient.frame = gradientView.bounds
	}
	
	//MARK: - Public Methods
	func configure(image: String, date: String, likeState: UIImage) {
		cellImage.kf.setImage(
			with: URL(string: image),
			placeholder: placeholder
		)
		dateLabel.text = date
		likeButton.setImage(likeState, for: .normal)
	}
	
	//MARK: - Private UI methods
	private func setUpSubViews() {
		[
			cellImage,
			likeButton,
			gradientView,
			dateLabel
		].forEach { subView in
			addSubview(subView)
		}
	}
	
	private func setLayoutSubViews() {
		NSLayoutConstraint.activate(
			[
				cellImage.topAnchor.constraint(equalTo: topAnchor, constant: Sizes.ImageCell.Image.top),
				cellImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Sizes.ImageCell.Image.bottom),
				cellImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.ImageCell.Image.leading),
				cellImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Sizes.ImageCell.Image.trailing),
				likeButton.heightAnchor.constraint(equalToConstant: Sizes.ImageCell.LikeButton.size),
				likeButton.widthAnchor.constraint(equalToConstant: Sizes.ImageCell.LikeButton.size),
				likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
				likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
				gradientView.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor),
				gradientView.heightAnchor.constraint(equalToConstant: Sizes.ImageCell.GradientView.height),
				gradientView.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
				gradientView.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
				dateLabel.topAnchor.constraint(
					equalTo: gradientView.topAnchor,
					constant: Sizes.ImageCell.DateLabel.top
				),
				dateLabel.bottomAnchor.constraint(
					equalTo: gradientView.bottomAnchor,
					constant: Sizes.ImageCell.DateLabel.bottom
				),
				dateLabel.leadingAnchor.constraint(
					equalTo: gradientView.leadingAnchor,
					constant: Sizes.ImageCell.DateLabel.leading
				),
				dateLabel.trailingAnchor.constraint(
					greaterThanOrEqualTo: gradientView.trailingAnchor,
					constant: Sizes.ImageCell.DateLabel.trailing
				),
			]
		)
	}
	
	private func setUpGradientBackground() {
		gradient.colors = [
			UIColor.ypBlack.withAlphaComponent(0.0).cgColor,
			UIColor.ypBlack.withAlphaComponent(0.4).cgColor
		]
		gradientView.layer.insertSublayer(gradient, at: 0)
	}
}
