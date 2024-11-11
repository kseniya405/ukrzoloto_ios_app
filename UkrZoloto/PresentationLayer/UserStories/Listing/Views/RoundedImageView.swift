//
//  RoundedImageView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 10/3/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
  
  // MARK: - Public variables
  var cornerRadius: CGFloat = UIConstants.radius
  
  // MARK: - Life cycle
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = cornerRadius
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  static let radius: CGFloat = 16
}
