//
//  SMSViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

protocol SMSViewControllerOutput: AnyObject {
  func didTapOnBack(from vc: SMSViewController)
  func smsWasConfirmed(from vc: SMSViewController)
}

private enum OTPState {
  case canResend
  case timer
  case progress(canResend: Bool)
  case error
}

class SMSViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  weak var output: SMSViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = SMSView()
  private let phoneNumber: String
  
  private var timer: Timer?
  private var remainingTime = Constants.Timer.defaultTime
  private var backgroundTask = UIBackgroundTaskIdentifier.invalid
  
  private var state: OTPState = .canResend {
    didSet {
      updateState()
    }
  }
  
  // MARK: - Life cycle
  init(phoneNumber: String,
       shouldDisplayOnFullScreen: Bool) {
    self.phoneNumber = phoneNumber
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addObservers()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let _ = selfView.getTextField().becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeObservers()
  }
  
  deinit {
    selfView.removeButtonTarget(nil, action: nil)
  }
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    setupView()
    localize()
    state = .timer
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
    setupTextField()
    scheduleTimer()
  }
  
  private func setupNavigationBar() {
    setNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
  }
  
  private func setupSelfView() {
    selfView.addButtonTarget(self, action: #selector(didTapOnNewCode))
  }
  
  private func setupTextField() {
    selfView.getTextField().keyboardType = .numberPad
    selfView.getTextField().delegate = self
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(notification:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func updateState() {
    switch state {
    case .canResend:
      selfView.isUserInteractionEnabled = true
      selfView.configure(withTimer: false)
    case .timer:
      selfView.isUserInteractionEnabled = true
      selfView.configure(withTimer: true)
      localize()
    case .progress(let canResend):
      selfView.isUserInteractionEnabled = false
      selfView.configure(withTimer: !canResend)
      localize()
    case .error:
      selfView.isUserInteractionEnabled = true
      selfView.setError(text: Localizator.standard.localizedString("Неверный код. Проверьте введенный код или повторите отправку СМС"))
    }
  }
  
  private func validateCode() {
    guard let codeString = selfView.getTextField().attributedText?.string,
          codeString.count == Constants.Timer.otpCodeLength else { return }
    switch state {
    case .canResend:
      state = .progress(canResend: true)
    case .timer:
      state = .progress(canResend: false)
    case .progress: break
    case .error: break
    }
    _ = selfView.getTextField().resignFirstResponder()
    HUD.showProgress()
    ProfileService.shared.authConfirm(code: codeString) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          self.handleOTPError(error)
        case .success:
          self.output?.smsWasConfirmed(from: self)
        }
        switch self.state {
        case .progress(true):
          self.state = .canResend
        case .progress(false):
          self.state = .timer
        default: break
        }
      }
      
    }
  }
  
  private func handleOTPError(_ error: Error) {
    if let serverError = error as? ServerError,
       (serverError.type == .smsLimit || serverError.type == .waitForNextSms) {
      handleError(error)
    } else {
      self.state = .error
    }
  }
  
  private func resendCode() {
    selfView.getTextField().resignFirstResponder()
    selfView.getTextField().attributedText = nil
    HUD.showProgress()
    ProfileService.shared.requestOTP(for: phoneNumber) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          print(error)
        case .success:
          self.scheduleTimer()
          self.state = .timer
        }
      }
    }
  }
  
  private func scheduleTimer(_ seconds: Int = Constants.Timer.defaultTime) {
    timer?.invalidate()
    remainingTime = seconds
    setTimeLeft(seconds: seconds)
    timer = Timer.scheduledTimer(
      timeInterval: 1,
      target: self,
      selector: #selector(self.timerHandler),
      userInfo: nil,
      repeats: true)
    backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
  }
  
  @objc private func timerHandler() {
    remainingTime -= 1
    if remainingTime <= 0 {
      timer?.invalidate()
      switch state {
      case .progress:
        state = .progress(canResend: true)
      case .timer:
        state = .canResend
      case .canResend: break
      case .error:
        state = .canResend
      }
      UIApplication.shared.endBackgroundTask(backgroundTask)
      backgroundTask = UIBackgroundTaskIdentifier.invalid
    } else {
      setTimeLeft(seconds: remainingTime)
    }
  }
  
  private func setTimeLeft(seconds: Int) {
    let text = Localizator.standard.localizedString("Новый код будет доступен через:")
    selfView.setTimerTitle(text + " " + StringComposer.shared.timeString(seconds: seconds))
  }
  
  // MARK: - Localization
  override func localize() {
    navigationItem.title = Localizator.standard.localizedString("Введите код из SMS")
    selfView.setDescribeTitle(Localizator.standard.localizedString("Введите 6-ти значный код из СМС, что мы выслали на") + " \(phoneNumber)")
    selfView.setTimerTitle(Localizator.standard.localizedString("Новый код будет доступен через:") + " " + StringComposer.shared.timeString(seconds: remainingTime))
    selfView.setButtonTitle(Localizator.standard.localizedString("Выслать новый код").uppercased())
    selfView.changeDescribeToDefault()
  }
  
  // MARK: - Actions
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
    selfView.updateBottomConstraint(offset: offset,
                                    duration: duration)
  }
  
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func didTapOnNewCode() {
    switch state {
    case .canResend, .progress(true), .error:
      resendCode()
    default: break
    }
  }
  
  @objc
  private func didTextFieldEdited() {
    guard let text = selfView.getTextField().attributedText,
          text.string.count > 1
    else { return }
    let attributedString = NSMutableAttributedString(string: text.string)
    attributedString.addAttribute(
      NSAttributedString.Key.kern,
      value: 30,
      range: NSMakeRange(0, text.string.count - 1))
    
    selfView.getTextField().attributedText = attributedString
  }
  
}

// MARK: - UITextFieldDelegate
extension SMSViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let userEnteredString = textField.attributedText?.string {
      let newString = (userEnteredString as NSString).replacingCharacters(in: range,
                                                                          with: string)
      if !newString.isEmpty && (Int(newString) == nil) {
        return false
      }
      if newString.count > Constants.Timer.otpCodeLength {
        return false
      }
      
      textField.attributedText = NSAttributedString(string: newString)
      didTextFieldEdited()
    }
    
    validateCode()
    return false
  }
}
