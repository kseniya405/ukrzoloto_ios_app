//
//  BuyProductView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 27.06.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import Foundation

class BuyProductView: InitView {
  private let mainHorizontalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = UIConstants.MainStackView.spacing

    return stackView
  }()

  private let buyNowContainerView = UIView()

  private let oldPriceLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.OldPriceLabel.font
    label.textColor = UIConstants.OldPriceLabel.textColor
    label.numberOfLines = 0

    return label
  }()

  private let currentPriceLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.CurrentPriceLabel.font
    label.textColor = UIConstants.CurrentPriceLabel.textColor
    label.numberOfLines = 0

    return label
  }()

  private let addToCartLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.AddToCartLabel.font
    label.textColor = UIConstants.AddToCartLabel.textColor
    label.numberOfLines = 0

    return label
  }()

  private let addToCartButton = UIButton()

  private let buyWithCreditContainerView = UIView()
  private let substringLabel = UILabel()

  private let creditOptionsStackView: UIStackView = {
    let stackView = UIStackView()

    stackView.axis = .horizontal
    stackView.spacing = UIConstants.CreditOptionsStackView.spacing
    stackView.backgroundColor = .clear

    return stackView
  }()

  private let insurancePeriodLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.InsurancePeriodLabel.font
    label.textColor = UIConstants.InsurancePeriodLabel.textColor
    label.numberOfLines = 0

    return label
  }()

  private let insurancePriceLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.InsurancePriceLabel.font
    label.textColor = UIConstants.InsurancePriceLabel.textColor
    label.numberOfLines = 0

    return label
  }()

  private let buyWithCreditLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.BuyWithCreditLabel.font
    label.textColor = UIConstants.BuyWithCreditLabel.textColor
    label.numberOfLines = 0

    return label
  }()

  private let buyWithCreditButton = UIButton()

  override func initConfigure() {
    super.initConfigure()

    configureMainStackView()
    configureBuyNowContainerView()
    configureBuyWithCreditContainerView()
  }

  private func configureMainStackView() {
    addSubview(mainHorizontalStackView)

    mainHorizontalStackView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.MainStackView.height)
      make.top.leading.bottom.trailing.equalToSuperview()
    }
  }
}

extension BuyProductView {
  // MARK: - Buy Now Container
  private func configureBuyNowContainerView() {
    mainHorizontalStackView.addArrangedSubview(buyNowContainerView)

    buyNowContainerView.backgroundColor = UIConstants.BuyNowContainerView.backgroundColor
    buyNowContainerView.layer.cornerRadius = UIConstants.BuyNowContainerView.cornerRadius

    configureOldPrice()
    configureCurrentPrice()
    configureAddToCartLabel()
    configureAddToCartButton()
  }

