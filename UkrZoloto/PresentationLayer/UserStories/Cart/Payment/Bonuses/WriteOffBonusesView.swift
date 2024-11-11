//
//  WriteOffBonusesView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 30.04.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

class WriteOffBonusesView: InitView {
  
  // MARK: - Public variables
  let textField = ImageTextField()
  let writeOffButton = BonusesButton()
  let cancelButton = UIButton()
  
  // MARK: - Private variables
  private let buttonsStackView = UIStackView()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTextField()
    configureButtonsStackView()
    configureWriteOffButton()
    configureCancelButton()
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
    textField.type = .bonuses
    textField.tintColor = UIConstants.TextField.placeholderTextColor
    textField.textColor = UIConstants.TextField.textColor
    textField.font = UIConstants.TextField.font
  }
  
  private func configureButtonsStackView() {
    addSubview(buttonsStackView)
    buttonsStackView.snp.makeConstraints { make in
      make.top.equalTo(textField.snp.bottom)
        .offset(UIConstants.ButtonsStackView.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.ButtonsStackView.insets)
      make.bottom.equalToSuperview()
        .inset(UIConstants.ButtonsStackView.bottom)
    }
    
    buttonsStackView.alignment = .center
    buttonsStackView.distribution = .equalSpacing
    buttonsStackView.spacing = UIConstants.ButtonsStackView.spacing
    buttonsStackView.axis = .vertical
  }
  
  private func configureWriteOffButton() {
    buttonsStackView.addArrangedSubview(writeOffButton)
    writeOffButton.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.WriteOffButton.height)
      make.width.equalToSuperview()
    }
  }
  
  private func configureCancelButton() {
    buttonsStackView.addArrangedSubview(cancelButton)
    cancelButton.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.CancelButton.height)
    }
    cancelButton.setTitleColor(UIConstants.CancelButton.textColor, for: .normal)
    cancelButton.titleLabel?.font = UIConstants.CancelButton.font
  }
  
  // MARK: - Interface
  func configureInitState(viewModel: WriteOffViewModel, currentText: String?) {
    textField.placeholder = viewModel.placeholder
    textField.text = currentText ?? ""
    textField.setImage(nil)
    textField.hideError()
    writeOffButton.setTitle(viewModel.writeOffButtonTitle, for: .normal)
    cancelButton.setTitle(viewModel.cancelButtonTitle, for: .normal)
    
    textField.isUserInteractionEnabled = true
    writeOffButton.isHidden = false
    cancelButton.isHidden = true
    
		if let bonusInfo = viewModel.bonusInfo, bonusInfo.bonus != "0" {
      configureAsResult(bonusInfo: bonusInfo)
    }
  }
    
  func configure(withBonuses: Bool) {
    textField.setImage(withBonuses ? UIConstants.TextField.amountIcon : nil)
  }
  
  private func configureAsResult(bonusInfo: BonusInfo) {
    textField.text = bonusInfo.bonus
    if bonusInfo.isWrittenOff {
      cancelButton.setTitle(bonusInfo.cancelTitle, for: .normal)
      cancelButton.snp.makeConstraints { make in
        make.leading.trailing.equalTo(textField)
      }
      textField.setImage(UIConstants.TextField.acceptedIcon)
      textField.isUserInteractionEnabled = false
      writeOffButton.isHidden = true
      cancelButton.isHidden = false
    }
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
    static let amountIcon = #imageLiteral(resourceName: "bonusesAmountIcon")

    static let placeholderTextColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.8)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.boldAppFont(of: 16)
    static let top: CGFloat = 10
    static let height: CGFloat = 48
    static let insets: CGFloat = 35
  }
  enum ButtonsStackView {
    static let top: CGFloat = 32
    static let insets: CGFloat = 16
    static let bottom: CGFloat = 24
    
    static let spacing: CGFloat = 24
  }
  enum WriteOffButton {
    static let height: CGFloat = 48
  }
  enum CancelButton {
    static let textColor = UIColor.color(r: 0, g: 80, b: 47)
    static let font = UIFont.semiBoldAppFont(of: 13)
    
    static let height: CGFloat = 24
  }
}
