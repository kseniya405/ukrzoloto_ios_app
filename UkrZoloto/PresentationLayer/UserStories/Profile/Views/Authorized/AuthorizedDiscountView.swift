//
//  AuthorizedDiscountView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 11/1/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol AuthorizedDiscountViewDelegate: AnyObject {
}

class AuthorizedDiscountView: InitView {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.backgroundColor = UIConstants.StackView.backgroundColor
    return stackView
  }()
  
  private let bonusesStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = UIConstants.StackView.spacing
    stackView.backgroundColor = UIConstants.StackView.backgroundColor
    return stackView
  }()
    
  private let button: UIButton = {
    let button = UIButton()
    button.backgroundColor = UIConstants.Button.backgroundColor
    button.setImage(UIConstants.Button.image, for: .normal)
    button.titleLabel?.textColor = UIConstants.Button.textColor
    button.titleLabel?.font = UIConstants.Button.font
    button.contentHorizontalAlignment = .left
    return button
  }()
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureStackView()
    configureBonusesStackView()
    configureButton()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configureStackView() {
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(UIConstants.StackView.top)
      make.leading.equalToSuperview().inset(UIConstants.StackView.leading)
      make.trailing.equalToSuperview().inset(UIConstants.StackView.trailing)
      make.height.equalTo(UIConstants.StackView.height)
    }
  }
  
  private func configureBonusesStackView() {
    addSubview(bonusesStackView)
    bonusesStackView.snp.makeConstraints { make in
      make.top.equalTo(stackView.snp.bottom).offset(UIConstants.BonusesView.top)
      make.leading.trailing.equalTo(stackView)
    }
  }

  private func configureButton() {
    addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(bonusesStackView.snp.bottom)
        .offset(UIConstants.Button.top)
      make.leading.equalTo(stackView)
      make.height.equalTo(UIConstants.Button.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.Button.bottom)
    }
  }
  
  // MARK: - Interface
  func setDiscounts(_ discountViewModels: [DiscountViewModel]) {
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    discountViewModels.forEach { viewModel in
      let view = DiscountPercentView()
      view.configure(viewModel)
      stackView.addArrangedSubview(view)
    }
  }
  
  func setBonuses(_ viewModels: [BonusesViewModel]) {
    bonusesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    viewModels.forEach { viewModel in
      let view = BonusesView()
      view.configure(viewModel)
      bonusesStackView.addArrangedSubview(view)
    }
  }
  
  func setButtonTitle(_ title: String) {
    button.setTitle(title, for: .normal)
    button.layoutIfNeeded()
  }
  
  func addTarget(_ target: Any, action: Selector) {
    button.addTarget(target, action: action, for: .touchUpInside)
  }
  
  func removeTarget(_ target: Any?, action: Selector?) {
    button.removeTarget(target, action: action, for: .touchUpInside)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
  }
  
  enum StackView {
    static let top: CGFloat = 20 * Constants.Screen.heightCoefficient
    static let height: CGFloat = 70
    static let leading: CGFloat = 24 * Constants.Screen.heightCoefficient
    static let trailing: CGFloat = 24 * Constants.Screen.heightCoefficient
    
    static let spacing: CGFloat = 12
    static let backgroundColor = UIColor.clear
  }
  
  enum BonusesView {
    static let top: CGFloat = 20 * Constants.Screen.heightCoefficient
  }
  
  enum Button {
    static let top: CGFloat = 20 * Constants.Screen.heightCoefficient
    static let height: CGFloat = 24
    static let imageInset: CGFloat = 6
    static let bottom: CGFloat = 18 * Constants.Screen.heightCoefficient
    
    static let image = #imageLiteral(resourceName: "infoAgreement")
    static let font = UIFont.regularAppFont(of: 13)
    static let textColor = UIColor.color(r: 255, g: 0, b: 0, a: 0.6)
    static let backgroundColor = UIColor.clear
  }
}
