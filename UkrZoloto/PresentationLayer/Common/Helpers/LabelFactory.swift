//
//  LabelFactory.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 19.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class LabelFactory {
  
  // MARK: - Singleton
  static let shared = LabelFactory()
  
  // MARK: - Life cycle
  private init() { }
  
  // MARK: - Interface
  func createLabel(color: UIColor, font: UIFont, height: CGFloat, numbersOfLines: Int = 1) -> UILabel {
    let label = LineHeightLabel()
    label.config
      .font(font)
      .textColor(color)
      .numberOfLines(numbersOfLines)
    label.lineHeight = height
    return label
  }
  
}
