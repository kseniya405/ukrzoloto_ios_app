//
//  RecipientDataViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/8/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol RecipientDataViewControllerOutput: AnyObject {
  func didSelectRecipient(_ recipient: Recipient?)
  func proceedToDelivery()
}

class RecipientDataViewController: LocalizableViewController {

  // MARK: - Public variables
  var output: RecipientDataViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = RecipientDataView()
  
  private var nameController: ValidateController?
  private var surnameController: ValidateController?
  private var phoneController: PhoneNumberController?
  private var emailController: ValidateController?
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = selfView
  }
  
  // MARK: - Setup
  override func initConfigure() {
    setupView()
  }
  
  private func setupView() {
    addObserver()
    setupControllers()
    setupSelfView()
    fillUserData()
    localizeLabels()
    updateContinueButtonState()
  }
  
  private func addObserver() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  private func setupControllers() {
    nameController = ValidateController(textField: selfView.getNameTextField(),
                                        type: .name)
    nameController?.delegate = self
    
    surnameController = ValidateController(textField: selfView.getSurnameTextField(),
                                           type: .surname)
    surnameController?.delegate = self
    
    phoneController = PhoneNumberController(textField: selfView.getPhoneTextField())
    phoneController?.delegate = self
    phoneController?.setPhonePrefix("+380")
    
    emailController = ValidateController(textField: selfView.getEmailTextField(),
                                         type: .email)
    emailController?.delegate = self
  }
  
  private func setupSelfView() {
    selfView.addContinueButtonTarget(self,
                                     action: #selector(continueOrder),
                                     for: .touchUpInside)
  }
  
  private func fillUserData() {
    guard let user = ProfileService.shared.user else { return }
    selfView.setName(user.name)
    selfView.setSurname(user.surname)
    selfView.setEmail(user.email)
    phoneController?.set(phoneNumber: user.phone)

    saveRecipient()
    if user.name.isNilOrEmpty {
      _ = selfView.getNameTextField().becomeFirstResponder()
    }
  }
  
  private func localizeLabels() {
    selfView.setTitle(Localizator.standard.localizedString("Данные получателя"))
    nameController?.setPlaceholder(Localizator.standard.localizedString("Имя"))
    surnameController?.setPlaceholder(Localizator.standard.localizedString("Фамилия"))
    phoneController?.setPlaceholder(Localizator.standard.localizedString("Номер телефона"))
    emailController?.setPlaceholder(Localizator.standard.localizedString("E-mail"))
    selfView.setButtonTitle(Localizator.standard.localizedString("Продолжить").uppercased())
  }
  
  override func localize() {
    localizeLabels()
  }
  
  private func validateFieldText(_ textField: UITextField) {
    switch textField {
    case selfView.getNameTextField():
      if let nameText = nameController?.getText(), !nameText.isEmpty {
        selfView.getNameTextField().hideError()
      } else {
        selfView.getNameTextField().setError(Localizator.standard.localizedString("Поле Имя должно быть заполнено"))
      }
    case selfView.getSurnameTextField():
      if let surnameText = surnameController?.getText(), !surnameText.isEmpty {
        selfView.getSurnameTextField().hideError()
      } else {
        selfView.getSurnameTextField().setError(Localizator.standard.localizedString("Поле Фамилия должно быть заполнено"))
      }
    case selfView.getPhoneTextField():
      if let phoneNumberText = phoneController?.getRawPhoneNumber(), phoneNumberText.count >= UIConstants.phoneNumberCharsCount {
        selfView.getPhoneTextField().hideError()
      } else {
        selfView.getPhoneTextField().setError(Localizator.standard.localizedString("Необходимо указать номер телефона"))
      }
    case selfView.getEmailTextField():
      if let emailText = emailController?.getText(), !emailText.isEmpty {
        selfView.getPhoneTextField().hideError()
      } else {
        selfView.getEmailTextField().setError(Localizator.standard.localizedString("Введен некорректный e-mail."))
      }
    default:
      return
    }
  }
  
  private func hideError(for textField: UITextField) {
    switch textField {
    case selfView.getNameTextField():
      selfView.getNameTextField().hideError()
    case selfView.getSurnameTextField():
      selfView.getSurnameTextField().hideError()
    case selfView.getPhoneTextField():
      selfView.getPhoneTextField().hideError()
    case selfView.getEmailTextField():
      selfView.getEmailTextField().hideError()
    default:
      return
    }
  }
  
  // MARK: - Actions
  
  private func updateContinueButtonState() {
    if let nameText = nameController?.getText(), !nameText.isEmpty,
      let surnameText = surnameController?.getText(), !surnameText.isEmpty,
      let emailText = emailController?.getText(), !emailText.isEmpty,
      phoneController?.getFormattedPhoneNumber() != nil {
      selfView.setButtonEnabled(true)
    } else {
      selfView.setButtonEnabled(false)
    }
  }
  
  @objc
  private func continueOrder() {
    saveRecipient()

    self.output?.proceedToDelivery()
  }

  private func saveRecipient() {
    guard let name = nameController?.getText(),
          let surname = surnameController?.getText(),
          let email = emailController?.getText(),
          let phone = phoneController?.getFormattedPhoneNumber(),
            phone.count == 16 else {

      self.output?.didSelectRecipient(nil)

      return
    }

    self.output?.didSelectRecipient(Recipient(name: name, surname: surname, email: email, phone: phone))
  }
  
  @objc private func keyboardWillShow(notification: NSNotification) {
    guard let kbSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    guard let kbDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
    animateToBottomOffset(kbSizeValue.cgRectValue.height,
                          duration: kbDuration.doubleValue)
  }
  
  @objc private func keyboardWillHide(notification: NSNotification) {
    animateToBottomOffset(0, duration: 0)
  }
  
  private func animateToBottomOffset(_ offset: CGFloat, duration: Double) {
    UIView.animate(withDuration: duration) { [weak self] in
      guard let self = self else { return }
      self.selfView.setTableBottomInset(offset)
    }
  }
}

