//
//  RightImageButton.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 26.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
class RightImageButton: UIButton {
  
  // MARK: - Public variables
  var textFont = UIConstants.Label.font {
    didSet {
      setupView()
    }
  }
  
  var textColor = UIConstants.Label.color {
    didSet {
      setupView()
    }
  }
  
  // MARK: - Private variables
  
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
    titleLabel?.font = textFont
    setTitleColor(textColor, for: .normal)
    backgroundColor = UIColor.clear
    imageEdgeInsets = UIConstants.Image.edgeInsets
    imageView?.contentMode = .scaleAspectFit
    semanticContentAttribute = .forceRightToLeft
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
      NSAttributedString.Key.foregroundColor: titleColor(for: state) ?? UIConstants.Label.color,
      NSAttributedString.Key.font: titleLabel?.font ?? UIConstants.Label.font
    ]
    attributedString.addAttributes(attrs,
                                   range: NSRange(location: 0, length: attributedString.length))
    setAttributedTitle(attributedString, for: state)
  }
  
  func setupImage(_ image: UIImage) {
    self.setImage(image, for: .normal)
  }
}
private enum UIConstants {
  enum Label {
    static let font = UIFont.boldAppFont(of: 13)
    static let letterSpacing: CGFloat = 0.5
    static let lineHeight: CGFloat = 25
    static let color = UIColor.color(r: 0, g: 80, b: 47)
  }
  enum Image {
    static let edgeInsets = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 0)
  }
}
