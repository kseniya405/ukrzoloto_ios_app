//
//  NewUserBannerView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 28.06.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import UIKit

class NewUserBannerView: InitView {
  private let mainContainerView = UIView()
  
  private let topTitleLabel: UILabel = {
    let label = UILabel()
    
    label.font = UIConstants.TopTitleLabel.font
    label.textColor = UIConstants.TopTitleLabel.textColor
    label.numberOfLines = 0
    
    return label
  }()
  
  private let registeredUserPriceLabel: UILabel = {
    let label = UILabel()
    
    label.font = UIConstants.RegisteredUserPriceLabel.font
    label.textColor = UIConstants.RegisteredUserPriceLabel.textColor
    label.numberOfLines = 0
    
    return label
  }()
  
  private let discountStackView: UIStackView = {
    let stackView = UIStackView()
    
    stackView.axis = .horizontal
    stackView.spacing = UIConstants.DiscountStackView.spacing
    stackView.backgroundColor = .clear
    stackView.setContentCompressionResistancePriority(.required, for: .vertical)
    stackView.setContentHuggingPriority(.required, for: .vertical)
    return stackView
  }()
  
  private let discountLabel: UILabel = {
    let label = UILabel()
    
    label.font = UIConstants.DiscountStackView.titlesLabelFont
    label.textColor = UIConstants.DiscountStackView.textColor
    label.numberOfLines = 0
    label.backgroundColor = .clear
    
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    return label
  }()
  
  private let discountValueLabel: UILabel = {
    let label = UILabel()
    
    label.font = UIConstants.DiscountStackView.numbersLabelFont
    label.textColor = UIConstants.DiscountStackView.textColor
    label.numberOfLines = 0
    label.backgroundColor = .clear
    label.setContentCompressionResistancePriority(.defaultLow - 1, for: .horizontal)
        
    return label
  }()
  
  private let cashbackLabel: UILabel = {
    let label = UILabel()
    
    label.font = UIConstants.DiscountStackView.titlesLabelFont
    label.textColor = UIConstants.DiscountStackView.textColor
    label.numberOfLines = 0
    label.backgroundColor = .clear
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    return label
  }()
  
  private let cashbackValueLabel: UILabel = {
    let label = UILabel()
    
    label.font = UIConstants.DiscountStackView.numbersLabelFont
    label.textColor = UIConstants.DiscountStackView.textColor
    label.numberOfLines = 0
    label.backgroundColor = .clear
    label.setContentCompressionResistancePriority(.defaultLow - 1, for: .horizontal)
    
    return label
  }()
  
  private let registrationLabel: UILabel = {
    let label = UILabel()
    
    label.font = UIConstants.RegistrationLabel.font
    label.textColor = UIConstants.RegistrationLabel.textColor
    label.numberOfLines = 0
    
    return label
  }()
  
  private let arrowImageView = UIImageView(image: UIConstants.ArrowImageView.icon)
  
