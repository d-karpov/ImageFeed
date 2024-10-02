//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Denis on 13.07.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
	
	//MARK: - Public variables
	var imageURLString: String?
	
	//MARK: - Private Variables
	private var placeholder: UIImageView {
		let placeholder = UIImageView()
		placeholder.backgroundColor = .clear
		placeholder.image = .imageStub
		placeholder.contentMode = .center
		UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse]) {
			placeholder.tintColor = .clear
			placeholder.tintColor = .ypWhite
		}
		return placeholder
	}
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
		addDoubleTapGesture()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setImage()
	}
	
	//MARK: - Private UI methods
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
		backButton.accessibilityIdentifier = UIElementsIdentifiers.backButton
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
		let x = (scrollView.contentSize.width - visibleRectSize.width) / 2
		let y = (scrollView.contentSize.height - visibleRectSize.height) / 2
		scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
	}
	
	private func addDoubleTapGesture() {
		let doubleTabGesture = UITapGestureRecognizer(target: self, action: #selector(quickZoom))
		doubleTabGesture.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(doubleTabGesture)
	}
	
	private func setImage() {
		if let imageURLString {
			imageView.frame.size = view.bounds.size
			imageView.kf.setImage(
				with: URL(string: imageURLString),
				placeholder: placeholder
			) { [weak self] result in
				guard let self else { preconditionFailure("No SingleImageViewController!!!") }
				switch result {
				case .success(let retrievedData):
					imageView.frame.size = retrievedData.image.size
					rescaleAndCenterImage(image: retrievedData.image)
				case .failure(_):
					AlertPresenter.showDownloadError(at: self, with: setImage)
				}
			}
		}
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
		guard let image = imageView.image else { return }
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
