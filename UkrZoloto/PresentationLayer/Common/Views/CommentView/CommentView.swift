//
//  CommentView.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 28.02.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

protocol TextViewHeightChangable {
  func changeTextViewHeight(lines: Int)
  func getTextViewNumberOfLines() -> Int
}

class CommentView: InitView, TextViewHeightChangable {
  
  // MARK: - Public variables
  let button = LeftImageButton()
  let textView = UITextView()
  let topPlaceholderLabel = UILabel()
  let bottomLineView = InitView()
  
  // MARK: - Private variables
  private let stackView = UIStackView()
  private let buttonContainerView = InitView()
  
  // MARK: - Life cycle
  
  override func initConfigure() {
    super.initConfigure()
    configureStackView()
    configureButtonContainerView()
    configureButton()
    configureTextView()
    configureTopPlaceholderLabel()
    configureBottomLineView()
  }
  
  private func configureStackView() {
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.right.bottom.equalToSuperview()
        .inset(UIConstants.StackView.insets)
    }
    stackView.distribution = .fillProportionally
    stackView.axis = .vertical
    stackView.spacing = UIConstants.StackView.spacing
  }
  
  private func configureButtonContainerView() {
    stackView.addArrangedSubview(buttonContainerView)
  }
  
  private func configureButton() {
    buttonContainerView.addSubview(button)
    button.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview()
      make.height.equalTo(UIConstants.Button.height)
      make.width.equalTo(UIConstants.Button.width)
    }
    button.setTitleColor(UIConstants.Button.textColor, for: .normal)
    button.setImage(UIConstants.Button.image, for: .normal)
  }
  
  private func configureTextView() {
    stackView.addArrangedSubview(textView)
    updateMessageTextViewMarkup(height: UIConstants.TextView.height)
    textView.font = UIConstants.TextView.font
    textView.textColor = UIConstants.TextView.textColor
    textView.backgroundColor = UIConstants.TextView.backgroundColor
    textView.textContainer.lineBreakMode = .byCharWrapping
    textView.textContainerInset = .zero
    textView.placeholderTextColor = UIConstants.PlaceholderLabel.textColor
  }
  
  private func configureTopPlaceholderLabel() {
    stackView.addSubview(topPlaceholderLabel)
    topPlaceholderLabel.snp.makeConstraints { make in
      make.top.equalTo(button.snp.bottom)
        .offset(UIConstants.PlaceholderLabel.top)
      make.leading.equalToSuperview()
    }
    topPlaceholderLabel.textColor = UIConstants.PlaceholderLabel.textColor
    topPlaceholderLabel.font = UIConstants.PlaceholderLabel.font
  }
  
  private func configureBottomLineView() {
    stackView.addSubview(bottomLineView)
    bottomLineView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalTo(textView)
      make.height.equalTo(UIConstants.BottomLineView.height)
    }
    bottomLineView.backgroundColor = UIConstants.BottomLineView.backgroundColor
  }
  
  // MARK: - TextViewHeightChangable
  
  func changeTextViewHeight(lines: Int) {
    var newHeight: CGFloat = 0
    if lines > 0 {
      newHeight = UIConstants.TextView.height * CGFloat(lines)
    } else {
      newHeight = UIConstants.TextView.height
    }
    updateMessageTextViewMarkup(height: newHeight)
  }
  
  func getTextViewNumberOfLines() -> Int {
    return textView.getNumberOfLines()
  }

  // MARK: - Message text view configuration
  
  private func updateMessageTextViewMarkup(height: CGFloat) {
    textView.snp.remakeConstraints { make in
      make.height.equalTo(height)
    }
  }
  
}

// MARK: - UI constants
private enum UIConstants {
  enum StackView {
    static let spacing: CGFloat = 40
    static let insets: CGFloat = 24
  }
  enum Button {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let image = #imageLiteral(resourceName: "addComment")
    
    static let height: CGFloat = 32
    static let width: CGFloat = 224
  }
  enum TextView {
    static let textColor = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.regularAppFont(of: 16)
    static let backgroundColor = UIColor.white
    
    static let height: CGFloat = 24
  }
  enum PlaceholderLabel {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.8)
    static let font = UIFont.regularAppFont(of: 13)

    static let top: CGFloat = 21
  }
  enum BottomLineView {
    static let backgroundColor = UIColor.color(r: 230, g: 230, b: 230)
    static let height: CGFloat = 1
  }
}
