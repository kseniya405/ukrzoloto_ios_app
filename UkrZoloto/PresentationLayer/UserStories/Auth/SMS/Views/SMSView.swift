//
//  SMSView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class SMSView: RoundedContainerView {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  private let textField: UnderlinedTextField = {
    let textField = UnderlinedTextField()
    textField.textAlignment = .center
//    textField.setLetterSpacing(UIConstants.TextField.letterSpacing)
    return textField
  }()
  
  private let describeLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Describe.lineHeight
    label.config
      .textColor(UIConstants.Describe.textColor)
      .font(UIConstants.Describe.font)
      .numberOfLines(UIConstants.Describe.numberOfLines)
      .textAlignment(.center)
    return label
  }()
  
  private let timerLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Timer.lineHeight
    label.config
      .textColor(UIConstants.Timer.textColor)
      .font(UIConstants.Timer.font)
      .numberOfLines(UIConstants.Timer.numberOfLines)
      .textAlignment(.center)
    return label
  }()
  
  private let button = EmptyButton()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTextField()
    configureDescribe()
    configureButton()
    configureTimer()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTextField() {
    addSubview(textField)
    textField.snp.makeConstraints { make in
      make.top.equalToSuperview()
      .offset(UIConstants.TextField.top)
      make.leading.trailing.equalToSuperview()
      .inset(UIConstants.TextField.insets)
      make.height.equalTo(UIConstants.TextField.height)
    }
    textField.setUnderlineColor(UIConstants.TextField.lineColor)
  }
  
  private func configureDescribe() {
    addSubview(describeLabel)
    describeLabel.snp.makeConstraints { make in
      make.top.equalTo(textField.snp.bottom)
        .offset(UIConstants.Describe.top)
      make.leading.trailing.equalTo(textField)
    }
    describeLabel.textColor = UIConstants.Describe.textColor
    describeLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    describeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  private func configureButton() {
    addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(describeLabel.snp.bottom)
        .offset(UIConstants.Button.top)
      make.leading.trailing.equalTo(describeLabel)
      make.height.equalTo(UIConstants.Button.height)
      make.bottom.lessThanOrEqualToSuperview()
        .inset(UIConstants.Button.bottom)
    }
    button.layer.borderColor = UIColor.clear.cgColor
  }
  
  private func configureTimer() {
    addSubview(timerLabel)
    timerLabel.snp.makeConstraints { make in
      make.centerY.equalTo(button)
      make.leading.trailing.equalTo(button)
    }
  }
  
  // MARK: - Interface
  func getTextField() -> UITextField {
    return textField
  }
  
  func setDescribeTitle(_ title: String) {
    describeLabel.text = title
  }
  
  func setTimerTitle(_ title: String) {
    timerLabel.text = title
  }
  
  func setButtonTitle(_ title: String) {
    button.setTitle(title, for: .normal)
  }
  
  func addButtonTarget(_ target: Any, action: Selector) {
    button.addTarget(target, action: action, for: .touchUpInside)
  }
  
  func removeButtonTarget(_ target: Any?, action: Selector?) {
    button.removeTarget(target, action: action, for: .touchUpInside)
  }

  func configure(withTimer: Bool) {
    timerLabel.isHidden = !withTimer
    button.isHidden = withTimer
  }
  
  func setError(text: String) {
    describeLabel.textColor = UIConstants.Describe.errorTextColor
    
    describeLabel.text = text
  }
  
  func updateBottomConstraint(offset: CGFloat, duration: Double) {
    UIView.animate(withDuration: duration) { [weak self] in
      guard let self = self else { return }
      self.button.snp.updateConstraints({ make in
        make.bottom.lessThanOrEqualToSuperview()
          .inset(UIConstants.Button.bottom + offset)
      })
    }
  }
  
  func changeDescribeToDefault() {
    describeLabel.textColor = UIConstants.Describe.textColor
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
  }
  enum TextField {
    static let lineColor = UIColor.color(r: 62, g: 76, b: 75)
    static let letterSpacing: CGFloat = 30
    
    static let top: CGFloat = 40
    static let insets: CGFloat = 24
    static let height: CGFloat = 50
  }
  enum Describe {
    static let font = UIFont.regularAppFont(of: 13)
    static let lineHeight: CGFloat = 18
    static let textColor = UIColor.color(r: 4, g: 35, b: 32)
    static let errorTextColor = UIColor.color(r: 255, g: 95, b: 95)
    static let numberOfLines: Int = 0
    
    static let top: CGFloat = 40 * Constants.Screen.heightCoefficient
  }
  enum Button {
    static let borderColor = UIColor.white
    
    static let height: CGFloat = 52
    static let top: CGFloat = 12 * Constants.Screen.heightCoefficient
    static let bottom: CGFloat = 15
  }
  enum Timer {
    static let font = UIFont.regularAppFont(of: 13)
    static let lineHeight: CGFloat = 18
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let numberOfLines: Int = 0
  }
}
