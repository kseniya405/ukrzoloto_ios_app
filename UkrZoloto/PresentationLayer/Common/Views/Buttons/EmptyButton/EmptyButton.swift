//
//  EmptyButton.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class EmptyButton: UIButton {
  
  // MARK: - Public variables
  var letterSpacing: CGFloat = UIConstants.Label.letterSpacing {
    didSet {
      setTitle(title(for: state), for: state)
    }
  }
  
  var borderColor: UIColor = UIConstants.Button.borderColor {
    didSet {
      layer.borderColor = UIConstants.Button.borderColor.cgColor
    }
  }
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  // MARK: - Configure
  private func setupView() {
    titleLabel?.font = UIConstants.Label.font
    layer.cornerRadius = UIConstants.Button.cornerRadius
    setTitleColor(UIConstants.Label.color, for: .normal)
    backgroundColor = UIColor.clear
    layer.borderColor = borderColor.cgColor
    layer.borderWidth = UIConstants.Button.borderWidth
  }
  
  // MARK: - Public methods
  override func setTitle(_ title: String?, for state: UIControl.State) {
    super.setTitle(nil, for: state)
    guard let title = title,
      !title.isEmpty else {
        setAttributedTitle(nil, for: state)
        return
    }
    let attributedString = NSMutableAttributedString(string: title)
    let attrs: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.kern: letterSpacing,
      NSAttributedString.Key.foregroundColor: titleColor(for: state) ?? UIConstants.Label.color,
      NSAttributedString.Key.font: titleLabel?.font ?? UIConstants.Label.font
    ]
    attributedString.addAttributes(attrs,
                                   range: NSRange(location: 0, length: attributedString.length))
    setAttributedTitle(attributedString, for: state)
  }
}

private enum UIConstants {
  enum Label {
    static let font = UIFont.boldAppFont(of: 14)
    static let letterSpacing: CGFloat = 0.84
    static let color = UIColor.color(r: 0, g: 80, b: 47)
  }
  enum Button {
    static let cornerRadius: CGFloat = 22
    static let borderWidth: CGFloat = 1
    static let borderColor = UIColor.color(r: 246, g: 246, b: 246)
  }
}
