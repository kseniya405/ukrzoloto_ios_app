//
//  BaseTabBarItemContentView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/14/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class BaseTabBarItemContentView: ESTabBarItemContentView {
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    renderingMode = .alwaysOriginal
    highlightTextColor = UIConstants.selectedColor
    imageView.contentMode = .scaleAspectFit
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateLayout() {
    let w = self.bounds.size.width
    let h = self.bounds.size.height
    
    imageView.isHidden = (imageView.image == nil)
    titleLabel.isHidden = (titleLabel.text == nil)
    
    if self.itemContentMode == .alwaysTemplate {
      var s: CGFloat = 0.0 // image size
      var f: CGFloat = 0.0 // font
      var isLandscape = false
      if let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
        isLandscape = keyWindow.bounds.width > keyWindow.bounds.height
      }
      let isWide = isLandscape || traitCollection.horizontalSizeClass == .regular // is landscape or regular
      if isWide {
        s = UIScreen.main.scale == 3.0 ? 19.0 : 20.0
        f = UIScreen.main.scale == 3.0 ? 13.0 : 12.0
      } else {
        s = 19.0
        f = 10.0
      }
      
      if !imageView.isHidden && !titleLabel.isHidden {
        titleLabel.font = UIFont.systemFont(ofSize: f)
        titleLabel.sizeToFit()
        if isWide {
          titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0 + (UIScreen.main.scale == 3.0 ? 14.25 : 12.25),
                                    y: (h - titleLabel.bounds.size.height) / 2.0,
                                    width: titleLabel.bounds.size.width,
                                    height: titleLabel.bounds.size.height)
          imageView.frame = CGRect(x: titleLabel.frame.origin.x - s - (UIScreen.main.scale == 3.0 ? 6.0 : 5.0),
                                   y: (h - s) / 2.0,
                                   width: s,
                                   height: s)
        } else {
          titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0,
                                    y: h - titleLabel.bounds.size.height - 2.0,
                                    width: titleLabel.bounds.size.width,
                                    height: titleLabel.bounds.size.height)
          imageView.frame = CGRect(x: (w - s) / 2.0,
                                   y: (h - s) / 2.0 - 6.0,
                                   width: s,
                                   height: s)
        }
      } else if !imageView.isHidden {
        imageView.frame = CGRect(x: (w - s) / 2.0,
                                 y: (h - s) / 2.0,
                                 width: s,
                                 height: s)
      } else if !titleLabel.isHidden {
        titleLabel.font = UIFont.systemFont(ofSize: f)
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0,
                                  y: (h - titleLabel.bounds.size.height) / 2.0,
                                  width: titleLabel.bounds.size.width,
                                  height: titleLabel.bounds.size.height)
      }
      
      if badgeView.superview != nil {
        let size = badgeView.sizeThatFits(self.frame.size)
        if isWide {
          badgeView.frame = CGRect(origin: CGPoint(x: imageView.frame.midX - 3 + badgeOffset.horizontal,
                                                   y: imageView.frame.midY + 3 + badgeOffset.vertical),
                                   size: size)
        } else {
          badgeView.frame = CGRect(origin: CGPoint(x: w / 2.0 + badgeOffset.horizontal,
                                                   y: h / 2.0 + badgeOffset.vertical),
                                   size: size)
        }
        badgeView.setNeedsLayout()
      }
      
    } else {
      if !imageView.isHidden && !titleLabel.isHidden {
        titleLabel.sizeToFit()
        imageView.sizeToFit()
        titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0,
                                  y: h - titleLabel.bounds.size.height - 2.0,
                                  width: titleLabel.bounds.size.width,
                                  height: titleLabel.bounds.size.height)
        imageView.frame = CGRect(x: (w - imageView.bounds.size.width) / 2.0,
                                 y: (h - imageView.bounds.size.height) / 2.0 - 6.0,
                                 width: imageView.bounds.size.width,
                                 height: imageView.bounds.size.height)
      } else if !imageView.isHidden {
        imageView.sizeToFit()
        imageView.center = CGPoint(x: w / 2.0, y: h / 2.0)
      } else if !titleLabel.isHidden {
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: w / 2.0, y: h / 2.0)
      }
      
      if badgeView.superview != nil {
        let size = badgeView.sizeThatFits(self.frame.size)
        badgeView.frame = CGRect(origin: CGPoint(x: w / 2.0 + badgeOffset.horizontal,
                                                 y: h / 2.0 + badgeOffset.vertical),
                                 size: size)
        badgeView.setNeedsLayout()
      }
    }
  }
}

private enum UIConstants {
  static let selectedColor = UIColor.color(r: 0, g: 80, b: 47)
}