// MARK: - ValidateControllerDelegate
extension RecipientDataViewController: ValidateControllerDelegate {
  func didTextFieldWasChanged(_ textField: UITextField?, with type: Validator.ValidatorType) {
    if let textField = textField {
      hideError(for: textField)
    }
    saveRecipient()
    updateContinueButtonState()
  }
  
  func textFieldWillReturn(_ textField: UITextField) {
    validateFieldText(textField)
    switch textField {
    case selfView.getNameTextField():
      _ = selfView.getSurnameTextField().becomeFirstResponder()
    case selfView.getSurnameTextField():
      _ = selfView.getPhoneTextField().becomeFirstResponder()
    case selfView.getPhoneTextField():
      _ = selfView.getEmailTextField().becomeFirstResponder()
    case selfView.getEmailTextField():
      if let emailText = emailController?.getText(), !emailText.isEmpty {
        _ = selfView.getEmailTextField().resignFirstResponder()
        continueOrder()
      }
    default:
      return
    }
  }
  
  func didEndEditing(_ textField: UITextField) {
    validateFieldText(textField)
  }
}

// MARK: - PhoneNumberControllerDelegate
extension RecipientDataViewController: PhoneNumberControllerDelegate {
  func didChangePhone() {
    hideError(for: selfView.getPhoneTextField())
    if phoneController?.getRawPhoneNumber().count ?? 0 >= UIConstants.phoneNumberCharsCount {
      phoneController?.delegate?.textFieldWillReturn(selfView.getPhoneTextField())
    }
    saveRecipient()
    updateContinueButtonState()
  }
}

// MARK: - UIConstants
private enum UIConstants {
  static let phoneNumberCharsCount = 13
}
