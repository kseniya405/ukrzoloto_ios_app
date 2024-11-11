//
//  PKHUD+Extension.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/18/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import PKHUD

extension HUD {
  static func showProgress(hideTimeout: TimeInterval = 30) {
    guard UIApplication.shared.windows.filter({$0.isKeyWindow}).first != nil else { return }
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    view.backgroundColor = .clear
    let imageView = AnimatedImageView(image: #imageLiteral(resourceName: "loaderYellow"))
    imageView.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
    imageView.backgroundColor = .clear
    view.addSubview(imageView)
    imageView.startAnimating()
    self.show(.customView(view: view))
    self.hide(afterDelay: hideTimeout)
  }
}
