//
//  FloatingTextField.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

private enum TextState {
  case text
  case placeholder
}

class FloatingTextField: UITextField {
  
  // MARK: - Public variables
  var errorNumberOfLines: Int = 1 {
    didSet {
      errorLabel.numberOfLines = errorNumberOfLines
    }
  }
  
  // MARK: - Private variables
  private let labelPlaceholder: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Placeholder.lineHeight
    return label
  }()
  
  private let errorLabel: UILabel = {
    let label = UILabel()
    label.config
      .textAlignment(.left)
      .font(.regularAppFont(of: 12))
      .textColor(UIConstants.Error.color)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentHuggingPriority(.required, for: .vertical)
    return label
  }()
  
  private let helperLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Helper.lineHeight
    label.config
      .textAlignment(.left)
      .font(UIConstants.Helper.font)
      .textColor(UIConstants.Helper.color)
      .numberOfLines(UIConstants.Helper.numberOfLines)
    return label
  }()
  
  private var defaultPlaceholderHeight: CGFloat = 1
  private let heightForTopPlaceholder: CGFloat = 15.0
  private let placeholderColor = UIConstants.Placeholder.color
  private let placeholderFont = UIConstants.Placeholder.font
  
  private let leftTextOffset: CGFloat = UIConstants.textInset
  private let rightTextOffset: CGFloat = UIConstants.textRightOffset
  private let leftPlaceholderOffset: CGFloat = UIConstants.textInset
  
  var showingError = false
  
  // MARK: - Set Text
  override var text: String? {
    didSet {
      updatePlaceholderLabel()
    }
  }
  
  var errorText: String? {
    didSet {
      errorLabel.text = errorText
      errorLabel.layoutIfNeeded()
      errorLabel.isHidden = errorText == nil
      showingError = errorText != nil
    }
  }
  
  var helperText: String? {
    didSet {
      helperLabel.text = helperText
      helperLabel.isHidden = helperText == nil
    }
  }
  
  override var placeholder: String? {
    get {
      return labelPlaceholder.text
    }
    set {
      labelPlaceholder.text = newValue
      labelPlaceholder.sizeToFit()
    }
  }
    
  // MARK: - UITextField Draw Method Override
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    updatePlaceholderLabel()
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + leftTextOffset,
                  y: bounds.origin.y + UIConstants.Placeholder.topInset,
                  width: bounds.width - leftTextOffset - rightTextOffset,
                  height: bounds.height)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + leftTextOffset,
                  y: bounds.origin.y + UIConstants.Placeholder.topInset,
                  width: bounds.width - leftTextOffset - rightTextOffset,
                  height: bounds.height)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + leftPlaceholderOffset,
                  y: bounds.origin.y,
                  width: bounds.width - leftPlaceholderOffset,
                  height: bounds.height)
  }
  
  override func caretRect(for position: UITextPosition) -> CGRect {
    let prevCaretRect = super.caretRect(for: position)
    return CGRect(x: Int(prevCaretRect.origin.x),
                  y: (Int(frame.size.height) - UIConstants.caretHeight) / 2,
                  width: 2,
                  height: UIConstants.caretHeight)
  }
  
  // MARK: - Loading From NIB
  override func awakeFromNib() {
    super.awakeFromNib()
    initConfigure()
  }
  
  // MARK: - Intialization
  override public init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfigure()
  }
  
  // MARK: - UITextfield Becomes First Responder
  override func becomeFirstResponder() -> Bool {
    let result = super.becomeFirstResponder()
    textFieldDidBeginEditing()
    return result
  }
  
  // MARK: - UITextfield Resigns Responder
  override func resignFirstResponder() -> Bool {
    let isResponder = isFirstResponder
    let result = super.resignFirstResponder()
    if isResponder && text.isNilOrEmpty {
      textFieldDidEndEditing()
    }
    return result
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
}

