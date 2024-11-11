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
  
  // MARK: - Constants
  private enum Constants {
    enum Size {
      static let defaultImageSize: CGFloat = 19.0
      static let largeImageSize: CGFloat = 20.0
      static let defaultFontSize: CGFloat = 10.0
      static let largeFontSize: CGFloat = 12.0
      static let extraLargeFontSize: CGFloat = 13.0
      
      static let titleBottomMargin: CGFloat = 2.0
      static let imageBottomOffset: CGFloat = 6.0
      static let horizontalSpacing: CGFloat = 5.0
      static let extraHorizontalSpacing: CGFloat = 6.0
      
      static let titleOffset: CGFloat = 12.25
      static let extraTitleOffset: CGFloat = 14.25
    }
    
    static let selectedColor = UIColor.color(r: 0, g: 80, b: 47)
  }
  
  // MARK: - Properties
  private var isWideLayout: Bool {
    if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
      let isLandscape = keyWindow.bounds.width > keyWindow.bounds.height
      return isLandscape || traitCollection.horizontalSizeClass == .regular
    }
    return false
  }
  
  private var isTripleScale: Bool {
    return UIScreen.main.scale == 3.0
  }
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupInitialState()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setupInitialState() {
    renderingMode = .alwaysOriginal
    highlightTextColor = Constants.selectedColor
    imageView.contentMode = .scaleAspectFit
  }
  
  // MARK: - Layout
  override func updateLayout() {
    updateViewsVisibility()
    
    if itemContentMode == .alwaysTemplate {
      layoutTemplateMode()
    } else {
      layoutDefaultMode()
    }
    
    updateBadgeViewLayout()
  }
  
  // MARK: - Private layout methods
  private func updateViewsVisibility() {
    imageView.isHidden = imageView.image == nil
    titleLabel.isHidden = titleLabel.text == nil
  }
  
  private func layoutTemplateMode() {
    let imageSize = calculateImageSize()
    let fontSize = calculateFontSize()
    
    if !imageView.isHidden && !titleLabel.isHidden {
      layoutTemplateWithImageAndTitle(imageSize: imageSize, fontSize: fontSize)
    } else if !imageView.isHidden {
      layoutTemplateWithImageOnly(imageSize: imageSize)
    } else if !titleLabel.isHidden {
      layoutTemplateWithTitleOnly(fontSize: fontSize)
    }
  }
  
  private func layoutDefaultMode() {
    if !imageView.isHidden && !titleLabel.isHidden {
      layoutDefaultWithImageAndTitle()
    } else if !imageView.isHidden {
      layoutDefaultWithImageOnly()
    } else if !titleLabel.isHidden {
      layoutDefaultWithTitleOnly()
    }
  }
  
  private func calculateImageSize() -> CGFloat {
    return isWideLayout && isTripleScale ? Constants.Size.largeImageSize : Constants.Size.defaultImageSize
  }
  
  private func calculateFontSize() -> CGFloat {
    if isWideLayout {
      return isTripleScale ? Constants.Size.extraLargeFontSize : Constants.Size.largeFontSize
    }
    return Constants.Size.defaultFontSize
  }
  
  private func layoutTemplateWithImageAndTitle(imageSize: CGFloat, fontSize: CGFloat) {
    titleLabel.font = .systemFont(ofSize: fontSize)
    titleLabel.sizeToFit()
    
    if isWideLayout {
      layoutWideTemplateWithImageAndTitle(imageSize: imageSize)
    } else {
      layoutNarrowTemplateWithImageAndTitle(imageSize: imageSize)
    }
  }
  
  private func layoutWideTemplateWithImageAndTitle(imageSize: CGFloat) {
    let titleOffset = isTripleScale ? Constants.Size.extraTitleOffset : Constants.Size.titleOffset
    let spacing = isTripleScale ? Constants.Size.extraHorizontalSpacing : Constants.Size.horizontalSpacing
    
    titleLabel.frame = CGRect(
      x: (bounds.width - titleLabel.bounds.width) / 2.0 + titleOffset,
      y: (bounds.height - titleLabel.bounds.height) / 2.0,
      width: titleLabel.bounds.width,
      height: titleLabel.bounds.height
    )
    
    imageView.frame = CGRect(
      x: titleLabel.frame.minX - imageSize - spacing,
      y: (bounds.height - imageSize) / 2.0,
      width: imageSize,
      height: imageSize
    )
  }
  
  private func layoutNarrowTemplateWithImageAndTitle(imageSize: CGFloat) {
    titleLabel.frame = CGRect(
      x: (bounds.width - titleLabel.bounds.width) / 2.0,
      y: bounds.height - titleLabel.bounds.height - Constants.Size.titleBottomMargin,
      width: titleLabel.bounds.width,
      height: titleLabel.bounds.height
    )
    
    imageView.frame = CGRect(
      x: (bounds.width - imageSize) / 2.0,
      y: (bounds.height - imageSize) / 2.0 - Constants.Size.imageBottomOffset,
      width: imageSize,
      height: imageSize
    )
  }
  
  private func layoutTemplateWithImageOnly(imageSize: CGFloat) {
    imageView.frame = CGRect(
      x: (bounds.width - imageSize) / 2.0,
      y: (bounds.height - imageSize) / 2.0,
      width: imageSize,
      height: imageSize
    )
  }
  
  private func layoutTemplateWithTitleOnly(fontSize: CGFloat) {
    titleLabel.font = .systemFont(ofSize: fontSize)
    titleLabel.sizeToFit()
    titleLabel.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
  }
  
  private func layoutDefaultWithImageAndTitle() {
    titleLabel.sizeToFit()
    imageView.sizeToFit()
    
    titleLabel.frame = CGRect(
      x: (bounds.width - titleLabel.bounds.width) / 2.0,
      y: bounds.height - titleLabel.bounds.height - Constants.Size.titleBottomMargin,
      width: titleLabel.bounds.width,
      height: titleLabel.bounds.height
    )
    
    imageView.frame = CGRect(
      x: (bounds.width - imageView.bounds.width) / 2.0,
      y: (bounds.height - imageView.bounds.height) / 2.0 - Constants.Size.imageBottomOffset,
      width: imageView.bounds.width,
      height: imageView.bounds.height
    )
  }
  
  private func layoutDefaultWithImageOnly() {
    imageView.sizeToFit()
    imageView.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
  }
  
  private func layoutDefaultWithTitleOnly() {
    titleLabel.sizeToFit()
    titleLabel.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
  }
  
  private func updateBadgeViewLayout() {
    guard badgeView.superview != nil else { return }
    
    let size = badgeView.sizeThatFits(bounds.size)
    let origin: CGPoint
    
    if itemContentMode == .alwaysTemplate && isWideLayout {
      origin = CGPoint(
        x: imageView.frame.midX - 3 + badgeOffset.horizontal,
        y: imageView.frame.midY + 3 + badgeOffset.vertical
      )
    } else {
      origin = CGPoint(
        x: bounds.width / 2.0 + badgeOffset.horizontal,
        y: bounds.height / 2.0 + badgeOffset.vertical
      )
    }
    
    badgeView.frame = CGRect(origin: origin, size: size)
    badgeView.setNeedsLayout()
  }
}
