//
//  IrregularityContentView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/14/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class IrregularityContentView: BaseTabBarItemContentView {
    
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.imageView.backgroundColor = .clear
    self.imageView.layer.cornerRadius = UIConstants.cornerRadius
    self.insets = UIConstants.insets
    let transform = CGAffineTransform.identity
    self.imageView.transform = transform
    self.superview?.bringSubviewToFront(self)
    iconColor = UIColor.clear
    highlightIconColor = .clear
    backdropColor = .clear
    highlightBackdropColor = .clear
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let p = CGPoint.init(x: point.x - imageView.frame.origin.x,
                         y: point.y - imageView.frame.origin.y)
    let w2 = pow(imageView.bounds.size.width / 2.0 - p.x, 2)
    let h2 = pow(imageView.bounds.size.height / 2.0 - p.y, 2)
    return sqrt(w2 + h2) < imageView.bounds.size.width / 2.0
  }
  
  override func updateLayout() {
    super.updateLayout()
    self.imageView.sizeToFit()
    self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0,
                                         y: self.bounds.size.height / 2.0)
  }
  
  public override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
    completion?()
  }
  
  public override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
    completion?()
  }
  
  public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
    UIView.animate(withDuration: 0.2) {
      let transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
      self.imageView.transform = transform
    }
  }
  
  public override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
    UIView.animate(withDuration: 0.2) {
      let transform = CGAffineTransform.identity
      self.imageView.transform = transform
    }
  }
}

private enum UIConstants {
  static let insets = UIEdgeInsets(top: -42, left: 0, bottom: 0, right: 0)
  static let cornerRadius: CGFloat = 42
}
