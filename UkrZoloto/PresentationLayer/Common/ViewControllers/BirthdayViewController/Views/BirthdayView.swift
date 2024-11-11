//
//  BirthdayView.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 14.03.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class BirthdayView: RoundedContainerView {
  
  // MARK: - Private variables
  private let birthdayTextField = UnderlinedTextField()
  private let descriptionLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.DescriptionLabel.height
    label.config
      .font(UIConstants.DescriptionLabel.font)
      .textColor(UIConstants.DescriptionLabel.color)
      .numberOfLines(UIConstants.DescriptionLabel.numbersOfLines)
    return label
  }()
  private let continueButton = MainButton()
  
  private let datePicker = DatePickerBottomView(frame: UIConstants.DatePicker.frame)
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  private func configureSelf() {
    configureBirthdayTextField()
    configureDescriptionLabel()
    configureContinueButton()
  }
  
  private func configureBirthdayTextField() {
    addSubview(birthdayTextField)
    birthdayTextField.inputView = datePicker
    
    birthdayTextField.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.BirthdayTextField.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.BirthdayTextField.leading)
      make.height.equalTo(UIConstants.BirthdayTextField.height)
    }
  }
  
  private func configureDescriptionLabel() {
    addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(birthdayTextField.snp.bottom)
        .offset(UIConstants.DescriptionLabel.top)
      make.leading.trailing.equalTo(birthdayTextField)
    }
    descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
  }
  
  private func configureContinueButton() {
    addSubview(continueButton)
    continueButton.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom)
      make.leading.trailing.equalTo(descriptionLabel)
      make.height.equalTo(UIConstants.ContinueButton.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.ContinueButton.bottom)
    }
  }
  
  // MARK: - Interface
  func getBirthdayTextField() -> UITextField {
    return birthdayTextField
  }
  
  func setDescriptionLabelText(_ text: String) {
    descriptionLabel.text = text
  }
  
  func addContinueButtonTarget(_ target: Any?,
                               action: Selector,
                               for event: UIControl.Event) {
    continueButton.addTarget(target, action: action, for: event)
  }
  
  func setContinueButtonEnabled(_ isEnabled: Bool) {
    continueButton.isEnabled = isEnabled
  }
  
  func setContinueButtonTitle(_ title: String) {
    continueButton.setTitle(title, for: .normal)
  }
  
  func setDate(_ date: Date) {
    birthdayTextField.text = DateFormattersFactory.dateOnlyFormatter().string(from: date)
  }
  
  func setDatePickerDelegate(_ delegate: DatePickerBottomViewDelegate) {
    datePicker.delegate = delegate
  }
  
  func updateBottomConstraint(offset: CGFloat, duration: Double) {
    UIView.animate(withDuration: duration) { [weak self] in
      guard let self = self else { return }
      self.continueButton.snp.updateConstraints { make in
        make.bottom.equalToSuperview()
          .inset(UIConstants.ContinueButton.bottom + offset)
      }
    }
  }
}

private enum UIConstants {
  enum BirthdayTextField {
    static let top: CGFloat = 24
    static let leading: CGFloat = 24
    static let height: CGFloat = 52
  }
  
  enum DescriptionLabel {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 13)
    static let height: CGFloat = 18
    static let numbersOfLines = 0
    
    static let top: CGFloat = 28
  }
  
  enum ContinueButton {
    static let height: CGFloat = 52
    static let bottom: CGFloat = 25
  }
  
  enum DatePicker {
    static let height: CGFloat = 277
    static let frame = CGRect(x: 0, y: 0, width: Constants.Screen.screenWidth,
                              height: UIConstants.DatePicker.height)
  }
}
