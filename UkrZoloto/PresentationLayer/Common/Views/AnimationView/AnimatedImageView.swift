//
//  AnimatedImageView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/19/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class AnimatedImageView: UIImageView {

  override func startAnimating() {
    let rotation = CABasicAnimation(keyPath: "transform.rotation")
    rotation.fromValue = 0
    rotation.toValue = 2 * Double.pi
    rotation.duration = 1
    rotation.repeatCount = Float.infinity
    layer.add(rotation, forKey: UIConstants.spinKey)
  }

  override func stopAnimating() {
    layer.removeAnimation(forKey: UIConstants.spinKey)
  }
}

private enum UIConstants {
  static let spinKey = "Spin"
}
