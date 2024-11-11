//
//  UserTypeViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 10/28/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

protocol UserTypeViewControllerOutput: AnyObject {
  func didSMSWasSent(phoneNumber: String, from vc: UserTypeViewController)
  func didTapOnPrivacyLink(from vc: UserTypeViewController)
  func didTapOnBack(from viewController: UserTypeViewController)
}

class UserTypeViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: UserTypeViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = UserTypeView()
  private var phoneNumberController: PhoneNumberController?
  
  // MARK: - Life cycle
  override func loadView() {
    view = selfView
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Setup
  override func initConfigure() {
    setupView()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
    setupTextField()
    setupPhoneNumberController()
    updateButtonState()
    localizeLabels()
  }
  
  private func setupNavigationBar() {
    addNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
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
  }
  
  private func setupPhoneNumberController() {
    phoneNumberController = PhoneNumberController(textField: selfView.getTextField())
    phoneNumberController?.delegate = self
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(notification:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }
  
  private func updateButtonState() {
    selfView.setButtonState(isActive: phoneNumberController?.getFormattedPhoneNumber() != nil)
  }
  
  private func localizeLabels() {
    navigationItem.title = Localizator.standard.localizedString("Оформление заказа")
    let title = Localizator.standard.localizedString("Вы не авторизированы")
    let subtitle = Localizator.standard.localizedString("Зарегистрируйся или войди и получи 3%% скидки, а также возможность накапливать бонусные гривны")
    selfView.setImage(#imageLiteral(resourceName: "userType"))
    selfView.setTitle(title)
    selfView.setSubtitle(subtitle)
    selfView.setActiveLabel(
      Localizator.standard.localizedString("Авторизируясь или регистрируясь Вы соглашаетесь с Пользовательским соглашением"),
      clickedText: Localizator.standard.localizedString("Пользовательским соглашением"))
    selfView.setButtonTitle(Localizator.standard.localizedString("Получить код в SMS").uppercased())
    selfView.setPlaceholder(Localizator.standard.localizedString("Номер телефона"))
  }
  
  override func localize() {
    localizeLabels()
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
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
extension UserTypeViewController: UserTypeViewDelegate {
  func didTapOnActiveLabel(from view: UserTypeView) {
    output?.didTapOnPrivacyLink(from: self)
  }
  
}

// MARK: - PhoneNumberControllerDelegate
extension UserTypeViewController: PhoneNumberControllerDelegate {
  func didEndEditing(_ textField: UITextField) { }

  func textFieldWillReturn(_ textField: UITextField) { }

  func didChangePhone() {
    updateButtonState()
  }

}