  private func configureOldPrice() {
    oldPriceLabel.text = "12 550"
    buyNowContainerView.addSubview(oldPriceLabel)

    oldPriceLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.OldPriceLabel.leading)
      make.top.equalToSuperview().offset(UIConstants.OldPriceLabel.top)
    }

    let redCrossedView = UIView()
    redCrossedView.backgroundColor = UIConstants.OldPriceLabel.crossedLineColor

    oldPriceLabel.addSubview(redCrossedView)

    redCrossedView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.OldPriceLabel.crossedLineHeight)
      make.leading.equalTo(oldPriceLabel.snp.leading)
      make.trailing.equalTo(oldPriceLabel.snp.trailing).inset(UIConstants.OldPriceLabel.crossedLineTrailing)
      make.centerY.equalTo(oldPriceLabel.snp.centerY)
    }
  }

  private func configureCurrentPrice() {
    currentPriceLabel.text = "11 550 ₴"
    buyNowContainerView.addSubview(currentPriceLabel)

    currentPriceLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.CurrentPriceLabel.leading)
      make.top.equalTo(oldPriceLabel.snp.bottom).offset(UIConstants.CurrentPriceLabel.top)
    }
  }

  private func configureAddToCartLabel() {
    addToCartLabel.text = Localizator.standard.localizedString("Добавить в корзину").uppercased()
    buyNowContainerView.addSubview(addToCartLabel)

    addToCartLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.AddToCartLabel.leading)
      make.trailing.equalTo(buyNowContainerView.snp.trailing).offset(UIConstants.AddToCartLabel.trailing)
      make.top.equalTo(currentPriceLabel.snp.bottom).offset(UIConstants.AddToCartLabel.top)
    }
  }

  private func configureAddToCartButton() {
    buyNowContainerView.addSubview(addToCartButton)

    addToCartButton.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
    }
  }

  // MARK: - Buy With Credit Container
  private func configureBuyWithCreditContainerView() {
    mainHorizontalStackView.addArrangedSubview(buyWithCreditContainerView)

    buyWithCreditContainerView.backgroundColor = UIConstants.BuyWithCreditContainerView.backgroundColor
    buyWithCreditContainerView.layer.cornerRadius = UIConstants.BuyWithCreditContainerView.cornerRadius

    configureInsuranceOptions()
    configureInsurancePrice()
    configureBuyWithCreditLabel()
    configureBuyWithCreditButton()
  }

  private func configureInsuranceOptions() {
    buyWithCreditContainerView.addSubview(creditOptionsStackView)

    creditOptionsStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(UIConstants.CreditOptionsStackView.top)
      make.leading.equalToSuperview().offset(UIConstants.CreditOptionsStackView.leading)
    }

    buyWithCreditContainerView.addSubview(insurancePeriodLabel)

    insurancePeriodLabel.snp.makeConstraints { make in
      make.leading.equalTo(creditOptionsStackView.snp.trailing).offset(UIConstants.InsurancePeriodLabel.leading)
      make.top.equalToSuperview().offset(UIConstants.InsurancePeriodLabel.top)
    }
  }

  private func configureInsurancePrice() {
    substringLabel.font = UIConstants.InsurancePriceLabel.substringFont
    substringLabel.text = Localizator.standard.localizedString("от ")
    substringLabel.textColor = UIConstants.InsurancePriceLabel.textColor

    buyWithCreditContainerView.addSubview(substringLabel)

    substringLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.InsurancePriceLabel.substringLeading)
      make.top.equalTo(insurancePeriodLabel.snp.bottom).offset(15)
    }

    insurancePriceLabel.text = "609 ₴"
    buyWithCreditContainerView.addSubview(insurancePriceLabel)

    insurancePriceLabel.snp.makeConstraints { make in
      make.leading.equalTo(substringLabel.snp.trailing).offset(UIConstants.InsurancePriceLabel.leading)
      make.bottom.equalTo(substringLabel.snp.bottom)
    }
  }

  private func configureBuyWithCreditLabel() {
    buyWithCreditLabel.text = Localizator.standard.localizedString("Оплатить частями").uppercased()
    buyWithCreditContainerView.addSubview(buyWithCreditLabel)

    buyWithCreditLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.BuyWithCreditLabel.leading)
      make.trailing.equalTo(buyWithCreditContainerView.snp.trailing).offset(UIConstants.BuyWithCreditLabel.trailing)
			make.bottom.greaterThanOrEqualToSuperview().offset(-15)
    }
  }

  private func configureBuyWithCreditButton() {
    buyWithCreditContainerView.addSubview(buyWithCreditButton)

    buyWithCreditButton.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
    }
  }

  // MARK: - UI State Update
  private func updateBuyNowContainer(_ price: Price, isInCart: Bool) {
    let cartLocalizationString = isInCart ? "перейти в корзину" : "Добавить в корзину"
    addToCartLabel.text = Localizator.standard.localizedString(cartLocalizationString).uppercased()

    oldPriceLabel.text = StringComposer.shared.getOldPriceAttriburedString(price: price, isLongCurrency: false)?.string
    currentPriceLabel.text = StringComposer.shared.getPriceAttributedString(price: price, isLongCurrency: false)?.string
  }

	private func updateBuyWithCreditContainer(_ price: Price, credits: [CreditOption]) {

		guard !credits.isEmpty else {
			buyWithCreditContainerView.alpha = 0
      return
    }
		
    buyWithCreditContainerView.alpha = 1
		creditOptionsStackView.removeAllArrangedSubviews()
    buyWithCreditLabel.text = Localizator.standard.localizedString("Оплатить частями").uppercased()

    if let monthlyPayment = CreditCalculator.getLowestMonthlyPayment(price: price, credits: credits) {
      insurancePriceLabel.text = StringComposer.shared.getShortLowestMonthlyPaymentAttributedString(payment: monthlyPayment)?.string
    }

    creditOptionsStackView.removeAllArrangedSubviews()
		if credits.filter({ $0.showAsIcon}).count != 0 {
			creditOptionsStackView.alpha = 1
			credits.filter({ $0.showAsIcon}).forEach { credit in
				let currentCreditView = CreditView()
				if let iconImage = Bank(rawValue: credit.code)?.getIcon() {
					currentCreditView.setup(icon: iconImage)
				} else {
					currentCreditView.setup(icon: credit.icon)
				}
				creditOptionsStackView.addArrangedSubview(currentCreditView)
			}
			if let month = CreditCalculator.getBiggestMonthCount(credits: credits) {
				insurancePeriodLabel.text = Localizator.standard.localizedString("до %d мес", month)
			}
		} else {
			insurancePeriodLabel.text = ""
			creditOptionsStackView.alpha = 0
		}
		
		substringLabel.text = Localizator.standard.localizedString("от ")
  }

  // MARK: - Public Interface
	public func updateViewStateWith(_ price: Price, credits: [CreditOption], isInCart: Bool) {
    self.updateBuyNowContainer(price, isInCart: isInCart)
		self.updateBuyWithCreditContainer(price, credits: credits)
  }

  public var getAddToCartButton: UIButton {
    return addToCartButton
  }

  public var getBuyWithCreditButton: UIButton {
    return buyWithCreditButton
  }
}

