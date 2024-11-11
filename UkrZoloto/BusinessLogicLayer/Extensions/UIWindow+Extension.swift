//
//  UIWindow+Extension.swift
//  UkrZoloto
//
//  Created by user on 01.09.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

extension UIWindow {
  func showAddedToCartPopup(with text: String) -> UIView {
    let popupView = configurePopupView()
    let textLabel = configureLabel(for: popupView)
    textLabel.text = text
    bringSubviewToFront(popupView)
    
    UIWindow.animateKeyframes(withDuration: UIConstants.PopupAnimation.duration,
                              delay: UIConstants.PopupAnimation.delay,
                              options: .calculationModeLinear,
                              animations: {
      popupView.frame.origin.x = Constants.Screen.screenWidth / 2
      popupView.frame.origin.y = -Constants.Screen.screenHeight / 2
      UIWindow.addKeyframe(withRelativeStartTime: 0,
                           relativeDuration: UIConstants.PopupAnimation.transitionRelativeDuration) {
        popupView.frame.origin.y = UIConstants.PopupView.top
      }
      UIWindow.addKeyframe(withRelativeStartTime: 1.0 - UIConstants.PopupAnimation.transitionRelativeDuration,
                           relativeDuration: UIConstants.PopupAnimation.transitionRelativeDuration) {
        popupView.frame.origin.y = -Constants.Screen.screenHeight / 2
        popupView.alpha = 0
      }
    }, completion: { _ in
      popupView.isHidden = true
      popupView.removeFromSuperview()
    })
    return popupView
  }
  
  // MARK: - Private functions
  private func configurePopupView() -> UIView {
    let popupView = UIView()
    addSubview(popupView)
    popupView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.PopupView.sides)
      make.height.greaterThanOrEqualTo(UIConstants.PopupView.height)
      make.bottom.lessThanOrEqualToSuperview()
      make.centerX.equalToSuperview()
    }
    popupView.backgroundColor = UIConstants.PopupView.backgroundColor
    popupView.layer.cornerRadius = UIConstants.PopupView.radius
    return popupView
  }
  
  private func configureLabel(for view: UIView) -> UILabel {
    let addedToCartTitleLabel: UILabel = {
      let label = LineHeightLabel()
      label.lineHeight = UIConstants.AddedToCartTitleLabel.height
      label.config
        .font(UIConstants.AddedToCartTitleLabel.font)
        .textColor(UIConstants.AddedToCartTitleLabel.color)
        .numberOfLines(1)
        .textAlignment(.center)
      return label
    }()
    
    view.addSubview(addedToCartTitleLabel)
    addedToCartTitleLabel.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
        .inset(UIConstants.AddedToCartTitleLabel.vertical)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.AddedToCartTitleLabel.sides)
    }
    
    return addedToCartTitleLabel
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum PopupView {
    static let height: CGFloat = 54
    static let top: CGFloat = 52
    static let sides: CGFloat = 24
    static let backgroundColor = UIColor.color(r: 29, g: 31, b: 31)
    static let radius: CGFloat = 16
  }
  
  enum AddedToCartTitleLabel {
    static let height: CGFloat = 18
    static let font: UIFont = UIFont.regularAppFont(of: 15)
    static let color = UIColor.white
    
    static let vertical: CGFloat = 17
    static let sides: CGFloat = 24
  }
  
  enum PopupAnimation {
    static let delay: Double = 0.1
    static let duration: Double = 6.0
    static let transitionDuration: Double = 0.5
    static let transitionRelativeDuration: Double = PopupAnimation.transitionDuration / PopupAnimation.duration
  }
}