  private let registrationButton = UIButton()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    mainContainerView.applyGradient(isVertical: false, colorArray: UIConstants.MainView.gradient)
  }
  
  override func initConfigure() {
    super.initConfigure()
    
    configureMainContainerView()
    configureTopTitleLabel()
    configureRegisteredUserPriceLabel()
    configureDiscountView()
    configureRegistrationLabel()
    configureRegistrationButton()
  }
  
  private func configureMainContainerView() {
    addSubview(mainContainerView)
    mainContainerView.layer.cornerRadius = UIConstants.MainView.cornerRadius
    mainContainerView.layer.borderColor = UIConstants.MainView.borderColor.cgColor
    mainContainerView.layer.borderWidth = UIConstants.MainView.borderWidth
    mainContainerView.clipsToBounds = true
    
    mainContainerView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.MainView.height)
      make.top.leading.trailing.bottom.equalToSuperview()
    }
    
    let imageView = UIImageView(image: UIConstants.MainView.icon)
    mainContainerView.addSubview(imageView)
    
    imageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.MainView.imageSize)
      make.top.trailing.equalToSuperview()
    }
  }
  
  private func configureTopTitleLabel() {
    mainContainerView.addSubview(topTitleLabel)
    
    topTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(UIConstants.TopTitleLabel.top)
      make.leading.equalToSuperview().offset(UIConstants.TopTitleLabel.leading)
    }
  }
  
  private func configureRegisteredUserPriceLabel() {
    mainContainerView.addSubview(registeredUserPriceLabel)
    
    registeredUserPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(topTitleLabel.snp.bottom).offset(UIConstants.RegisteredUserPriceLabel.top)
      make.leading.equalToSuperview().offset(UIConstants.RegisteredUserPriceLabel.leading)
      make.height.equalTo(UIConstants.RegisteredUserPriceLabel.height)
    }
  }
  
  private func configureDiscountView() {
    localize()
    mainContainerView.addSubview(discountStackView)
    
    discountStackView.snp.makeConstraints { make in
      make.top.equalTo(registeredUserPriceLabel.snp.bottom).offset(UIConstants.DiscountStackView.top)
      make.leading.equalToSuperview().offset(UIConstants.DiscountStackView.leading)
      make.height.equalTo(UIConstants.DiscountStackView.height)
    }
    
    let persentsImageView = UIImageView(image: #imageLiteral(resourceName: "discount_icon"))
    persentsImageView.backgroundColor = .clear
    discountStackView.addArrangedSubview(persentsImageView)
    persentsImageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.DiscountStackView.height)
    }
    discountValueLabel.text = "3%"
    discountValueLabel.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.DiscountStackView.height)
    }
    discountStackView.addArrangedSubview(discountLabel)
    discountStackView.addArrangedSubview(discountValueLabel)
    
    let cashbackImageView = UIImageView(image: #imageLiteral(resourceName: "bonus_usage_icon"))
    cashbackImageView.backgroundColor = .clear
    cashbackImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    discountStackView.addArrangedSubview(cashbackImageView)
    cashbackImageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.DiscountStackView.height)
    }
    cashbackValueLabel.text = "   "
    cashbackValueLabel.snp.makeConstraints { make in
      make.height.width.equalTo(40)
      make.width.equalTo(40)
      make.width.width.equalTo(40)
    }
    discountStackView.addArrangedSubview(cashbackLabel)
    discountStackView.addArrangedSubview(cashbackValueLabel)
  }
  
  private func configureRegistrationLabel() {
    mainContainerView.addSubview(registrationLabel)
    
    registrationLabel.snp.makeConstraints { make in
      make.top.equalTo(discountStackView.snp.bottom).offset(UIConstants.RegistrationLabel.top)
      make.leading.equalToSuperview().offset(UIConstants.RegistrationLabel.leading)
      make.height.equalTo(UIConstants.RegistrationLabel.height)
    }
    
    mainContainerView.addSubview(arrowImageView)
    
    arrowImageView.snp.makeConstraints { make in
      make.centerY.equalTo(registrationLabel.snp.centerY)
      make.leading.equalTo(registrationLabel.snp.trailing).offset(UIConstants.ArrowImageView.leading)
    }
  }
  
  private func configureRegistrationButton() {
    mainContainerView.addSubview(registrationButton)
    
    registrationButton.snp.makeConstraints { make in
      make.leading.equalTo(registrationLabel.snp.leading)
      make.bottom.equalTo(registrationLabel.snp.bottom).offset(UIConstants.RegistrationButton.edges)
      make.top.equalTo(arrowImageView.snp.top)
      make.trailing.equalTo(arrowImageView.snp.trailing).offset(UIConstants.RegistrationButton.edges)
    }
  }
  
  public func update(_ price: Price) {
    localize()
    
    registeredUserPriceLabel.text = calculateRegisteredUserPrice(price)
    cashbackValueLabel.text = calculateCashback(price)
  }
  
  public func getRegistrationButton() -> UIButton {
    return registrationButton
  }
  
  private func localize() {
    topTitleLabel.text = Localizator.standard.localizedString("Цена для зарегистрированных")
    discountLabel.text = Localizator.standard.localizedString("Скидка")
    cashbackLabel.text = Localizator.standard.localizedString("Кэшбэк")
    registrationLabel.text = Localizator.standard.localizedString("Зарегистрироваться").uppercased()
  }
  
  private func calculateRegisteredUserPrice(_ price: Price) -> String? {
    let updatedPrice = Price(
      current: roundCurrenPrice(price.current * 0.97),
      old: price.old,
      discount: price.discount)
    
    return StringComposer.shared.getPriceAttributedString(
      price: updatedPrice,
      isLongCurrency: false)?.string
  }
  
  private func calculateCashback(_ price: Price) -> String? {
    let updatedPrice = Price(
      current: PriceCalculationService.shared.calculateCashback(price),
      old: price.old,
      discount: price.discount)
    
    return StringComposer.shared.getPriceAttributedString(price: updatedPrice, isLongCurrency: false)?.string
  }
  
  private func roundCurrenPrice(_ priceValue: Decimal) -> Decimal {
    let roundingBehavior = NSDecimalNumberHandler(roundingMode: .plain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
    let decimalNumber = NSDecimalNumber(decimal: priceValue)
    let roundedNumber = decimalNumber.rounding(accordingToBehavior: roundingBehavior)
    
    return roundedNumber.decimalValue
  }
}

