//
//  BonusesButton.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 04.05.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

class BonusesButton: UIButton {
  
  // MARK: - Public variables
  override var isEnabled: Bool {
    didSet {
      update()
    }
  }
  
  var letterSpacing: CGFloat = UIConstants.Label.letterSpacing {
    didSet {
      setTitle(title(for: state), for: state)
    }
  }
  
  // MARK: - Private variables
  private var buttonState: UIControl.State = .normal
  
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
    setTitleColor(UIConstants.Label.activeColor, for: .normal)
    setTitleColor(UIConstants.Label.inactiveColor, for: .disabled)
    update()
  }
  
  // MARK: - Public methods
  override func setTitle(_ title: String?, for state: UIControl.State) {
    super.setTitle(nil, for: buttonState)
    guard let title = title,
      !title.isEmpty else {
        setAttributedTitle(nil, for: buttonState)
        return
    }
    let attributedString = NSMutableAttributedString(string: title)
    let attrs: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.kern: letterSpacing,
      NSAttributedString.Key.foregroundColor: titleColor(for: buttonState) ?? UIConstants.Label.inactiveColor,
      NSAttributedString.Key.font: titleLabel?.font ?? UIConstants.Label.font
    ]
    attributedString.addAttributes(attrs,
                                   range: NSRange(location: 0, length: attributedString.length))
    
    setAttributedTitle(attributedString, for: .normal)
    setAttributedTitle(attributedString, for: .disabled)
  }
  
  // MARK: - Private methods
  private func update() {
    backgroundColor = isEnabled ? UIConstants.Button.activeColor : UIConstants.Button.inactiveColor
    buttonState = isEnabled ? .normal : .disabled
    setTitle(attributedTitle(for: buttonState)?.string, for: buttonState)
  }
  
}

private enum UIConstants {
  enum Label {
    static let font = UIFont.boldAppFont(of: 14)
    static let letterSpacing: CGFloat = 0.6
    static let activeColor = UIColor.color(r: 0, g: 80, b: 47)
    static let inactiveColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.45)
  }
  enum Button {
    static let cornerRadius: CGFloat = 22

    static let activeColor = UIColor.color(r: 255, g: 220, b: 136)
    static let inactiveColor = UIColor.color(r: 230, g: 230, b: 230)
  }
}