private extension FloatingTextField {
  // MARK: - Floating Initialzation.
  func initConfigure() {
    clipsToBounds = false
    backgroundColor = .clear
    textColor = UIConstants.Text.color
    tintColor = UIConstants.Text.color
    font = UIFont.boldAppFont(of: 16)
    addFloatingLabel()
    updatePlaceholderLabel()
    addErrorLabel()
    addHelperLabel()
  }
  
  // MARK: - Add Floating Label
  func addFloatingLabel() {
    labelPlaceholder.textAlignment = textAlignment
    labelPlaceholder.font = placeholderFont
    labelPlaceholder.textColor = placeholderColor
    super.placeholder = ""
    addSubview(labelPlaceholder)
    labelPlaceholder.frame = CGRect(x: UIConstants.textInset,
                                    y: (frame.size.height - labelPlaceholder.frame.size.height) / 2.0,
                                    width: bounds.width - leftPlaceholderOffset,
                                    height: labelPlaceholder.frame.size.height)
  }
  
  // MARK: - Add Hint Label
  private func addErrorLabel() {
    addSubview(errorLabel)
    errorLabel.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(self.snp.bottom).offset(4)
    }
    errorLabel.isHidden = true
  }
  
  private func addHelperLabel() {
    addSubview(helperLabel)
    helperLabel.snp.remakeConstraints { make in
      make.leading.trailing.top.equalTo(errorLabel)
    }
    helperLabel.isHidden = true
  }
  
  // MARK: - Float & Resign
  
  func updatePlaceholderAnimated() {
    UIView.animate(withDuration: 0.2, animations: { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.updatePlaceholderLabel()
    })
  }
  
  func updatePlaceholderLabel() {
    if needConfigureAsTitle() {
      configureAsTitle()
    } else {
      configureAsPlaceholder()
    }
  }
  
  // MARK: - Float UITextfield Placeholder Label
  
  private func needConfigureAsTitle() -> Bool {
    return !text.isNilOrEmpty || isFirstResponder
  }
  
  private func configureAsTitle() {
    let scale = CGFloat(0.76)
    labelPlaceholder.transform = CGAffineTransform(scaleX: scale, y: scale)
    labelPlaceholder.frame = CGRect(origin: CGPoint(x: leftPlaceholderOffset, y: UIConstants.Placeholder.topInset),
                                    size: labelPlaceholder.frame.size)
  }
  
  private func configureAsPlaceholder() {
    labelPlaceholder.transform = CGAffineTransform(scaleX: 1, y: 1)
    let rect = caretRect(for: self.beginningOfDocument)
    labelPlaceholder.frame = CGRect(x: leftPlaceholderOffset,
                                    y: rect.midY,
                                    width: labelPlaceholder.frame.size.width,
                                    height: labelPlaceholder.frame.size.height)
  }

  // MARK: - Resign the Placeholder
  func resignPlaceholder() {
    updatePlaceholderAnimated()
  }
  
  // MARK: - UITextField Begin Editing
  func textFieldDidBeginEditing() {
    updatePlaceholderAnimated()
  }
  
  // MARK: - UITextField Begin Editing
  func textFieldDidEndEditing() {
    updatePlaceholderAnimated()
  }
  
}

private enum UIConstants {
  static let textInset: CGFloat = 0
  static let caretHeight = 18
  static let textRightOffset: CGFloat = 17.0
  
  enum Placeholder {
    static let topInset: CGFloat = 8
    static let font = UIFont.semiBoldAppFont(of: 16)
    static let lineHeight: CGFloat = 18
    static let color = UIColor.black.withAlphaComponent(0.45)
    static let scale: CGFloat = 0.76
  }
  
  enum Text {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
  }
  
  enum Error {
    static let color = UIColor.color(r: 255, g: 95, b: 95)
  }
  
  enum Helper {
    static let color = UIColor.color(r: 0, g: 0, b: 0, a: 0.45)
    static let font = UIFont.regularAppFont(of: 12)
    static let lineHeight: CGFloat = 18
    static let numberOfLines = 0
  }
}
