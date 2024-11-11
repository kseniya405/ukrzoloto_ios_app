//
//  GreyButton.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class GreyButton: UIButton {
  
  // MARK: - Public variables
  var textColor = UIConstants.Label.color
  
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
    backgroundColor = UIConstants.Button.color
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
      NSAttributedString.Key.kern: UIConstants.Label.letterSpacing,
      NSAttributedString.Key.foregroundColor: textColor,
      NSAttributedString.Key.font: UIConstants.Label.font
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
    static let color = UIColor.color(r: 21, g: 80, b: 74, a: 0.1)
  }
}
