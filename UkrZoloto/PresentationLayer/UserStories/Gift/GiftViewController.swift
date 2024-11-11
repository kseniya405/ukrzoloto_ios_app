//
//  GiftViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 10/1/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit
import BetterSegmentedControl
import PKHUD

protocol GiftViewControllerOutput: AnyObject {
  func didTapOnBack(from viewController: GiftViewController)
  func didSendGift(from viewController: GiftViewController)
}

private struct UserControllers {
  var nameController: ValidateController?
  var phoneController: PhoneNumberController?
  var emailController: EmailController?
}

class GiftViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {

  // MARK: - Public variables
  weak var output: GiftViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = GiftView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
  private var senderControllers = UserControllers()
  private var recipientControllers = UserControllers()
  
  private let product: Product
  
  // MARK: - Life cycle
  init(product: Product,
       shouldDisplayOnFullScreen: Bool) {
    self.product = product
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addObservers()
    transitionCoordinator?.animate(alongsideTransition: { _ in
      self.updateNavigationBarColor()
    })
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateNavigationBarColor()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeObservers()
  }
  
  deinit {
    removeObservers()
  }
  
  // MARK: - Setup
  override func initConfigure() {
    setupView()
    hideKeyboardWhenTappedAround()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
    localizeLabels()
    setupSenderControllers()
    setupDefaultControllerDelegates(in: senderControllers)
    setupRecipientControllers()
    setupDefaultControllerDelegates(in: recipientControllers)
    setupContinueButtons()
    updateContinueButtonState()
  }
  
  private func setupNavigationBar() {
    addNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
  }
  
  private func setupSelfView() {
    edgesForExtendedLayout = []
//    selfView.getSegmentedControl().delegate = self
    selfView.getSegmentedControl().addTarget(self,
                                             action: #selector(segmentedControlValueChanged(_:)),
                                             for: .valueChanged)
  }
  
  private func updateNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
  private func setupDefaultControllerDelegates(in controller: UserControllers) {
    controller.nameController?.delegate = self
    controller.phoneController?.delegate = self
    controller.phoneController?.setPhonePrefix("+380")
    controller.emailController?.delegate = self
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
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  private func setupSenderControllers() {
    senderControllers.nameController = ValidateController(textField: selfView.getSenderNameTextField(),
                                                          type: .name)
    senderControllers.phoneController = PhoneNumberController(textField: selfView.getSenderPhoneTextField())
    senderControllers.emailController = EmailController(textField: selfView.getSenderEmailTextField())
    setupDefaultControllerDelegates(in: senderControllers)
  }
  
  private func setupRecipientControllers() {
    recipientControllers.nameController = ValidateController(textField: selfView.getRecipientNameTextField(),
                                                             type: .name)
    recipientControllers.phoneController = PhoneNumberController(textField: selfView.getRecipientPhoneTextField())
    recipientControllers.emailController = EmailController(textField: selfView.getRecipientEmailTextField())
    setupDefaultControllerDelegates(in: recipientControllers)
  }
  
  private func setupContinueButtons() {
    selfView.addSenderContinueButtonTarget(self,
                                           action: #selector(continueFromSender),
                                           for: .touchUpInside)
    selfView.addRecipientContinueButtonTarget(self,
                                              action: #selector(continueFromRecipient),
                                              for: .touchUpInside)
  }
  
  func localizeLabels() {
    navigationItem.title = Localizator.standard.localizedString("Намекнуть о подарке")
    selfView.setTabTitles([Localizator.standard.localizedString("Кому"),
                           Localizator.standard.localizedString("От кого")])
    selfView.setRecipientContinueButtonTitle(Localizator.standard.localizedString("Продолжить").uppercased())
    selfView.setSenderContinueButtonTitle(Localizator.standard.localizedString("Отправить").uppercased())
    selfView.setRecipientPlaceholders(name: Localizator.standard.localizedString("Имя"),
                                      email: Localizator.standard.localizedString("E-mail"),
                                      phone: Localizator.standard.localizedString("Номер телефона"))
    selfView.setSenderPlaceholders(name: Localizator.standard.localizedString("Имя"),
                                   email: Localizator.standard.localizedString("E-mail"),
                                   phone: Localizator.standard.localizedString("Номер телефона"))
  }
  
  override func localize() {
    localizeLabels()
  }
  
  // MARK: - Actions
  private func updateContinueButtonState() {
    selfView.setRecipientContinueButtonEnabled(recipientIsFilled())
    selfView.setSenderContinueButtonEnabled(recipientIsFilled() && senderIsFilled())
  }
  
  private func recipientIsFilled() -> Bool {
    guard let nameController = recipientControllers.nameController,
      let emailController = recipientControllers.emailController,
      let phoneController = recipientControllers.phoneController else {
        return false
    }
    let nameIsFilled = nameController.getText() != nil
    let emailIsFilled = emailController.getEmail() != nil
    let phoneIsFilled = phoneController.getFormattedPhoneNumber() != nil
    
    return nameIsFilled && (emailIsFilled || phoneIsFilled)
  }
  
  private func senderIsFilled() -> Bool {
    guard let nameController = senderControllers.nameController,
      let emailController = senderControllers.emailController,
      let phoneController = senderControllers.phoneController else {
        return false
    }
    let nameIsFilled = nameController.getText() != nil
    let emailIsFilled = emailController.getEmail() != nil
    let phoneIsFilled = phoneController.getFormattedPhoneNumber() != nil
    
    return nameIsFilled && (emailIsFilled || phoneIsFilled)
  }
  
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }

