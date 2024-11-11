//
//  UIView+Extension.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 11.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

extension UIView {
	func roundCorners(corners: CACornerMask? = nil, radius: CGFloat, borderWidth: CGFloat = 0, borderColor: CGColor = CGColor(gray: 0, alpha: 0)) {
		layer.masksToBounds = true
		layer.cornerRadius = radius
		if let corners = corners {
			layer.maskedCorners = corners
		}
		layer.borderWidth = borderWidth
		layer.borderColor = borderColor
  }
	
  func image() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
	
	func roundCornerWithMask(corners: UIRectCorner = .allCorners, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: bounds,
														byRoundingCorners: corners,
														cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		layer.mask = mask
	}
	
	class func initFromNib<T: UIView>() -> T {
			return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
	}
	
  func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white, width: CGFloat? = nil) {
    
    let shadowLayer = CAShapeLayer()
    let size = CGSize(width: cornerRadius, height: cornerRadius)
    var rect = self.bounds
    if let width = width {
      rect = CGRect(x: 0, y: shadowRadius, width: width, height: self.bounds.height)
    }
    let cgPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: size).cgPath
    shadowLayer.path = cgPath
    shadowLayer.fillColor = fillColor.cgColor
    shadowLayer.shadowColor = shadowColor.cgColor
    shadowLayer.shadowPath = cgPath
    shadowLayer.shadowOffset = offSet
    shadowLayer.shadowOpacity = opacity
    shadowLayer.shadowRadius = shadowRadius
    self.layer.insertSublayer(shadowLayer, at: 0)
  }
}
