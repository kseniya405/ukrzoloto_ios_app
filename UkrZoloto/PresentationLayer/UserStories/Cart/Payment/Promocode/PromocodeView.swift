//
//  PromocodeView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 20.11.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

class PromocodeView: InitView {
  
  // MARK: - Public variables
  let textField = ImageTextField()
  let writeOffButton = BonusesButton()
  let cancelButton = UIButton()
  let discountTitleLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.ResultTitle.font)
      .textColor(UIConstants.ResultTitle.textColor)
      .numberOfLines(UIConstants.ResultTitle.numberOfLines)
      .textAlignment(.left)
    return label
  }()
  let promocodeLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.Result.font)
      .textColor(UIConstants.Result.textColor)
      .numberOfLines(UIConstants.Result.numberOfLines)
      .textAlignment(.left)
    return label
  }()
  let cancelDescriptionLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.ResultTitle.font)
      .textColor(UIConstants.ResultTitle.textColor)
      .numberOfLines(UIConstants.ResultTitle.numberOfLines)
      .textAlignment(.left)
    return label
  }()
  
  // MARK: - Private variables
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTextField()
    configureWriteOffButton()
    configureResultTitleLabel()
    configureResultLabel()
    configureCancelDescriptionLabel()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    layer.cornerRadius = UIConstants.SelfView.cornerRadius
  }
  
  private func configureTextField() {
    addSubview(textField)
    textField.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.TextField.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.TextField.insets)
      make.height.equalTo(UIConstants.TextField.height)
    }
    textField.type = .promocode
    textField.tintColor = UIConstants.TextField.placeholderTextColor
    textField.textColor = UIConstants.TextField.textColor
    textField.font = UIConstants.TextField.font
    textField.errorNumberOfLines = 2
  }
  
  private func configureWriteOffButton() {
    addSubview(writeOffButton)
    writeOffButton.snp.makeConstraints { make in
      make.top.equalTo(textField.snp.bottom)
        .offset(UIConstants.WriteOffButton.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.WriteOffButton.insets)
      make.height.equalTo(UIConstants.WriteOffButton.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.CancelButton.bottom)
    }
  }
  
  private func configureResultTitleLabel() {
    addSubview(discountTitleLabel)
    discountTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(textField.snp.bottom)
        .offset(UIConstants.ResultTitle.top)
      make.leading.trailing.equalTo(textField)
    }
    discountTitleLabel.isHidden = true
    discountTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    discountTitleLabel.setContentHuggingPriority(.required, for: .vertical)
  }
  
  private func configureResultLabel() {
    addSubview(promocodeLabel)
    promocodeLabel.snp.makeConstraints { make in
      make.top.equalTo(discountTitleLabel.snp.bottom)
        .offset(UIConstants.Result.top)
      make.leading.trailing.equalTo(discountTitleLabel)
    }
    promocodeLabel.isHidden = true
    promocodeLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    promocodeLabel.setContentHuggingPriority(.required, for: .vertical)
  }
  
  private func configureCancelDescriptionLabel() {
    addSubview(cancelDescriptionLabel)
    cancelDescriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(promocodeLabel.snp.bottom)
        .offset(UIConstants.CancelDescriptionTitle.top)
      make.leading.trailing.equalTo(promocodeLabel)
    }
    cancelDescriptionLabel.isHidden = true
    cancelDescriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    cancelDescriptionLabel.setContentHuggingPriority(.required, for: .vertical)
  }
  
  private func configureCancelButton() {
    addSubview(cancelButton)
    cancelButton.snp.remakeConstraints { make in
      make.top.equalTo(cancelDescriptionLabel.snp.bottom)
        .offset(UIConstants.CancelButton.top)
        .priority(.required)
      make.centerX.equalToSuperview()
      make.width.equalTo(UIConstants.CancelButton.width)
      make.height.equalTo(UIConstants.CancelButton.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.CancelButton.bottom)
        .priority(.required)
    }
    cancelButton.setTitleColor(UIConstants.CancelButton.textColor, for: .normal)
    cancelButton.titleLabel?.font = UIConstants.CancelButton.font
  }
  
  // MARK: - Interface
  func configureInitState(viewModel: PaymentPromocodeViewModel, errorTitle: String?, currentText: String?) {
    textField.placeholder = viewModel.placeholder
    textField.text = currentText
    textField.setImage(nil)
    if let errorTitle = errorTitle {
      textField.setError(errorTitle)
    } else {
      textField.hideError()
    }
    writeOffButton.setTitle(viewModel.writeOffButtonTitle, for: .normal)
    cancelButton.setTitle(viewModel.cancelButtonTitle, for: .normal)
    
    writeOffButton.removeFromSuperview()
    cancelButton.removeFromSuperview()
    if let promocodeInfo = viewModel.promocodeInfo {
      configureCancelButton()
      configureAsResult(promocodeInfo: promocodeInfo, viewModel: viewModel)
    } else {
      configureWriteOffButton()
      configureWith(isResult: false)
    }
    layoutIfNeeded()
  }
  
  private func configureAsResult(promocodeInfo: PromocodeInfo, viewModel: PaymentPromocodeViewModel) {
    textField.text = promocodeInfo.promocode
    discountTitleLabel.text = viewModel.discountTitle
    promocodeLabel.text = promocodeInfo.promocodeDiscount
    if let statusBonusString = promocodeInfo.statusBonusString {
      cancelDescriptionLabel.text = statusBonusString
    } else {
      cancelDescriptionLabel.text = viewModel.cancelDescription
    }
    textField.setImage(UIConstants.TextField.acceptedIcon)
    configureWith(isResult: true)
  }
  
  private func configureWith(isResult: Bool) {
    textField.isUserInteractionEnabled = !isResult
    discountTitleLabel.isHidden = !isResult
    promocodeLabel.isHidden = !isResult
    cancelDescriptionLabel.isHidden = !isResult
    cancelButton.isHidden = !isResult
    writeOffButton.isHidden = isResult
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 246, g: 246, b: 246)
    static let cornerRadius: CGFloat = 16
  }
  enum TextField {
    static let acceptedIcon = #imageLiteral(resourceName: "greenAcceptedIcon")
    
    static let placeholderTextColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.8)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.boldAppFont(of: 16)
    static let top: CGFloat = 10
    static let height: CGFloat = 55
    static let insets: CGFloat  = 35
  }
  enum WriteOffButton {
    static let top: CGFloat = 45
    static let height: CGFloat = 48
    static let insets: CGFloat = 16
  }
  enum CancelButton {
    static let textColor = UIColor.color(r: 0, g: 80, b: 47)
    static let font = UIFont.semiBoldAppFont(of: 13)
    
    static let top: CGFloat = 24
    static let height: CGFloat = 24
    static let width: CGFloat = 150
    static let bottom: CGFloat = 24
  }
  enum ResultTitle {
    static let textColor = UIColor.black.withAlphaComponent(0.45)
    static let font = UIFont.regularAppFont(of: 13)
    static let numberOfLines: Int = 0
    
    static let top: CGFloat = 20
  }
  enum Result {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.boldAppFont(of: 24)
    static let numberOfLines: Int = 0
    
    static let top: CGFloat = 4
  }
  enum CancelDescriptionTitle {
    static let top: CGFloat = 8
  }
}

