//
//  UIImageView+Extension.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SDWebImage
import SDWebImageSVGKitPlugin
import SVGKit

extension UIImageView {
  
  func setImage(from viewModel: ImageViewModel) {
    switch viewModel {
    case .image(let image):
      self.image = image
    case .url(let url, let placeholder):
      setImage(url: url, placeholder: placeholder)
    }
  }
  
  func setImage(path: String, placeholder: UIImage? = nil, size: CGSize? = nil) {
    let url = URL(string: path)
		setImage(url: url, placeholder: placeholder, size: size)
  }
  
	func setImage(url: URL?, placeholder: UIImage? = nil, size: CGSize? = nil) {
    DispatchQueue.main.async {
			var context: [SDWebImageContextOption : Any]?
			if let size = size {
				context = [SDWebImageContextOption.imageThumbnailPixelSize : size]
			}
			self.sd_setImage(with: url, placeholderImage: placeholder, options: .transformVectorImage, context: context)
    }
  }
}
