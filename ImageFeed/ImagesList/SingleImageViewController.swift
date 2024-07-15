//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Denis on 13.07.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
	var image: UIImage? {
		didSet {
			if let image = image, isViewLoaded {
				imageView.image = image
				imageView.frame.size = image.size
				rescaleAndCenterImage(image: image)
			}
		}
	}
	
	
	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.minimumZoomScale = 0.1
		scrollView.maximumZoomScale = 1.25
		
		if let image = image {
			imageView.image = image
			imageView.frame.size = image.size
			rescaleAndCenterImage(image: image)
		}
	}
	
	private func rescaleAndCenterImage(image: UIImage) {
		let minZoomScale = scrollView.minimumZoomScale
		let maxZoomScale = scrollView.maximumZoomScale
		view.layoutIfNeeded()
		let visibleRectSize = scrollView.bounds.size
		print(visibleRectSize)
		let imageSize = image.size
		let hScale = visibleRectSize.width/imageSize.width
		let vScale = visibleRectSize.height/imageSize.height
		let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
		scrollView.setZoomScale(scale, animated: false)
		scrollView.layoutIfNeeded()
		let newContentSize = scrollView.contentSize
		let x = (newContentSize.width - visibleRectSize.width)/2
		let y = (newContentSize.height - visibleRectSize.height)/2
		scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
		print(scrollView.contentInset)
		
	}

	@IBAction private func didTapShareButton() {
		guard let image = image else { return }
		let activityView = UIActivityViewController(activityItems: [image], applicationActivities: .none)
		present(activityView, animated: true)
	}
	
	@IBAction private func didTapBackButton() {
		dismiss(animated: true)
	}
}

extension SingleImageViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		imageView
	}
}
