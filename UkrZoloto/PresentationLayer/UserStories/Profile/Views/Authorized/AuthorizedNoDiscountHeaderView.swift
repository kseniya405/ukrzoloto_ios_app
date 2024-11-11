//
//  AuthorizedNoDiscountView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 10/28/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class AuthorizedNoDiscountView: InitView {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
//  private let bonusesView = BonusesView()
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
//    configureBonusesView()
    configureBonusesStackView()
    configureButton()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configureBonusesStackView() {
    addSubview(bonusesStackView)
    bonusesStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(UIConstants.StackView.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.StackView.insets)
    }
  }

  private func configureButton() {
    addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(bonusesStackView.snp.bottom)
        .offset(UIConstants.Button.top)
      make.leading.trailing.equalTo(bonusesStackView)
      make.height.equalTo(UIConstants.Button.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.Button.bottom)
    }
  }
  
  // MARK: - Interface
  func setBonusesViewModel(_ viewModels: [BonusesViewModel]) {
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
    static let insets: CGFloat = 24
    
    static let spacing: CGFloat = 12
    static let backgroundColor = UIColor.clear
  }
  
  enum BonusesView {
    static let insets: CGFloat = 24
    static let top: CGFloat = 20 * Constants.Screen.heightCoefficient
  }
  
  enum Button {
    static let top: CGFloat = 25 * Constants.Screen.heightCoefficient
    static let height: CGFloat = 24
    static let imageInset: CGFloat = 6
    static let bottom: CGFloat = 38 * Constants.Screen.heightCoefficient
    
    static let image = #imageLiteral(resourceName: "infoAgreement")
    static let font = UIFont.regularAppFont(of: 13)
    static let textColor = UIColor.color(r: 255, g: 0, b: 0, a: 0.6)
    static let backgroundColor = UIColor.clear
  }
  
  enum ZeroPercentImageView {
    static let image = #imageLiteral(resourceName: "zeroPercent")
    static let backgroundColor = UIColor.clear
    
    static let height: CGFloat = 70 * Constants.Screen.heightCoefficient
    static let width: CGFloat = 80 * Constants.Screen.heightCoefficient
    static let bottom: CGFloat = 38 * Constants.Screen.heightCoefficient
    static let right: CGFloat = 24
  }
}
