//
//  PaymentBonusesController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 04.05.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol PaymentBonusesControllerDelegate: AnyObject {
  func didTapOnBonusesButton(isWriteOffVisible: Bool, from controller: PaymentBonusesController)
  
  func didTapOnCancelButton(from controller: PaymentBonusesController)
  func didTapOnWriteOff(from controller: PaymentBonusesController)
}

class PaymentBonusesController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: (PaymentBonusesControllerDelegate & UITextFieldDelegate)?
  
  var paymentBonusesView: PaymentBonusesView? {
    set { view = newValue }
    get { return view as? PaymentBonusesView }
  }
  
  var bonusesViewModel: PaymentBonusesViewModel? {
    didSet { didSetViewModel() }
  }
  
  var isFreezed: Bool = false {
    didSet { setDisableBonusesView(isFreezedBonuses: isFreezed) }
  }
  
  // MARK: - Private variables
  private var currentText: String? = nil

  // MARK: - Actions
  private func didSetViewModel() {
    guard let bonusesViewModel = bonusesViewModel,
      let paymentBonusesView = paymentBonusesView else { return }
    paymentBonusesView.configureInitState(viewModel: bonusesViewModel,
                                          isWriteOffVisible: bonusesViewModel.isWriteOffVisible && !bonusesViewModel.isRestricted,
                                          currentText: currentText)
    
    paymentBonusesView.topButton.addTarget(
      self, action: #selector(didTapOnBonusesButton), for: .touchUpInside)
    isFreezed = bonusesViewModel.isFreezedBonuses
    
    let writeOffViewModel = bonusesViewModel.writeOffVM
    paymentBonusesView.writeOffView.configureInitState(viewModel: writeOffViewModel, currentText: currentText)
    paymentBonusesView.writeOffView.textField.delegate = delegate
    paymentBonusesView.writeOffView.textField.addTarget(
      self, action: #selector(didChangeBonusesTextField), for: .editingChanged)
    paymentBonusesView.writeOffView.cancelButton.addTarget(
      self, action: #selector(didTapOnCancelButton), for: .touchUpInside)
    paymentBonusesView.writeOffView.writeOffButton.addTarget(
      self, action: #selector(didTapOnWriteOff), for: .touchUpInside)
    
    if (paymentBonusesView.writeOffView.textField.text ?? "").isEmpty,
       let user = ProfileService.shared.user,
       user.bonuses > 0 {
      paymentBonusesView.writeOffView.textField.text = "\(min(bonusesViewModel.maxBonusesCount, user.bonuses))"
    }
    updateWriteOffBonusesView()
    
    setDisableBonusesView(isFreezedBonuses: bonusesViewModel.isFreezedBonuses)
  }
  
  override func setupView() {
    super.setupView()
    didSetViewModel()
  }
  
  override func unsetupView() {
    super.unsetupView()
  }
  
  func resetInputPriceIfNeeded() {
    guard let maxBonusesCount = bonusesViewModel?.maxBonusesCount else { return }
    if let insertedBonuses = Int(paymentBonusesView?.writeOffView.textField.text ?? ""),
       insertedBonuses > maxBonusesCount {
      paymentBonusesView?.writeOffView.textField.text = "\(maxBonusesCount)"
    }
  }

  // MARK: - Private methods
  @discardableResult
  private func updateWriteOffBonusesView() -> Bool {
    guard let writeOffView = paymentBonusesView?.writeOffView,
          let bonusesViewModel = bonusesViewModel else {
      return false
    }
    guard let text = writeOffView.textField.text,
      !text.isEmpty, let bonusesCount = Int(text),
      let user = ProfileService.shared.user,
      user.bonuses > 0 else {
        writeOffView.writeOffButton.isEnabled = false
        writeOffView.textField.hideError()
        writeOffView.configure(withBonuses: false)
        return false
    }
    writeOffView.configure(withBonuses: true)
    let maxAvailableBonuses = min(bonusesViewModel.maxBonusesCount, user.bonuses)
    let isValid = maxAvailableBonuses >= 1 && (1...maxAvailableBonuses).contains(bonusesCount) && !bonusesViewModel.isRestricted
    writeOffView.writeOffButton.isEnabled = isValid
    if isValid {
      writeOffView.textField.hideError()
    } else if bonusesCount > user.bonuses {
      writeOffView.textField.setError(Localizator.standard.localizedString("Указанная сумма превышает Ваш баланс"))
    } else if bonusesCount < 1 {
      writeOffView.textField.setError(Localizator.standard.localizedString("Указанная сумма должна быть больше 0 грн"))
    } else {
      writeOffView.textField.setError(Localizator.standard.localizedString("Указанная сумма превышает стоимость заказа"))
    }
    return isValid
  }
  
  @objc
  private func didTapOnBonusesButton() {
    guard ProfileService.shared.user != nil else { return }
    guard let viewModel = bonusesViewModel else { return }
    delegate?.didTapOnBonusesButton(isWriteOffVisible: !viewModel.isWriteOffVisible, from: self)
  }

  @objc
  private func didTapOnWriteOff() {
    delegate?.didTapOnWriteOff(from: self)
  }
  
  @objc
  private func didTapOnCancelButton() {
    delegate?.didTapOnCancelButton(from: self)
    updateWriteOffBonusesView()
  }
  
  @objc
  private func didChangeBonusesTextField(_ textField: UITextField) {
    currentText = textField.text
    updateWriteOffBonusesView()
  }
  
  private func setDisableBonusesView(isFreezedBonuses: Bool) {
    paymentBonusesView?.setDisableBonusesView(isDisable: isFreezedBonuses || bonusesViewModel?.isWriteOffActive == false)
  }
  
  
}