  @objc
  private func segmentedControlValueChanged(_ sender: BetterSegmentedControl) {
    if sender.index == 0 {
      selfView.showRecipientView()
    } else {
      selfView.showSenderView()
    }
  }
  
  @objc
  private func continueFromSender() {
    guard recipientIsFilled(),
      senderIsFilled(),
      let senderName = senderControllers.nameController?.getText(),
      let recipientName = recipientControllers.nameController?.getText() else { return }
    let senderHasPhone = senderControllers.phoneController?.getFormattedPhoneNumber() != nil
    let recipientHasPhone = recipientControllers.phoneController?.getFormattedPhoneNumber() != nil
    let sender = GiftParticipant(name: senderName,
                                 email: senderControllers.emailController?.getEmail(),
                                 phone: senderHasPhone ? senderControllers.phoneController?.getRawPhoneNumber().digitsOnly() : nil)
    let recipient = GiftParticipant(name: recipientName,
                                    email: recipientControllers.emailController?.getEmail(),
                                    phone: recipientHasPhone ? recipientControllers.phoneController?.getRawPhoneNumber().digitsOnly() : nil)
    HUD.showProgress()
    ProfileService.shared.sendGift(sender: sender,
                                   recipient: recipient,
                                   product: product) { [weak self] result in
                                    DispatchQueue.main.async {
                                      HUD.hide()
                                      guard let self = self else { return }
                                      switch result {
                                      case .failure(let error):
                                        self.handleError(error)
                                      case .success:
                                        self.output?.didSendGift(from: self)
                                      }
                                    }
    }
  }
  
  @objc
  private func continueFromRecipient() {
    guard recipientIsFilled() else { return }
    selfView.showSenderView()
  }
  
  // MARK: - Keyboard
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
    selfView.updateBottomConstraint(
      offset: offset, duration: duration)
  }
  
}

// MARK: - ValidateControllerDelegate
extension GiftViewController: ValidateControllerDelegate {
  
  func didEndEditing(_ textField: UITextField) { }
  
  func textFieldWillReturn(_ textField: UITextField) { }
  
  func didTextFieldWasChanged(_ textField: UITextField?, with type: Validator.ValidatorType) {
    updateContinueButtonState()
  }
}

// MARK: - PhoneNumberControllerDelegate
extension GiftViewController: PhoneNumberControllerDelegate {
  func didChangePhone() {
    updateContinueButtonState()
  }
}


// MARK: - EmailControllerDelegate
extension GiftViewController: EmailControllerDelegate {
  func didChangeEmail() {
    updateContinueButtonState()
  }
}

//// MARK: - BetterSegmentedControlDelegate
//extension GiftViewController: BetterSegmentedControlDelegate {
//  func shouldSwitchTo(index: Int) -> Bool {
//    return index <= selfView.getSegmentedControl().index
//  }
//}
