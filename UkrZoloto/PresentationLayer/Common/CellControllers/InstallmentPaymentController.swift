//
//  InstallmentPaymentController.swift
//  UkrZoloto
//
//  Created by Andrew on 8/26/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol InstallmentPaymentControllerDelegate: AnyObject {
  func didSelect(installmentPaymentController: InstallmentPaymentController)
  func tappedOnMonths(installmentPaymentController: InstallmentPaymentController)
}

class InstallmentPaymentController: PaymentController {
  
  // MARK: - Public variables
  weak var delegate: InstallmentPaymentControllerDelegate?
  
  override var paymentMethodTitle: String {
    return paymentViewModel!.providerName
  }
  
  var paymentView: InstallmentPaymentView? {
    set { view = newValue }
    get { return view as? InstallmentPaymentView }
  }
  
  var paymentViewModel: InstallmentPaymentViewModel? {
    didSet { didSetViewModel() }
  }
  
  override var isSelected: Bool {
    return paymentViewModel?.isSelected ?? false
  }
  
  override func set(selected: Bool) {
    paymentViewModel?.isSelected = selected
  }
  
  func setPartsCount(_ parts: Int) {
    paymentViewModel?.selectedMonth = parts
  }
  
  func setTotalPrice(price: Currency) {
    paymentViewModel?.updateTotalPrice(price: price)
  }

  
  // MARK: - Actions
  private func didSetViewModel() {
    
    guard let viewModel = paymentViewModel else { return }
    
    paymentView?.isBottomViewHidden = viewModel.isSelected
    paymentView?.setRadioBoxState(viewModel.isSelected ? .active : .inactive)
    paymentView?.setTitle(viewModel.providerName)
    paymentView?.isBottomViewHidden = !viewModel.isSelected
    paymentView?.setDetails(text: viewModel.detailsText)
    paymentView?.setImage(ImageViewModel.image(viewModel.bankIcon))
    paymentView?.setMonthlyValue("\(viewModel.monthlyPayment!)")
    paymentView?.setPartsValue(viewModel.selectedMonth)
    paymentView?.setPartsAction(target: self, action: #selector(monthsTappedAction(_:)))
  }
  
  override func reload() {
    
    didSetViewModel()
  }
  
  override func setupView() {
    super.setupView()
    paymentView?.addRadioBoxTarget(self, action: #selector(radioBoxTapped))
    didSetViewModel()
  }
  
  override func unsetupView() {
    super.unsetupView()
    paymentView?.removeRadioBoxTarget()
  }
  
  @objc
  private func radioBoxTapped() {
    delegate?.didSelect(installmentPaymentController: self)
  }
  
  @objc private func monthsTappedAction(_ sender: UIGestureRecognizer) {
    delegate?.tappedOnMonths(installmentPaymentController: self)
  }
}

private enum UIConstants {
  static let textColor = UIColor.color(r: 63, g: 76, b: 75)
  static let placeholderTextColor = UIColor.color(r: 63, g: 76, b: 75, a: 0.8)
}

