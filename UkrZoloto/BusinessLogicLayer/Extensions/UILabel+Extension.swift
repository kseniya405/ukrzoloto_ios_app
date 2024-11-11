//
//  UILabel+Extension.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/4/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

extension UILabel {
  
  func setLineHeight(_ lineHeight: CGFloat) {
    let style = NSMutableParagraphStyle()
    
    style.lineHeightMultiple = lineHeight / self.font.pointSize
    style.lineBreakMode = .byTruncatingTail
    style.alignment = self.textAlignment
    
    if let attributedString = self.attributedText {
      let newAttributedString = NSMutableAttributedString(attributedString: attributedString)
      newAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                       value: style,
                                       range: NSRange(location: 0, length: attributedString.string.count))
      
      self.attributedText = newAttributedString
      
    } else if let text = self.text {
      let attributeString = NSMutableAttributedString(string: text)
      attributeString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                   value: style,
                                   range: NSRange(location: 0, length: text.count))
      
      self.attributedText = attributeString
    }
  }
  
  func addCharacterSpacing(kernValue: Double = 1.15) {
    if let labelText = text, !labelText.isEmpty {
      let attributedString = NSMutableAttributedString(string: labelText)
      attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