private enum UIConstants {
  enum MainView {
    static let height: CGFloat = 148
    static let imageSize: CGFloat = 85
    static let cornerRadius: CGFloat = 22
    static let icon = #imageLiteral(resourceName: "bigPercentsIcon")
    static let gradient = [.white, #colorLiteral(red: 1, green: 0.95, blue: 0.89, alpha: 1)]
    static let borderColor = UIColor(named: "card")!
    static let borderWidth: CGFloat = 1
  }
  
  enum TopTitleLabel {
    static let top: CGFloat = 13.5
    static let leading: CGFloat = 20
    static let textColor = UIColor(named: "textDarkGreen")!
    static let font = UIFont.boldAppFont(of: 14.0)
  }
  
  enum RegisteredUserPriceLabel {
    static let height: CGFloat = 27
    static let top: CGFloat = 5
    static let leading: CGFloat = 20
    static let textColor = UIColor(named: "darkGreen")!
    static let font = UIFont.boldAppFont(of: 32.0)
  }
  
  enum DiscountStackView {
    static let height: CGFloat = 24
    static let top: CGFloat = 5
    static let spacing: CGFloat = 5
    static let leading: CGFloat = 20
    static let textColor = UIColor(hex: "#1F2323")
    static let titlesLabelFont = UIFont.regularAppFont(of: 14)
    static let numbersLabelFont = UIFont.boldAppFont(of: 14)
  }
  
  enum RegistrationLabel {
    static let height: CGFloat = 20
    static let top: CGFloat = 15
    static let leading: CGFloat = 20
    static let textColor = UIColor(named: "darkGreen")!
    static let font = UIFont.boldAppFont(of: 14)
  }
  
  enum ArrowImageView {
    static let icon = #imageLiteral(resourceName: "rightGreenArrow")
    static let leading: CGFloat = 10
  }
  
  enum RegistrationButton {
    static let edges: CGFloat = 10
  }
}

extension UIView {
  func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
    layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = colorArray.map({ $0.cgColor })
    if isVertical {
      // top to bottom
      gradientLayer.locations = [0.0, 1.0]
    } else {
      // left to right
      gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
      gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    backgroundColor = .clear
    gradientLayer.frame = bounds
    layer.insertSublayer(gradientLayer, at: 0)
  }
}
