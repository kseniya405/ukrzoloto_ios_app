//
//  ShopInfoPopupView.swift
//  UkrZoloto
//
//  Created by user on 25.08.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

class ShopInfoPopupView: ShopInfoView {
  // MARK: - Public variables
  let closeButton = UIButton()
  
  override func initConfigure() {
    super.initConfigure()
    configureCloseButton()
  }
  
  private func configureCloseButton() {
    addSubview(closeButton)
    closeButton.snp.makeConstraints { make in
      make.width.height.equalTo(UIConstants.CloseButton.dimensions)
      make.top.equalToSuperview()
        .offset(UIConstants.CloseButton.top)
      make.trailing.equalToSuperview()
        .inset(UIConstants.CloseButton.trailing)
    }
    closeButton.setImage(UIConstants.CloseButton.image, for: .normal)
    closeButton.backgroundColor = UIConstants.CloseButton.color
    closeButton.layer.cornerRadius = UIConstants.CloseButton.radius
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum CloseButton {
    static let dimensions: CGFloat = 24
    static let top: CGFloat = 10
    static let trailing: CGFloat = 10
    static let image = #imageLiteral(resourceName: "controlsClearField")
    static let color = UIColor.color(r: 243, g: 244, b: 245)
    static let radius: CGFloat = 12
  }
}
