//
//  ShopMapMarker.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import GoogleMaps
import SnapKit

class ShopMapMarker: GMSMarker {
  
  // MARK: - Public variables
  var imageView: UIImageView? {
    return iconView as? UIImageView
  }
  
  // MARK: - Life Cycle
  override init() {
    super.init()
		iconView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIConstants.width, height: UIConstants.height)))
    imageView?.contentMode = .scaleAspectFit
//    imageView?.snp.makeConstraints { make in
//      make.height.equalTo(UIConstants.height)
//				.priority(.medium)
//      make.width.equalTo(UIConstants.width)
//				.priority(.medium)
//    }
    initConfigure()
  }
  
  // MARK: - InitConfigure
  private func initConfigure() {
    imageView?.image = #imageLiteral(resourceName: "ShopMarker")
  }
  
  // MARK: Configure
  func configure(icon: UIImage?) {
    imageView?.image = icon
  }
}

private enum UIConstants {
  static let width: CGFloat = 55
  static let height: CGFloat = 70
}