fileprivate class CreditView: InitView {
  private let imageView: UIImageView = {

    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .clear

    return imageView
  }()

  override func initConfigure() {
    super.initConfigure()
    self.backgroundColor = .clear

    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.top.bottom.equalToSuperview()
      make.height.width.equalTo(UIConstants.CreditOptionsStackView.cellSize)
      make.trailing.equalToSuperview()
    }
  }

  func setup(icon: String?) {
		if let path = icon {
			imageView.contentMode = .scaleAspectFit
			imageView.setImage(path: path, size:
												 CGSize(width: 16,
																height: 16))
			imageView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
			imageView.roundCorners(radius: 12,
														borderWidth: 1,
														borderColor: UIColor(red: 0.892, green: 0.892, blue: 0.892, alpha: 1).cgColor)
			imageView.contentMode = .scaleAspectFit
		} else {
			imageView.image = nil
		}
  }
	
	func setup(icon: UIImage?) {
		if let icon = icon {
			imageView.contentMode = .scaleAspectFit
			imageView.image = icon
			imageView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
			imageView.roundCorners(radius: 12,
													 borderWidth: 1,
													 borderColor: UIColor(red: 0.892, green: 0.892, blue: 0.892, alpha: 1).cgColor)
		} else {
			imageView.image = nil
		}
	}
}

fileprivate enum UIConstants {
  enum MainStackView {
    static let spacing: CGFloat = 10.0
    static let height: CGFloat = 130.0
  }

  enum BuyNowContainerView {
    static let height: CGFloat = 130.0
    static let backgroundColor = UIColor(named: "darkGreen")!
    static let cornerRadius: CGFloat = 22
  }

  enum OldPriceLabel {
    static let crossedLineColor = UIColor(named: "red")!
    static let crossedLineHeight: CGFloat = 2
    static let crossedLineTrailing: CGFloat = 12
    static let textColor = UIColor.white
    static let font = UIFont.regularAppFont(of: 14)

    static let height: CGFloat = 24
    static let leading: CGFloat = 15
    static let trailing: CGFloat = 15
    static let top: CGFloat = 15
  }

  enum CurrentPriceLabel {
    static let textColor = UIColor.white
    static let font = UIFont.boldAppFont(of: 22.0)

    static let height: CGFloat = 26
    static let leading: CGFloat = 15
    static let trailing: CGFloat = 15
    static let top: CGFloat = 5
  }

  enum AddToCartLabel {
    static let textColor = UIColor.white
    static let font = UIFont.boldAppFont(of: 14.0)

    static let height: CGFloat = 40
    static let leading: CGFloat = 15
    static let trailing: CGFloat = -35
    static let top: CGFloat = 10
  }

  enum BuyWithCreditContainerView {
    static let height: CGFloat = 130.0
    static let backgroundColor = UIColor(hex: "#F6F6F6")
    static let cornerRadius: CGFloat = 22
  }

  enum InsurancePeriodLabel {
    static let textColor = UIColor(named: "textDarkGreen")!
    static let font = UIFont.regularAppFont(of: 14)

    static let height: CGFloat = 24
    static let leading: CGFloat = 2
    static let trailing: CGFloat = 15
    static let top: CGFloat = 15
  }

  enum CreditOptionsStackView {
    static let top: CGFloat = 15
    static let spacing: CGFloat = -7.0
    static let leading: CGFloat = 13
    static let cellSize: CGFloat = 21
  }

  enum InsurancePriceLabel {
    static let textColor = UIColor(named: "textDarkGreen")!
    static let font = UIFont.boldAppFont(of: 22.0)

    static let height: CGFloat = 26
    static let leading: CGFloat = 2
    static let trailing: CGFloat = 15
    static let top: CGFloat = 5

    static let substringFont = UIFont.regularAppFont(of: 14)
    static let substringLeading: CGFloat = 15
    static let substringTop: CGFloat = 13
  }

  enum BuyWithCreditLabel {
    static let textColor = UIColor(named: "darkGreen")!
    static let font = UIFont.boldAppFont(of: 14.0)

    static let height: CGFloat = 40
    static let leading: CGFloat = 15
    static let trailing: CGFloat = -35
    static let top: CGFloat = 10
  }
}
