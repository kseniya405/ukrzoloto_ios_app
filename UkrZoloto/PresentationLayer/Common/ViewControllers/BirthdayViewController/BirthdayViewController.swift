//
//  BirthdayViewController.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 14.03.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit
import PKHUD

protocol BirthdayViewControllerOutput: AnyObject {
  func didTapOnBack(from viewController: BirthdayViewController)
  func didSaveBirthday(from viewController: BirthdayViewController)
}

class BirthdayViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  weak var output: BirthdayViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = BirthdayView()
  
  // MARK: - Life cycle
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
    selfView.getBirthdayTextField().becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
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
    setupContinueButton()
    updateContinueButtonState()
  }
  
  private func setupNavigationBar() {
    addNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
  }
  
  private func setupSelfView() {
    selfView.setDatePickerDelegate(self)
  }
  
  private func updateNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
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
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func setupContinueButton() {
    selfView.addContinueButtonTarget(self,
                                     action: #selector(didTapOnContinue),
                                     for: .touchUpInside)
  }
  
  private func localizeLabels() {
    navigationItem.title = Localizator.standard.localizedString("Получить подарок")
    selfView.getBirthdayTextField().placeholder = Localizator.standard.localizedString("Укажите Вашу дату рождения")
    selfView.setDescriptionLabelText(Localizator.standard.localizedString("Скидка действует:\n- за 7 дней до дня рождения и 14 дней после.\n- при заказе в магазинах, на сайте и в приложении.\n- с другими скидками и оплатой бонусами."))
    selfView.setContinueButtonTitle(Localizator.standard.localizedString("Сохранить").uppercased())
    
  }
  
  override func localize() {
    localizeLabels()
  }
  
  // MARK: - Actions
  private func updateContinueButtonState() {
    selfView.setContinueButtonEnabled(!selfView.getBirthdayTextField().text.isNilOrEmpty)
  }
  
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func didTapOnContinue() {
    guard let date = DateFormattersFactory.dateOnlyFormatter().date(from: selfView.getBirthdayTextField().text ?? "") else {
      return
    }
    HUD.showProgress()
    let user = ProfileService.shared.user
    ProfileService.shared.updateUser(name: user?.name,
                                     surname: user?.surname,
                                     email: user?.email,
                                     birthday: date,
                                     gender: user?.gender) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success:
          self.output?.didSaveBirthday(from: self)
        }
      }
    }
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
    selfView.updateBottomConstraint(offset: offset, duration: duration)
  }
  
}

// MARK: - DatePickerBottomViewDelegate
extension BirthdayViewController: DatePickerBottomViewDelegate {
  func didDateWasChanged(to date: Date) {
    selfView.setDate(date)
    updateContinueButtonState()
  }
}
