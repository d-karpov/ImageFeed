//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Denis on 13.07.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
	//MARK: - IBOutlets
	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet weak var scrollView: UIScrollView!
	
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
	private var basicScale: CGFloat = 0
	
	//MARK: -Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.minimumZoomScale = 0.1
		scrollView.maximumZoomScale = 1.25
		
		if let image = image {
			imageView.image = image
			imageView.frame.size = image.size
			rescaleAndCenterImage(image: image)
		}
		addDoubleTapGesture()
	}
	
	//MARK: - Private Methods
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
	
	@objc private func quickZoom() {
		if scrollView.zoomScale > basicScale {
			scrollView.setZoomScale(basicScale, animated: true)
		} else {
			scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
		}
		scrollView.layoutIfNeeded()
	}
	
	//MARK: - IBActions
	@IBAction private func didTapShareButton() {
		guard let image = image else { return }
		let activityView = UIActivityViewController(activityItems: [image], applicationActivities: .none)
		present(activityView, animated: true)
	}
	
	@IBAction private func didTapBackButton() {
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
