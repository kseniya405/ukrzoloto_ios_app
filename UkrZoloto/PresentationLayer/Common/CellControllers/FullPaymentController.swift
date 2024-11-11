//
//  FullPaymentController.swift
//  UkrZoloto
//
//  Created by Andrew on 8/26/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol FullPaymentControllerDelegate: AnyObject {
  func didSelect(fullPaymentController: FullPaymentController)
}

class PaymentController: AUIDefaultViewController {
  
  var paymentMethodTitle: String {
    ""
  }
  
  var isSelected: Bool {
    return false
  }
  
  func reload() {
    
  }
  
  func set(selected: Bool) {
    
  }
}

class FullPaymentController: PaymentController {
  
  // MARK: - Public variables
  weak var delegate: FullPaymentControllerDelegate?
  
  override var paymentMethodTitle: String {
    return paymentViewModel!.title
  }
  
  var paymentView: DeliveryTypeView? {
    set { view = newValue }
    get { return view as? DeliveryTypeView }
  }

  var paymentViewModel: FullPaymentViewModel? {
    didSet { didSetViewModel() }
  }
  
  override var isSelected: Bool {
    return paymentViewModel?.isSelected ?? false
  }
  
  override func set(selected: Bool) {
    paymentViewModel?.isSelected = selected
  }
  
  // MARK: - Actions
  private func didSetViewModel() {
    guard let paymentViewModel = paymentViewModel else { return }
    paymentView?.setTitle(paymentViewModel.title)
    paymentView?.setSubtitle(paymentViewModel.hasAdditionalInfo ? Localizator.standard.localizedString("Возможна оплата Apple Pay") : nil)
    paymentView?.isBottomViewHidden = true
    if paymentViewModel.hasAdditionalInfo {
      paymentView?.showSubtitleLabel()
    } else {
      paymentView?.hideSubtitleLabel()
    }
    paymentView?.setRadioBoxState(paymentViewModel.isSelected ? .active : .inactive)
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
  
  override func reload() {
    didSetViewModel()
  }
  
  @objc
  private func radioBoxTapped() {
    delegate?.didSelect(fullPaymentController: self)
  }
}
