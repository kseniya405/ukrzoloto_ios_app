//
//  PriceBlockView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 05.05.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import ActiveLabel
import AUIKit

protocol PriceBlockViewDelegate: AnyObject {
  func didTapOnPublicOffer(from view: PriceBlockView)
  func didTapOnTermsOfUse(from view: PriceBlockView)
}

class PriceBlockView: InitView {
  
  // MARK: - Public variables
  weak var delegate: PriceBlockViewDelegate?
  
  // MARK: - Private variables
  private let bottomView = UIView()
  private let priceView = DetailedPriceView()
  private let lineView = UIView()
  private let discountLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.DiscountLabel.font)
      .textColor(UIConstants.DiscountLabel.textColor)
      .numberOfLines(UIConstants.DiscountLabel.numberOfLines)
    label.lineHeight = UIConstants.DiscountLabel.lineHeight
    return label
  }()
  private let continueButton = MainButton()
  private let activeLabel: ActiveLabel = {
    let label = ActiveLabel()
    label.setLineHeight(UIConstants.ActiveLabel.lineHeight)
    label.config
      .font(UIConstants.ActiveLabel.font)
      .textColor(UIConstants.ActiveLabel.textColor)
      .numberOfLines(UIConstants.ActiveLabel.numberOfLines)
    return label
  }()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureBottomView()
    configurePriceView()
    configureLineView()
    configureDiscountLabel()
    configureContinueButton()
    configureActiveLabel()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    
  }
  
  private func configureBottomView() {
    bottomView.backgroundColor = UIConstants.BottomView.backgroundColor
    bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    bottomView.layer.cornerRadius = UIConstants.BottomView.cornerRadius
    addSubview(bottomView)
    bottomView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    bottomView.prepareForStackView()
  }
  
  private func configurePriceView() {
    bottomView.addSubview(priceView)
    priceView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }
  }
  
  private func configureLineView() {
    bottomView.addSubview(lineView)
    lineView.snp.makeConstraints { make in
      make.top.equalTo(priceView.snp.bottom)
        .offset(UIConstants.LineView.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(UIConstants.LineView.height)
    }
    lineView.backgroundColor = UIConstants.LineView.backgroundColor
  }
  
  private func configureDiscountLabel() {
    bottomView.addSubview(discountLabel)
    discountLabel.snp.makeConstraints { make in
      make.top.equalTo(lineView.snp.bottom)
        .offset(UIConstants.DiscountLabel.top)
      make.left.right.equalToSuperview()
        .inset(UIConstants.DiscountLabel.left)
    }
    discountLabel.isHidden = true
  }
  
  private func configureContinueButton() {
    continueButton.backgroundColor = UIConstants.ContinueButton.backgroundColor
    bottomView.addSubview(continueButton)
    continueButton.snp.makeConstraints { make in
      make.top.equalTo(lineView.snp.bottom)
        .offset(UIConstants.ContinueButton.top)
      make.left.right.equalToSuperview().inset(UIConstants.ContinueButton.left)
      make.height.equalTo(UIConstants.ContinueButton.height)
    }
  }
  
  private func configureActiveLabel() {
    bottomView.addSubview(activeLabel)
    activeLabel.snp.makeConstraints { make in
      make.top.equalTo(continueButton.snp.bottom).offset(UIConstants.ActiveLabel.top)
      make.left.right.equalToSuperview()
        .inset(UIConstants.ActiveLabel.left)
      make.bottom.equalToSuperview().inset(UIConstants.ActiveLabel.bottom)
    }
    activeLabel.setContentHuggingPriority(.required, for: .vertical)
    activeLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  // MARK: - Interface
  func setContinueTitle(_ title: String?) {
    continueButton.setTitle(title, for: .normal)
  }
  
  func setDiscount(_ text: String? = nil) {
    discountLabel.text = text
    discountLabel.isHidden = text == nil
    continueButton.snp.remakeConstraints { make in
      if text.isNilOrEmpty {
        make.top.equalTo(lineView.snp.bottom)
          .offset(UIConstants.ContinueButton.top)
      } else {
        make.top.equalTo(discountLabel.snp.bottom)
          .offset(UIConstants.ContinueButton.topFromDiscount)
      }
      make.left.right.equalToSuperview().inset(UIConstants.ContinueButton.left)
      make.height.equalTo(UIConstants.ContinueButton.height)
    }
  }
  
  func setAgreementText(_ text: String,
                        publicOfferText: String,
                        termsOfUseText: String) {
    activeLabel.text = text
    activeLabel.setLineHeight(UIConstants.ActiveLabel.lineHeight)
    
    activeLabel.customize { label in
      let offerType = ActiveType.custom(pattern: publicOfferText)
      label.customColor[offerType] = UIConstants.ActiveLabel.selectedTextColor
      label.customSelectedColor[offerType] = UIConstants.ActiveLabel.textColor
      label.handleCustomTap(for: offerType, handler: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.didTapOnPublicOffer(from: self)
      })
      let termsOfUseType = ActiveType.custom(pattern: termsOfUseText)
      label.customColor[termsOfUseType] = UIConstants.ActiveLabel.selectedTextColor
      label.customSelectedColor[termsOfUseType] = UIConstants.ActiveLabel.textColor
      label.handleCustomTap(for: termsOfUseType, handler: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.didTapOnTermsOfUse(from: self)
      })
      label.enabledTypes = [offerType, termsOfUseType]
    }
  }
  
  func setButtonEnabled(_ isEnabled: Bool) {
    continueButton.isEnabled = isEnabled
  }
  
  func setPrice(viewModel: PriceDetailsViewModel) {
    priceView.configure(with: viewModel)
    
    discountLabel.text = viewModel.bonusesDelayTitle
    discountLabel.isHidden = viewModel.bonusesDelayTitle == nil
    
    continueButton.snp.remakeConstraints { make in
      if viewModel.bonusesDelayTitle.isNilOrEmpty {
        make.top.equalTo(lineView.snp.bottom)
          .offset(UIConstants.ContinueButton.top)
      } else {
        make.top.equalTo(discountLabel.snp.bottom)
          .offset(UIConstants.ContinueButton.topFromDiscount)
      }
      make.left.right.equalToSuperview().inset(UIConstants.ContinueButton.left)
      make.height.equalTo(UIConstants.ContinueButton.height)
    }
  }
  
  func addContinueButtonTarget(_ target: Any?,
                               action: Selector,
                               for event: UIControl.Event) {
    continueButton.addTarget(target, action: action, for: event)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum BottomView {
    static let backgroundColor = UIColor.color(r: 246, g: 246, b: 246)
    static let cornerRadius: CGFloat = 16
  }
  enum LineView {
    static let backgroundColor = UIColor.color(r: 226, g: 226, b: 226)
    static let top: CGFloat = 15
    static let height: CGFloat = 1
  }
  enum DiscountLabel {
    static let textColor = UIColor.color(r: 0, g: 0, b: 0, a: 0.5)
    static let lineHeight: CGFloat = 15.6
    static let font = UIFont.regularAppFont(of: 12)
    static let numberOfLines: Int = 0
    
    static let top: CGFloat = 14
    static let left: CGFloat = 24
  }
  enum ContinueButton {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
    static let font = UIFont.boldAppFont(of: 15)
    
    static let top: CGFloat = 20
    static let topFromDiscount: CGFloat = 14
    static let left: CGFloat = 24
    static let height: CGFloat = 52
  }
  enum ActiveLabel {
    static let selectedTextColor = UIColor.color(r: 0, g: 80, b: 47)
    static let textColor = UIColor.color(r: 0, g: 0, b: 0, a: 0.5)
    static let lineHeight: CGFloat = 15.6
    static let font = UIFont.regularAppFont(of: 12)
    static let numberOfLines: Int = 0
    
    static let top: CGFloat = 12
    static let left: CGFloat = 24
    static let bottom: CGFloat = 40
  }
}
