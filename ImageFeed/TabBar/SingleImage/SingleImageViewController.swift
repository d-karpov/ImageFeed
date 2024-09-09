//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Denis on 13.07.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
	
	//MARK: - Public variables
	var image: UIImage? {
		didSet {
			if let image = image, isViewLoaded {
				imageView.image = image
				imageView.frame.size = image.size
				rescaleAndCenterImage(image: image)
			}
		}
	}
	
	//MARK: - Private Variables
	private let imageView: UIImageView = .init()
	private let scrollView: UIScrollView = .init()
	private let backButton: UIButton = .init(type: .system)
	private let shareButton: UIButton = .init(type: .system)
	private var basicScale: CGFloat = 0
	
	//MARK: -Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .ypBlack
		setUpSubviews()
		setLayoutSubviews()

		if let image = image {
			imageView.image = image
			imageView.frame.size = image.size
			rescaleAndCenterImage(image: image)
		}
		addDoubleTapGesture()
	}
	
	//MARK: - Private Methods
	private func setUpSubviews() {
		view.addSubview(scrollView)
		setUpScrollView()
		scrollView.addSubview(imageView)
		view.addSubview(backButton)
		setUpBackButton()
		view.addSubview(shareButton)
		setUpShareButton()
	}
	
	private func setLayoutSubviews() {
		backButton.translatesAutoresizingMaskIntoConstraints = false
		shareButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(
			[
				//BackButton
				backButton.topAnchor.constraint(
					equalTo: view.topAnchor,
					constant: Sizes.SingleImageView.BackButton.top
				),
				backButton.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: Sizes.SingleImageView.BackButton.leading
				),
				backButton.heightAnchor.constraint(equalToConstant: Sizes.SingleImageView.BackButton.size),
				backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
				//ShareButton
				shareButton.heightAnchor.constraint(equalToConstant: Sizes.SingleImageView.ShareButton.size),
				shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor),
				shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				shareButton.bottomAnchor.constraint(
					equalTo: view.bottomAnchor,
					constant: Sizes.SingleImageView.ShareButton.bottom
				)
			]
		)
	}
	
	private func setUpScrollView() {
		scrollView.delegate = self
		scrollView.minimumZoomScale = 0.1
		scrollView.maximumZoomScale = 1.25
		scrollView.frame = view.bounds
	}
	
	private func setUpBackButton() {
		backButton.tintColor = .ypWhite
		backButton.setImage(.backButton, for: .normal)
		backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
	}
	
	private func setUpShareButton() {
		shareButton.backgroundColor = .ypBlack
		shareButton.tintColor = .ypWhite
		shareButton.setImage(.shareButton, for: .normal)
		shareButton.layer.cornerRadius = Sizes.SingleImageView.ShareButton.cornerRadius
		shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
	}
	
	private func rescaleAndCenterImage(image: UIImage) {
		let minZoomScale = scrollView.minimumZoomScale
		let maxZoomScale = scrollView.maximumZoomScale
		let visibleRectSize = scrollView.bounds.size
		let imageSize = image.size
		let hScale = visibleRectSize.width/imageSize.width
		let vScale = visibleRectSize.height/imageSize.height
		basicScale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
		scrollView.setZoomScale(basicScale, animated: false)
		scrollView.layoutIfNeeded()
	}
	
	private func addDoubleTapGesture() {
		let doubleTabGesture = UITapGestureRecognizer(target: self, action: #selector(quickZoom))
		doubleTabGesture.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(doubleTabGesture)
	}
	
	//MARK: - Actions
	@objc private func quickZoom() {
		if scrollView.zoomScale > basicScale {
			scrollView.setZoomScale(basicScale, animated: true)
		} else {
			scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
		}
		scrollView.layoutIfNeeded()
	}
	
	@objc private func didTapShareButton() {
		guard let image = image else { return }
		let activityView = UIActivityViewController(activityItems: [image], applicationActivities: .none)
		present(activityView, animated: true)
	}
	
	@objc private func didTapBackButton() {
		dismiss(animated: true)
	}
}
//MARK: - ScrollView Delegate
extension SingleImageViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		let xOffset = max((scrollView.bounds.width - scrollView.contentSize.width)*0.5, 0)
		let yOffset = max((scrollView.bounds.height - scrollView.contentSize.height)*0.5, 0)
		scrollView.contentInset = UIEdgeInsets(top: yOffset, left: xOffset, bottom: yOffset, right: xOffset)
	}
}
