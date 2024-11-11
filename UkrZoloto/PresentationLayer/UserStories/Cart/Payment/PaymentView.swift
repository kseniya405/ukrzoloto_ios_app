//
//  PaymentView.swift
//  UkrZoloto
//
//  Created by Andrew on 8/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import ActiveLabel
import AUIKit

class PaymentView: ContentScrollView {
  
  // MARK: Public variables
  let paymentPromocodeView = PaymentPromocodeView()
  let paymentBonusesView = PaymentBonusesView()
  let promoBonusesView = PromoBonusesView()
  let paymentsLabel = LineHeightLabel()
  let commentView = CommentView()
  let priceBlockView = PriceBlockView()
  
  // MARK: - Private variables
  private let stackView = UIStackView()
  
  private let paymentsContainerView = InitView()
  private let paymentsStackView = UIStackView()
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureStackView()
    configurePaymentPromocodeView()
    configurePaymentBonusesView()
    configurePromoBonusesView()
    configurePaymentsContainerView()
    configurePaymentsLabel()
    configurePaymentsStackView()
    configureCommentView()
    configurePriceBlockView()
  }
  
  private func configureStackView() {
    addSubview(stackView)
    stackView.axis = .vertical
    stackView.spacing = UIConstants.StackView.interitemSpace
    stackView.distribution = .fillProportionally
    stackView.backgroundColor = UIConstants.StackView.backgroundColor
    
    stackView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.StackView.top)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func configurePaymentPromocodeView() {
    stackView.addArrangedSubview(paymentPromocodeView)
  }
  
  private func configurePaymentBonusesView() {
    stackView.addArrangedSubview(paymentBonusesView)
  }
  
  private func configurePromoBonusesView() {
    stackView.addArrangedSubview(promoBonusesView)
  }
  
  private func configurePaymentsContainerView() {
    stackView.addArrangedSubview(paymentsContainerView)
    paymentsContainerView.backgroundColor = .clear
  }
  
  private func configurePaymentsLabel() {
    paymentsContainerView.addSubview(paymentsLabel)
    paymentsLabel.lineHeight = UIConstants.PaymentsLabel.height
    paymentsLabel.font = UIConstants.PaymentsLabel.font
    paymentsLabel.textColor = UIConstants.PaymentsLabel.color
    paymentsLabel.numberOfLines = UIConstants.PaymentsLabel.numbersOfLines
    paymentsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    paymentsLabel.setContentHuggingPriority(.required, for: .vertical)
    
    paymentsLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.PaymentsLabel.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.PaymentsLabel.leading)
      make.centerX.equalToSuperview()
    }
  }
  
  private func configurePaymentsStackView() {
    
    paymentsStackView.axis = .vertical
    paymentsStackView.spacing = UIConstants.PaymentsStackView.interitemSpace
    paymentsStackView.distribution = .fillProportionally
    
    paymentsContainerView.addSubview(paymentsStackView)
    paymentsStackView.snp.makeConstraints { make in
      make.top.equalTo(paymentsLabel.snp.bottom)
        .offset(UIConstants.PaymentsStackView.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.PaymentsStackView.left)
      make.bottom.equalToSuperview()
        .inset(UIConstants.PaymentsStackView.bottom)
    }
  }
  
  private func configureCommentView() {
    stackView.addArrangedSubview(commentView)
  }
  
  private func configurePriceBlockView() {
    stackView.addArrangedSubview(priceBlockView)
  }
  
  // MARK: - Interface
  func createPaymentViews(forPayments payments: [PaymentMethod]) -> [DeliveryTypeView] {
    paymentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    let paymentViews = payments.map({ method -> DeliveryTypeView in
      
      if let _ = method as? FullPayment {
        return DeliveryTypeView()
      } else if let creditMethod = method as? InstallmentPaymentMethod {
        
        guard let bank = Bank(rawValue: creditMethod.providerCode) else {
					return InstallmentPaymentView()
        }
        
        switch bank {
        case .alpha:
          return AlphabankPaymentView()
          
        default:
          return InstallmentPaymentView()
        }
      }
      return DeliveryTypeView()
    })
    
    paymentViews.forEach { paymentsStackView.addArrangedSubview($0) }
    
    return paymentViews
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
  }
  enum StackView {
    static let backgroundColor = UIColor.white
    static let interitemSpace: CGFloat = 0
    
    static let top: CGFloat = 50
  }
  
  enum PaymentsLabel {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.boldAppFont(of: 22)
    static let height: CGFloat = 26.4
    static let numbersOfLines: Int = 0
    
    static let top: CGFloat = 6
    static let leading: CGFloat = 24
  }
  
  enum PaymentsStackView {
    static let interitemSpace: CGFloat = 24
    
    static let top: CGFloat = 20
    static let left: CGFloat = 24
    static let bottom: CGFloat = 56
  }
}
