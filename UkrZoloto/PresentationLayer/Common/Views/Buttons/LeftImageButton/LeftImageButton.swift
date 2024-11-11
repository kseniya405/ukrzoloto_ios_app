//
//  LeftImageButton.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 12.03.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class LeftImageButton: UIButton {
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initConfigure()
  }
  
  override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
    return CGRect(x: UIConstants.imageOffset,
                  y: (contentRect.height - UIConstants.imageSide) / 2,
                  width: UIConstants.imageSide,
                  height: UIConstants.imageSide)
  }
  
  override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
    let left = UIConstants.imageSide + UIConstants.titleOffset + UIConstants.imageOffset
    return CGRect(x: left,
                  y: 0,
                  width: contentRect.width - left,
                  height: contentRect.height)
  }
  
  // MARK: - Configure
  private func initConfigure() {
    titleLabel?.textAlignment = .left
    titleLabel?.font = UIFont.regularAppFont(of: 14)
  }
}

private enum UIConstants {
  static let imageSide: CGFloat = 26
  static let imageOffset: CGFloat = 0
  static let titleOffset: CGFloat = 8
}
