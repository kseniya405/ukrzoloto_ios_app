//
//  RecipientDataView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/8/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class RecipientDataView: InitView {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.TitleLabel.height
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.color)
      .numberOfLines(UIConstants.TitleLabel.numbersOfLines)
    return label
  }()
  
  private let nameTextField = UnderlinedTextField()
  private let surnameTextField = UnderlinedTextField()
  private let phoneTextField = UnderlinedTextField()
  private let emailTextField = UnderlinedTextField()
  
  private let continueButton = MainButton()
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureScrollView()
    configureContentView()
    configureTitleLabel()
    configureNameTextField()
    configureSurnameTextField()
    configurePhoneTextField()
    configureEmailTextField()
    configureContinueButton()
  }
  
  private func configureScrollView() {
    addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    scrollView.contentInsetAdjustmentBehavior = .never
  }
  
  private func configureContentView() {
    scrollView.addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
    contentView.backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTitleLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .inset(UIConstants.TitleLabel.top)
      make.leading.equalToSuperview()
        .inset(UIConstants.TitleLabel.leading)
      make.centerX.equalToSuperview()
    }
  }
  
  private func configureNameTextField() {
    contentView.addSubview(nameTextField)
    nameTextField.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.NameTextField.top)
      make.leading.trailing.equalTo(titleLabel)
      make.height.equalTo(UIConstants.NameTextField.height)
    }
    nameTextField.returnKeyType = .done
  }
  
  private func configureSurnameTextField() {
    surnameTextField.autocapitalizationType = .words
    contentView.addSubview(surnameTextField)
    surnameTextField.snp.makeConstraints { make in
      make.top.equalTo(nameTextField.snp.bottom)
        .offset(UIConstants.SurnameTextField.top)
      make.leading.trailing.equalTo(titleLabel)
      make.height.equalTo(UIConstants.SurnameTextField.height)
    }
    surnameTextField.returnKeyType = .done
  }
  
  private func configurePhoneTextField() {
    phoneTextField.keyboardType = ProfileService.shared.user == nil ? .numberPad : .default
    contentView.addSubview(phoneTextField)
    phoneTextField.snp.makeConstraints { make in
      make.top.equalTo(surnameTextField.snp.bottom)
        .offset(UIConstants.PhoneTextField.top)
      make.leading.trailing.equalTo(titleLabel)
      make.height.equalTo(UIConstants.PhoneTextField.height)
    }
    phoneTextField.returnKeyType = .done
  }
  
  private func configureEmailTextField() {
    emailTextField.keyboardType = .emailAddress
    contentView.addSubview(emailTextField)
    emailTextField.snp.makeConstraints { make in
      make.top.equalTo(phoneTextField.snp.bottom)
        .offset(UIConstants.EmailTextField.top)
      make.leading.trailing.equalTo(titleLabel)
      make.height.equalTo(UIConstants.EmailTextField.height)
    }
    emailTextField.returnKeyType = .done
  }
  
  private func configureContinueButton() {
    contentView.addSubview(continueButton)
    continueButton.snp.makeConstraints { make in
      make.top.equalTo(emailTextField.snp.bottom)
        .offset(UIConstants.ContinueButton.top)
      make.leading.trailing.equalTo(titleLabel)
      make.height.equalTo(UIConstants.ContinueButton.height)
      make.bottom.lessThanOrEqualToSuperview()
        .inset(UIConstants.ContinueButton.bottom)
    }
  }
  
  // MARK: - Interface
  
  func setTitle(_ title: String) {
    titleLabel.text = title
  }
  
  func setButtonTitle(_ title: String) {
    continueButton.setTitle(title, for: .normal)
  }
  
  func setButtonEnabled(_ isEnabled: Bool) {
    continueButton.isEnabled = isEnabled
  }
  
  func setTableBottomInset(_ inset: CGFloat) {
    scrollView.contentInset.bottom = inset
  }
  
  func setName(_ name: String?) {
    nameTextField.text = name
  }
  
  func setSurname(_ surname: String?) {
    surnameTextField.text = surname
  }
  
  func setEmail(_ email: String?) {
    emailTextField.text = email
  }
  
  func getNameTextField() -> UnderlinedTextField {
    return nameTextField
  }
  
  func getSurnameTextField() -> UnderlinedTextField {
    return surnameTextField
  }
  
  func getPhoneTextField() -> UnderlinedTextField {
    return phoneTextField
  }
  
  func getEmailTextField() -> UnderlinedTextField {
    return emailTextField
  }
  
  func addContinueButtonTarget(_ target: Any?,
                               action: Selector,
                               for event: UIControl.Event) {
    continueButton.addTarget(target, action: action, for: event)
  }
  
  // MARK: - Private methods
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
  }
  
  enum TitleLabel {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.boldAppFont(of: 22)
    static let height: CGFloat = 26.4
    static let numbersOfLines: Int = 0
    
    static let top: CGFloat = 32
    static let leading: CGFloat = 24
  }
  
  enum NameTextField {
    static let top: CGFloat = 20
    static let height: CGFloat = 52
  }
  
  enum SurnameTextField {
    static let top: CGFloat = 20
    static let height: CGFloat = 52
  }
  
  enum PhoneTextField {
    static let top: CGFloat = 20
    static let height: CGFloat = 52
  }
  
  enum EmailTextField {
    static let top: CGFloat = 20
    static let height: CGFloat = 52
  }
  
  enum ContinueButton {
    static let top: CGFloat = 60
    static let height: CGFloat = 52
    static let bottom: CGFloat = 10
  }
}
