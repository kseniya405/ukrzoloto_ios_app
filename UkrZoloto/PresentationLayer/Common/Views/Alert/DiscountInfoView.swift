//
//  DiscountInfoView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 09.08.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import UIKit

class DiscountInfoView: InitView {
  private let discountStackView: UIStackView = {
    let stackView = UIStackView()

    stackView.axis = .horizontal
    stackView.spacing = UIConstants.StackView.horizontalSpacing
    stackView.backgroundColor = .clear

    return stackView
  }()

  private let birthdayStackView: UIStackView = {
    let stackView = UIStackView()

    stackView.axis = .horizontal
    stackView.spacing = UIConstants.StackView.horizontalSpacing
    stackView.backgroundColor = .clear

    return stackView
  }()

  private let cashbackStackView: UIStackView = {
    let stackView = UIStackView()

    stackView.axis = .horizontal
    stackView.spacing = UIConstants.StackView.horizontalSpacing
    stackView.backgroundColor = .clear

    return stackView
  }()

  private let discountLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.StackView.titlesLabelFont
    label.textColor = UIConstants.StackView.textColor
    label.numberOfLines = 0
    label.backgroundColor = .clear
    label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)

    return label
  }()

  private let discountValueLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.StackView.numbersLabelFont
    label.textColor = UIConstants.StackView.textColor
    label.numberOfLines = 0
    label.backgroundColor = .clear

    return label
  }()

  private let birthdayLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.StackView.titlesLabelFont
    label.textColor = UIConstants.StackView.textColor
    label.numberOfLines = 0
    label.backgroundColor = .clear
    label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)

    return label
  }()

  private let birthdayValueLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.StackView.numbersLabelFont
    label.textColor = UIConstants.StackView.textColor
    label.numberOfLines = 0
    label.backgroundColor = .clear
    label.text = "5%"

    return label
  }()

  private let cashbackLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.StackView.titlesLabelFont
    label.textColor = UIConstants.StackView.textColor
    label.numberOfLines = 0
    label.backgroundColor = .clear
    label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)

    return label
  }()

  private let cashbackValueLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.StackView.numbersLabelFont
    label.textColor = UIConstants.StackView.textColor
    label.numberOfLines = 0
    label.backgroundColor = .clear

    return label
  }()

  override func initConfigure() {
    super.initConfigure()

    configureDiscountStackView()
    configureBirthdayStackView()
    configureCashbackStackView()
  }

  private func configureDiscountStackView() {
    addSubview(discountStackView)

    discountStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(UIConstants.StackView.top)
      make.leading.equalToSuperview()
      make.height.equalTo(UIConstants.StackView.height)
    }

    let persentsImageView = UIImageView(image: UIImage(named: "discount_icon"))
    persentsImageView.backgroundColor = .clear
    discountStackView.addArrangedSubview(persentsImageView)

    persentsImageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.StackView.height)
    }

    discountStackView.addArrangedSubview(discountLabel)
    discountStackView.addArrangedSubview(discountValueLabel)
  }

  private func shouldShowBirthdayDiscount() -> Bool {
    guard ProfileService.shared.user == nil else {
      return ProfileService.shared.isBirthdayPeriod()
    }
    return true
  }

  private func configureBirthdayStackView() {
    guard shouldShowBirthdayDiscount() else {
      birthdayStackView.isHidden = true

      return
    }

    birthdayStackView.isHidden = false

    addSubview(birthdayStackView)

    birthdayStackView.snp.makeConstraints { make in
      make.top.equalTo(discountStackView.snp.bottom).offset(UIConstants.StackView.top)
      make.leading.equalToSuperview()
      make.height.equalTo(UIConstants.StackView.height)
    }

    let birthdayImageView = UIImageView(image: UIImage(named: "birthday_discount_red_icon"))
    birthdayImageView.backgroundColor = .clear

    birthdayStackView.addArrangedSubview(birthdayImageView)
    birthdayImageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.StackView.height)
    }

    birthdayStackView.addArrangedSubview(birthdayLabel)
    birthdayStackView.addArrangedSubview(birthdayValueLabel)
  }

  private func configureCashbackStackView() {
    addSubview(cashbackStackView)

    let topElement = shouldShowBirthdayDiscount() ? birthdayStackView : discountStackView

    cashbackStackView.snp.makeConstraints { make in
      make.top.equalTo(topElement.snp.bottom).offset(UIConstants.StackView.top)
      make.leading.bottom.equalToSuperview()
      make.height.equalTo(UIConstants.StackView.height)
    }

    let birthdayImageView = UIImageView(image: UIImage(named: "bonus_usage_icon"))
    birthdayImageView.backgroundColor = .clear

    cashbackStackView.addArrangedSubview(birthdayImageView)
    birthdayImageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.StackView.height)
    }

    cashbackStackView.addArrangedSubview(cashbackLabel)
    cashbackStackView.addArrangedSubview(cashbackValueLabel)
  }

  public func update(_ price: Price, discount: Int) {
    localize()

    discountValueLabel.text = "\(discount)" + "%"
    cashbackValueLabel.text = calculateCashback(price)
  }

  private func localize() {
    discountLabel.text = Localizator.standard.localizedString("Скидка")
    cashbackLabel.text = Localizator.standard.localizedString("Кэшбэк")
    birthdayLabel.text = Localizator.standard.localizedString("День Рождения")
  }

  private func calculateCashback(_ price: Price) -> String? {
    let updatedPrice = Price(
      current: PriceCalculationService.shared.calculateCashback(price),
      old: price.old,
      discount: price.discount)

    return StringComposer.shared.getPriceAttributedString(price: updatedPrice, isLongCurrency: false)?.string
  }
}

fileprivate enum UIConstants {
  enum MainView {
    static let height: CGFloat = 148
    static let imageSize: CGFloat = 85
    static let cornerRadius: CGFloat = 22
    static let icon = UIImage(named: "bigPercentsIcon")!
    static let gradient = [.white, UIColor(red: 1, green: 0.95, blue: 0.89, alpha: 1)]
    static let borderColor = UIColor(named: "card")!
    static let borderWidth: CGFloat = 1
  }

  enum StackView {
    static let height: CGFloat = 24
    static let top: CGFloat = 5
    static let horizontalSpacing: CGFloat = 5
    static let verticalSpacing: CGFloat = 25
    static let leading: CGFloat = 20
    static let textColor = UIColor(hex: "#1F2323")
    static let titlesLabelFont = UIFont.regularAppFont(of: 14)
    static let numbersLabelFont = UIFont.boldAppFont(of: 14.0)
  }
}

