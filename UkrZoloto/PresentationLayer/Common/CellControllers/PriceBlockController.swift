//
//  PriceBlockController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 05.05.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol PriceBlockControllerDelegate: AnyObject {
  func didTapOnContinueOrder(from controller: PriceBlockController)
}

class PriceBlockController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: (PriceBlockControllerDelegate & PriceBlockViewDelegate)?
  
  var priceBlockView: PriceBlockView? {    
    get { return view as? PriceBlockView }
    set { view = newValue }
  }
  
  var priceDetailsViewModel: PriceDetailsViewModel? {
    didSet { didSetViewModel() }
  }
  
  // MARK: - Actions
  private func didSetViewModel() {
    guard let priceDetailsViewModel = priceDetailsViewModel,
      let priceBlockView = priceBlockView else {
        return
    }
    priceBlockView.setPrice(viewModel: priceDetailsViewModel)
    priceBlockView.addContinueButtonTarget(
      self, action: #selector(continueOrder), for: .touchUpInside)
    priceBlockView.delegate = delegate
    
    priceBlockView.setContinueTitle(Localizator.standard.localizedString("Оформить заказ").uppercased())
    let text = Localizator.standard.localizedString("Нажимая “Оформить заказ” Вы соглашаетесь с условиями Публичной оферты и Пользовательским соглашением")
    let publicOfferText = Localizator.standard.localizedString("Публичной оферты")
    let termsOfUseText = Localizator.standard.localizedString("Пользовательским соглашением")
    priceBlockView.setAgreementText(
      text, publicOfferText: publicOfferText, termsOfUseText: termsOfUseText)
  }
  
  override func setupView() {
    super.setupView()
    didSetViewModel()
  }
  
  // MARK: - Interface
  func updateContinueButtonState(isEnabled: Bool) {
    priceBlockView?.setButtonEnabled(isEnabled)
  }
  
  func setDiscount(_ text: String? = nil) {
    priceBlockView?.setDiscount(text)
  }
  
  // MARK: - Private methods
  @objc
  private func continueOrder() {
    delegate?.didTapOnContinueOrder(from: self)
  }
  
}
