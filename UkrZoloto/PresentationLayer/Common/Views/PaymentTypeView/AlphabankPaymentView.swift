//
//  AlphabankPaymentView.swift
//  UkrZoloto
//
//  Created by Mykola on 07.11.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

protocol AlphabankPaymentViewDelegate: AnyObject {
  func paymentViewDidEnteredCardNumbers(_ lastNumbersComponent: String)
}

class AlphabankPaymentView: InstallmentPaymentView {
  
  weak var delegate: AlphabankPaymentViewDelegate?
   
  private let partsTitleLabel: UILabel = {
    
    let label = UILabel()
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.textColor)
    
    label.text = Localizator.standard.localizedString("Количество платежей")
    return label
    
  }()
  
  private let paymentTitleLabel: UILabel = {
    
    let label = UILabel()
    
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.textColor)
  
    label.text = Localizator.standard.localizedString("Платёж")
    
    return label
  }()
  
  private let inputField: UITextField = {
    
    let textField = UITextField()
    textField.placeholder = "0000"
    textField.keyboardType = .numberPad
    textField.font = UIConstants.TitleLabel.font
    textField.textColor = UIConstants.TitleLabel.textColor
    
    return textField
  }()
  
  private let cardView: ShadowedView<UIView> = {
    
    let view = UIView()
    view.backgroundColor = .white
    
    return ShadowedView(view, cornerRadius: 22.0)
  }()
  
  override func initConfigure() {
    
    configureContainerView()
    configureTitleLabels()
    configureValueLabels() 
    configureCardView()
  }
  
  private func configureTitleLabels() {
  
    containerView.addSubview(detailsLabel)
    detailsLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.right.equalToSuperview()
    }
    detailsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    
    containerView.addSubview(paymentTitleLabel)
    paymentTitleLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview()
      make.top.equalTo(detailsLabel.snp.bottom).offset(15.0)
      make.width.equalTo(100.0)
    }
    
    containerView.addSubview(partsTitleLabel)
    partsTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(paymentTitleLabel.snp.top)
      make.leading.equalToSuperview()
      make.trailing.equalTo(paymentTitleLabel.snp.leading).offset(-10.0)
    }
    
    partsTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureValueLabels() {
    
    containerView.addSubview(monthlyValueLabel)
    monthlyValueLabel.snp.makeConstraints { make in
      make.leading.equalTo(paymentTitleLabel.snp.leading)
      make.trailing.equalTo(paymentTitleLabel.snp.trailing)
      make.top.equalTo(paymentTitleLabel.snp.bottom).offset(7.0)
    }
        
    let monthlyLine = UIView()
    monthlyLine.backgroundColor = UIColor(hex: "#E3E3E3")
    
    containerView.addSubview(monthlyLine)
    monthlyLine.snp.makeConstraints { make in
      make.leading.equalTo(paymentTitleLabel.snp.leading)
      make.trailing.equalTo(paymentTitleLabel.snp.trailing)
      make.top.equalTo(monthlyValueLabel.snp.bottom).offset(7.0)
      make.height.equalTo(1.0)
    }
    
    containerView.addSubview(partsView)
    partsView.snp.makeConstraints { make in
      make.leading.equalTo(partsTitleLabel.snp.leading)
      make.trailing.equalTo(partsTitleLabel.snp.trailing)
      make.top.equalTo(partsTitleLabel.snp.bottom).offset(7.0)
    }
  }
  
  private func configureCardView() {
    
    containerView.addSubview(cardView)
    cardView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().offset(-10.0)
      make.top.equalTo(partsView.snp.bottom).offset(15.0)
    }
  
    cardView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(15.0)
      make.top.equalToSuperview().offset(13.0)
      make.width.height.equalTo(36.0).priority(.required)
    }
    
    let label = UILabel()
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.textColor)
      .numberOfLines(0)
    
    label.text = Localizator.standard.localizedString("Введите последние 4 цифры вашей банковской карты")
    cardView.addSubview(label)
    
    label.snp.makeConstraints { make in
      make.leading.equalTo(imageView.snp.trailing).offset(15.0)
      make.top.equalToSuperview().offset(15.0)
      make.trailing.equalToSuperview().offset(-15.0)
    }
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10.0
    stackView.distribution = .fillProportionally
    
    cardView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(15.0)
      make.top.equalTo(imageView.snp.bottom).offset(26.0)
      make.trailing.greaterThanOrEqualToSuperview()
      make.height.equalTo(20.0)
    }
    
    for _ in 0..<3 {
      
      let label = UILabel()
      label.config
        .font(UIConstants.TitleLabel.font)
        .textColor(UIConstants.TitleLabel.textColor)
      label.text = "••••"
      
      stackView.addArrangedSubview(label)
      label.snp.makeConstraints { make in
        make.width.equalTo(30.0)
      }
    }
    
    inputField.delegate = self
    inputField.addTarget(self, action: #selector(onTextFieldChange(_:)), for: .editingChanged)
    
    stackView.addArrangedSubview(inputField)

    let line = UIView()
    line.backgroundColor = UIColor(hex: "#E6EDEC")
    cardView.addSubview(line)
    line.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(15.0)
      make.trailing.equalToSuperview().offset(-15.0)
      make.top.equalTo(stackView.snp.bottom).offset(7.0)
      make.height.equalTo(1).priority(.required)
      make.bottom.equalToSuperview().offset(-15.0)
    }
    line.setContentCompressionResistancePriority(.required, for: .vertical)

  }
  
  override func setMonthlyValue(_ title: String) {
    monthlyValueLabel.text = title + Localizator.standard.localizedString("₴/мес‎")
  }
}

extension AlphabankPaymentView: UITextFieldDelegate {
  
  @objc func onTextFieldChange(_ textField: UITextField) {
   
    guard let text = textField.text else {
      
      return
    }
    
    if text.count == 4 {
      textField.resignFirstResponder()
      
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard let text = textField.text else { return false }
    
    if string.containsOnlyNumbers {
      return true
    }
    
    // handled case when user continue editing filled textfield
    if text.count == 4 && string != "" {
      return false
    }
    
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    guard let text = textField.text,
          text.count >= 4,
          text.containsOnlyNumbers else {
            return
          }
    
    delegate?.paymentViewDidEnteredCardNumbers(text)
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    textField.text = ""
    return true
  }
}

private enum UIConstants {
  
  enum TitleLabel {
    static let font = UIFont.regularAppFont(of: 14)
    static let textColor = UIColor(named: "textDarkGreen")!
  }
  
  enum ValueLabel {
    static let font = UIFont.boldAppFont(of: 14.0)
    static let textColor = UIColor(named: "textDarkGreen")!
  }
}
