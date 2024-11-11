//
//  UITextView+Extension.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 28.02.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

extension UITextView {
  
  func getLineHeight() -> CGFloat {
    return font?.lineHeight ?? 24
  }
  
  func getNumberOfLines() -> Int {
    let lineHeight = getLineHeight()
    if !text.isEmpty {
      return Int((contentSize.height - textContainerInset.top - textContainerInset.bottom) / lineHeight)
    } else {
      return 0
    }
  }
}

extension UITextView {
  
  private class PlaceholderLabel: UILabel { }
  
  private var placeholderLabel: PlaceholderLabel {
    if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
      return label
    } else {
      let label = PlaceholderLabel(frame: .zero)
      label.font = font
      label.textColor = textColor
      addSubview(label)
      return label
    }
  }
  
  var placeholder: String? {
    get {
      return subviews.compactMap { $0 as? PlaceholderLabel }.first?.text
    }
    set {
      let placeholderLabel = self.placeholderLabel
      placeholderLabel.text = newValue
      placeholderLabel.numberOfLines = 0
      let width = frame.width - textContainer.lineFragmentPadding * 2
      let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
      placeholderLabel.frame.size.height = size.height
      placeholderLabel.frame.size.width = width
      placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)
      
      textStorage.delegate = self
    }
  }
  
  var placeholderTextColor: UIColor? {
    get {
      return subviews.compactMap { $0 as? PlaceholderLabel }.first?.textColor
    }
    set {
      placeholderLabel.textColor = newValue
    }
  }
  
}

extension UITextView: @retroactive NSTextStorageDelegate {
  
  public func textStorage(_ textStorage: NSTextStorage,
                          didProcessEditing editedMask: NSTextStorage.EditActions,
                          range editedRange: NSRange, changeInLength delta: Int) {
    if editedMask.contains(.editedCharacters) {
      placeholderLabel.isHidden = !text.isEmpty
    }
  }
  
}
