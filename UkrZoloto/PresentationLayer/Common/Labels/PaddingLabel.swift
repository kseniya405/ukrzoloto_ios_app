//
//  PaddingLabel.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 06.01.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
  var paddings = UIEdgeInsets.zero
  
  override func drawText(in rect: CGRect) {
    let insets = paddings
    super.drawText(in: rect.inset(by: insets))
  }
  
  override var intrinsicContentSize: CGSize {
    let textWidth = super.intrinsicContentSize.width
    let textHeight = sizeThatFits(CGSize(width: textWidth, height: .greatestFiniteMagnitude)).height
    let width = textWidth + paddings.left + paddings.right
    let height = textHeight + paddings.top + paddings.bottom
    return CGSize(width: width, height: height)
  }
}
