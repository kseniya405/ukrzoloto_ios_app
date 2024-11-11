//
//  RoundedButton.swift
//  UkrZoloto
//
//  Created by Mykola on 24.07.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class RoundedButton: UIButton {
  
  private var fillColor: UIColor = .white
  private var textColor: UIColor = .black
  
  convenience init(fillColor: UIColor, textColor: UIColor) {
    
    self.init()
    
    self.fillColor = fillColor
    self.textColor = textColor
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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = UIConstants.Button.cornerRadius
    layer.backgroundColor = fillColor.cgColor
  }
  
  override func setTitle(_ title: String?, for state: UIControl.State) {
    super.setTitle(title, for: state)
    
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
  
  private func setupView() {
    
    translatesAutoresizingMaskIntoConstraints = false
//    titleLabel?.font = UIConstants.Label.font
    clipsToBounds = true
    setTitleColor(UIConstants.Label.color, for: .normal)
  }
  
  private enum UIConstants {
    enum Label {
      static let font = UIFont.boldAppFont(of: 14)
      static let letterSpacing: CGFloat = 0.84
      static let color = UIColor.color(r: 0, g: 80, b: 47)
    }
    enum Button {
      static let cornerRadius: CGFloat = 22
    }
  }
}
