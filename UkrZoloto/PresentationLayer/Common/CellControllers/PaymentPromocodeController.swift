//
//  PaymentPromocodeController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 20.11.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol PaymentPromocodeControllerDelegate: AnyObject {
  func didTapOnPromocodeButton(isWriteOffVisible: Bool, from controller: PaymentPromocodeController)
  func didTapOnCancelButton(from controller: PaymentPromocodeController)
  func didTapOnWriteOff(from controller: PaymentPromocodeController)
}

class PaymentPromocodeController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: (PaymentPromocodeControllerDelegate & UITextFieldDelegate)?
  
  var paymentPromocodeView: PaymentPromocodeView? {
    get { return view as? PaymentPromocodeView }
    set { view = newValue }
  }
  
  var promocodeViewModel: PaymentPromocodeViewModel? {
    didSet { didSetViewModel() }
  }
  
  // MARK: - Private variables
  private var errorTitle: String?
  private var currentText: String?
    
  // MARK: - Actions
  private func didSetViewModel() {
    guard let promocodeViewModel = promocodeViewModel, let paymentPromocodeView = paymentPromocodeView else {
      return
    }

    paymentPromocodeView.configureInitState(
      viewModel: promocodeViewModel,
      isWriteOffVisible: promocodeViewModel.isWriteOffVisible && promocodeViewModel.isActive,
      errorTitle: errorTitle,
      currentText: currentText)

    paymentPromocodeView.topButton.addTarget(self, action: #selector(didTapOnPromocodeButton), for: .touchUpInside)
    
    paymentPromocodeView.promocodeView.textField.delegate = delegate
    paymentPromocodeView.promocodeView.textField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
    paymentPromocodeView.promocodeView.cancelButton.addTarget(self, action: #selector(didTapOnCancelButton), for: .touchUpInside)
    paymentPromocodeView.promocodeView.writeOffButton.addTarget(self, action: #selector(didTapOnWriteOff), for: .touchUpInside)
    
    paymentPromocodeView.topButton.isEnabled = promocodeViewModel.isActive
    paymentPromocodeView.topButton.alpha = promocodeViewModel.isActive ? 1.0 : 0.5
    
    updateWriteOffView()
  }
  
  override func setupView() {
    super.setupView()
    didSetViewModel()
  }
  
  // MARK: - Interface
  func setTextFieldError(_ error: String) {
    paymentPromocodeView?.promocodeView.textField.setError(error)
    errorTitle = error
  }
  
  func clearTextField() {
    currentText = nil
    paymentPromocodeView?.promocodeView.textField.text = nil
  }

  // MARK: - Private methods
  private func updateWriteOffView() {
    guard let paymentPromocodeView = paymentPromocodeView else { return }
    guard let text = paymentPromocodeView.promocodeView.textField.text,
          !text.isEmpty else {
      paymentPromocodeView.promocodeView.writeOffButton.isEnabled = false
      paymentPromocodeView.promocodeView.textField.hideError()
      return
    }
    paymentPromocodeView.promocodeView.writeOffButton.isEnabled = true
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnPromocodeButton() {
    guard let viewModel = promocodeViewModel else { return }
    delegate?.didTapOnPromocodeButton(isWriteOffVisible: !viewModel.isWriteOffVisible, from: self)
  }
  
  @objc
  private func didTapOnWriteOff() {
    delegate?.didTapOnWriteOff(from: self)
  }
  
  @objc
  private func didTapOnCancelButton() {
    delegate?.didTapOnCancelButton(from: self)
    updateWriteOffView()
  }
  
  @objc
  private func didChangeTextField(_ textField: UITextField) {
    paymentPromocodeView?.promocodeView.textField.hideError()
    currentText = paymentPromocodeView?.promocodeView.textField.text
    errorTitle = nil
    updateWriteOffView()
  }
  
}
