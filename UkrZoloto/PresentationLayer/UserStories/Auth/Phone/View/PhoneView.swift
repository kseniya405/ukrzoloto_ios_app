//
//  PhoneView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import ActiveLabel

protocol PhoneViewDelegate: AnyObject {
  func didTapOnActiveLabel(from view: PhoneView)
}

class PhoneView: RoundedContainerView {
  
  // MARK: - Public variables
  weak var delegate: PhoneViewDelegate?
  
  // MARK: - Private variables
  private let textField = UnderlinedTextField()
  private let smsButton = MainButton()
  private let activeLabel: ActiveLabel = {
    let label = ActiveLabel()
    label.setLineHeight(UIConstants.ActiveLabel.lineHeight)
    label.config
      .font(UIConstants.ActiveLabel.font)
      .textColor(UIConstants.ActiveLabel.textColor)
      .numberOfLines(UIConstants.ActiveLabel.numberOfLines)
    
    return label
  }()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTextField()
    configureButton()
    configureActiveLabel()
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
  
  private func configureButton() {
    addSubview(smsButton)
    smsButton.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(textField.snp.bottom)
        .offset(UIConstants.Button.top)
      make.height.equalTo(UIConstants.Button.height)
      make.leading.trailing.equalTo(textField)
    }
  }
  
  private func configureActiveLabel() {
    addSubview(activeLabel)
    activeLabel.snp.makeConstraints { make in
      make.top.equalTo(smsButton.snp.bottom)
        .offset(UIConstants.ActiveLabel.top)
      make.leading.trailing.equalTo(smsButton)
      make.bottom.equalToSuperview()
        .inset(UIConstants.ActiveLabel.bottom)
    }
  }
  
  // MARK: - Interface
  func getTextField() -> UITextField {
    return textField
  }
  
  func setPlaceholder(_ title: String) {
    textField.placeholder = title
  }
  
  func setButtonTitle(_ title: String) {
    smsButton.setTitle(title, for: .normal)
  }
  
  func setButtonState(isActive: Bool) {
    smsButton.isEnabled = isActive
  }
  
  func addTarget(_ target: Any, action: Selector) {
    smsButton.addTarget(target, action: action, for: .touchUpInside)
  }
  
  func removeTarget(_ target: Any?, action: Selector?) {
    smsButton.removeTarget(target, action: action, for: .touchUpInside)
  }
  
  func updateBottomConstraint(offset: CGFloat, duration: Double) {
    UIView.animate(withDuration: duration) { [weak self] in
      guard let self = self else { return }
      self.activeLabel.snp.updateConstraints({ make in
        make.bottom.equalToSuperview()
          .inset(offset + UIConstants.ActiveLabel.bottom)
      })
    }
  }
  
  func setActiveLabel(_ text: String, clickedText: String? = nil) {
    activeLabel.text = text
    activeLabel.setLineHeight(UIConstants.ActiveLabel.lineHeight)
    
    guard let clickedText = clickedText else { return }
    activeLabel.customize { label in
      let dataClickedType = ActiveType.custom(pattern: clickedText)
      label.customColor[dataClickedType] = UIConstants.ActiveLabel.selectedTextColor
      label.customSelectedColor[dataClickedType] = UIConstants.ActiveLabel.textColor
      label.handleCustomTap(for: dataClickedType, handler: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.didTapOnActiveLabel(from: self)
      })
      label.enabledTypes = [dataClickedType]
    }
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
  }
  enum TextField {
    static let lineColor = UIColor.color(r: 62, g: 76, b: 75)
    
    static let height: CGFloat = 53
    static let top: CGFloat = 33
    static let insets: CGFloat = 24
  }
  enum Button {
    static let height: CGFloat = 52
    static let top: CGFloat = 10
  }
  enum ActiveLabel {
    static let selectedTextColor = UIColor.color(r: 0, g: 80, b: 47)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let lineHeight: CGFloat = 18
    static let font = UIFont.regularAppFont(of: 13)
    static let numberOfLines: Int = 0
    
    static let top: CGFloat = 15
    static let bottom: CGFloat = 20
  }
}
