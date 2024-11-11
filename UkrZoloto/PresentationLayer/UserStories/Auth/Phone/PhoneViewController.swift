//
//  PhoneViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

protocol PhoneViewControllerOutput: AnyObject {
  func didTapOnClose(from vc: PhoneViewController)
  func didSMSWasSent(phoneNumber: String, from vc: PhoneViewController)
  func didTapOnPrivacyLink(from vc: PhoneViewController)
}

class PhoneViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: PhoneViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = PhoneView()
  private var phoneNumberController: PhoneNumberController?
  
  // MARK: - Life cycle
  override func loadView() {
    view = selfView
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    setupView()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
    setupTextField()
    setupPhoneNumberController()
    updateButtonState()
    localize()
  }
  
  private func setupNavigationBar() {
    setNavigationButton(#selector(didTapOnClose),
                        button: ButtonsFactory.closeButtonForNavigationItem(),
                        side: .left)
  }
  
  private func setupSelfView() {
    selfView.delegate = self
    selfView.addTarget(self, action: #selector(didTapOnSMS))
    addObservers()
  }
  
  private func setupTextField() {
    selfView.getTextField().keyboardType = .phonePad
    selfView.getTextField().text = "+380"
    let _ = selfView.getTextField().becomeFirstResponder()
  }
  
  private func setupPhoneNumberController() {
    phoneNumberController = PhoneNumberController(textField: selfView.getTextField())
    phoneNumberController?.delegate = self
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil
    )
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  private func updateButtonState() {
    selfView.setButtonState(isActive: phoneNumberController?.getFormattedPhoneNumber() != nil)
  }
  
  // MARK: - Localization
  override func localize() {
    navigationItem.title = Localizator.standard.localizedString("Вход или регистрация")
    selfView.setActiveLabel(
      Localizator.standard.localizedString("Авторизируясь или регистрируясь Вы соглашаетесь с Пользовательским соглашением"),
      clickedText: Localizator.standard.localizedString("Пользовательским соглашением"))
    selfView.setButtonTitle(Localizator.standard.localizedString("Получить код в SMS").uppercased())
    selfView.setPlaceholder(Localizator.standard.localizedString("Номер телефона"))
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnSMS() {
    guard let number = phoneNumberController?.getRawPhoneNumber() else { return }
    let formattedNumber = phoneNumberController?.getFormattedPhoneNumber()
    HUD.showProgress()
    ProfileService.shared.requestOTP(for: number) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        HUD.hide()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success:
          self.output?.didSMSWasSent(phoneNumber: formattedNumber ?? number,
                                     from: self)
        }
      }
    }
  }
  
  @objc
  private func didTapOnClose() {
    output?.didTapOnClose(from: self)
  }
  
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    guard let kbSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    guard let kbDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
    animateToBottomOffset(kbSizeValue.cgRectValue.height,
                          duration: kbDuration.doubleValue)
  }
  
  @objc
  private func keyboardWillHide(notification: NSNotification) {
    animateToBottomOffset(0, duration: 0)
  }
  
  private func animateToBottomOffset(_ offset: CGFloat, duration: Double) {
    selfView.updateBottomConstraint(offset: offset,
                                    duration: duration)
  }
  
}

// MARK: - PhoneViewDelegate
extension PhoneViewController: PhoneViewDelegate {
  func didTapOnActiveLabel(from view: PhoneView) {
    output?.didTapOnPrivacyLink(from: self)
  }
  
}

// MARK: - PhoneNumberControllerDelegate
extension PhoneViewController: PhoneNumberControllerDelegate {
  func didEndEditing(_ textField: UITextField) { }
  
  func textFieldWillReturn(_ textField: UITextField) { }
  
  func didChangePhone() {
    updateButtonState()
  }
  
}
