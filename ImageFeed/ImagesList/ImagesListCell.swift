//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Denis on 06.07.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
	
	static let reuseIdentifier: String = "ImagesListCell"
	
	@IBOutlet weak var likeButton: UIButton!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var cellImage: UIImageView!
	
	@IBOutlet private weak var gradientView: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setUpGradientBackground()
	}
	
	private func setUpGradientBackground() {
		let gradient = CAGradientLayer()
		gradient.frame = gradientView.bounds
		gradient.colors = [
			UIColor.ypBlack.withAlphaComponent(0.0).cgColor,
			UIColor.ypBlack.withAlphaComponent(0.2).cgColor
		]
		gradientView.layer.insertSublayer(gradient, at: 0)
	}
}
