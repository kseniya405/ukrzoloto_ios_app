//
//  DeliveryAndPaymentView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 30.06.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import Foundation

class DeliveryAndPaymentView: InitView {
  private let deliveryLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.Title.font
    label.textColor = UIConstants.Title.textColor
    label.numberOfLines = 0

    return label
  }()

  private let deliveryStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = UIConstants.StackView.spacing

    return stackView
  }()

  private let npDeliveryLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.ListItemTitle.font
    label.textColor = UIConstants.ListItemTitle.textColor
    label.numberOfLines = 0

    return label
  }()

  private let npDeliveryPriceLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.ListItemPrice.font
    label.textColor = UIConstants.ListItemPrice.textColor
    label.numberOfLines = 0

    return label
  }()

  private let packingView = UIView()

  private let packingTitleLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.ListItemPrice.font
    label.textColor = UIConstants.ListItemTitle.textColor
    label.numberOfLines = 0

    return label
  }()

  private let packingSubtitleLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.ListItemTitle.font
    label.textColor = UIConstants.ListItemTitle.textColor
    label.numberOfLines = 0

    return label
  }()

  private let paymentLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.Title.font
    label.textColor = UIConstants.Title.textColor
    label.numberOfLines = 0

    return label
  }()

  private let paymentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = UIConstants.StackView.spacing

    return stackView
  }()

  private let payByCardLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.ListItemTitle.font
    label.textColor = UIConstants.ListItemTitle.textColor
    label.numberOfLines = 0

    return label
  }()

  private let payByCashLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.ListItemTitle.font
    label.textColor = UIConstants.ListItemTitle.textColor
    label.numberOfLines = 0

    return label
  }()

  private let payByPostLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.ListItemTitle.font
    label.textColor = UIConstants.ListItemTitle.textColor
    label.numberOfLines = 0

    return label
  }()

  private let collapseButton = UIButton()

  override func initConfigure() {
    super.initConfigure()

    configureDeliveryView()
    configurePackingView()
    configurePaymentView()
    configureCollapseButton()
  }

  private func configureDeliveryView() {
    self.backgroundColor = .white
    addSubview(deliveryLabel)

    deliveryLabel.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.Title.height)
      make.top.leading.trailing.equalToSuperview()
    }

    addSubview(deliveryStackView)

    deliveryStackView.snp.makeConstraints { make in
      make.top.equalTo(deliveryLabel.snp.bottom).offset(UIConstants.StackView.top)
      make.leading.trailing.equalToSuperview()
    }

    let npDeliveryView = self.createListItemView(
      icon: UIImage(named: "iconsDeliveryNovaPoshtaSymbol")!,
      label: npDeliveryLabel,
      subLabel: npDeliveryPriceLabel)

    deliveryStackView.addArrangedSubview(npDeliveryView)
  }

  private func createListItemView(icon: UIImage, label: UILabel, subLabel: UILabel? = nil) -> UIView {
    let containerView = UIView()

    let iconImageView = UIImageView(image: icon)
    containerView.addSubview(iconImageView)
    iconImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
      make.height.width.equalTo(UIConstants.ListItemImage.size)
    }

    containerView.addSubview(label)
    label.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.equalTo(iconImageView.snp.trailing).offset(UIConstants.ListItemTitle.leading)
      make.trailing.equalToSuperview().offset(subLabel == nil ? 0 : -UIConstants.ListItemTitle.trailing)
    }

    if let subLabel = subLabel {
      containerView.addSubview(subLabel)
      subLabel.snp.makeConstraints { make in
        make.top.bottom.equalToSuperview()
        make.leading.equalTo(label.snp.trailing).offset(UIConstants.ListItemTitle.leading)
        make.trailing.equalToSuperview()
      }
    }

    return containerView
  }

  private func configurePackingView() {
    addSubview(packingView)

    packingView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.FreePackingView.height)
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(deliveryStackView.snp.bottom).offset(UIConstants.FreePackingView.top)
    }

    packingView.layer.cornerRadius = UIConstants.FreePackingView.cornerRadius
    packingView.backgroundColor = UIConstants.FreePackingView.backgroundColor

    let hintIcon = UIImageView(image: UIImage(named: "hintImage"))
    packingView.addSubview(hintIcon)
    hintIcon.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.FreePackingView.iconHorizontalSpacing)
      make.top.equalToSuperview().offset(UIConstants.FreePackingView.iconVerticalSpacing)
      make.bottom.equalToSuperview().offset(-UIConstants.FreePackingView.iconVerticalSpacing)
      make.width.height.equalTo(UIConstants.FreePackingView.iconSize)
    }

    packingView.addSubview(packingTitleLabel)
    packingTitleLabel.snp.makeConstraints { make in
      make.leading.equalTo(hintIcon.snp.trailing).offset(UIConstants.FreePackingView.titlesHorizontalSpacing)
      make.top.equalToSuperview().offset(UIConstants.FreePackingView.titlesVerticalSpacing)
      make.trailing.equalToSuperview().offset(UIConstants.FreePackingView.titlesHorizontalSpacing)
    }

    packingView.addSubview(packingSubtitleLabel)
    packingSubtitleLabel.snp.makeConstraints { make in
      make.leading.equalTo(hintIcon.snp.trailing).offset(UIConstants.FreePackingView.titlesHorizontalSpacing)
      make.top.equalTo(packingTitleLabel.snp.bottom)
      make.trailing.equalToSuperview().offset(UIConstants.FreePackingView.titlesHorizontalSpacing)
    }
  }

  private func configurePaymentView() {
    addSubview(paymentLabel)
    paymentLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(packingView.snp.bottom).offset(UIConstants.Title.top)
    }

    addSubview(paymentStackView)

    paymentStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(paymentLabel.snp.bottom).offset(UIConstants.StackView.top)
      make.bottom.equalToSuperview()
    }

    let payByCardView = self.createListItemView(
      icon: UIImage(named: "payByCardIcon")!,
      label: payByCardLabel)

    paymentStackView.addArrangedSubview(payByCardView)

    let payByCashView = self.createListItemView(
      icon: UIImage(named: "payByCashIcon")!,
      label: payByCashLabel)

    paymentStackView.addArrangedSubview(payByCashView)

    let payByPostView = self.createListItemView(
      icon: UIImage(named: "payByPostIcon")!,
      label: payByPostLabel)

    paymentStackView.addArrangedSubview(payByPostView)
  }

  private func configureCollapseButton() {
    addSubview(collapseButton)

    collapseButton.setTitle("", for: .normal)
    collapseButton.setImage(UIImage(named: "iconsDropDownUp"), for: .normal)

    collapseButton.snp.makeConstraints { make in
      make.height.equalTo(30)
      make.width.equalTo(30)
      make.trailing.equalToSuperview()
      make.centerY.equalTo(self.deliveryLabel.snp.centerY)
    }
  }

  func getCollapseButton() -> UIButton {
    return self.collapseButton
  }

  public func updateViewStateWith(_ npDeliveryPrice: Int) {
    deliveryLabel.text = Localizator.standard.localizedString("Доставка и оплата").uppercased()
    npDeliveryLabel.text = Localizator.standard.localizedString("Бесплатная доставка Новой Почтой")
    npDeliveryPriceLabel.text = "\(npDeliveryPrice) ₴"
    packingTitleLabel.text = Localizator.standard.localizedString("Бесплатная фирменная упаковка")
    packingSubtitleLabel.text = Localizator.standard.localizedString("при любой сумме заказа")
    paymentLabel.text = Localizator.standard.localizedString("Оплата").uppercased()
    payByCardLabel.text = Localizator.standard.localizedString("На сайте картами VISA и Mastercard")
    payByCashLabel.text = Localizator.standard.localizedString("Наличными при получении в магазине или курьеру")
    payByPostLabel.text = Localizator.standard.localizedString("Наложенным платежом")
  }

  func setCollapsedState() {
    collapseButton.setImage(UIImage(named: "iconsDropDownDown"), for: .normal)
    deliveryStackView.isHidden = true
    packingView.isHidden = true
    paymentLabel.isHidden = true
    paymentStackView.isHidden = true

    deliveryLabel.snp.remakeConstraints { make in
      make.height.equalTo(UIConstants.Title.height)
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

  func setUncollapsedState() {
    collapseButton.setImage(UIImage(named: "iconsDropDownUp"), for: .normal)
    deliveryStackView.isHidden = false
    packingView.isHidden = false
    paymentLabel.isHidden = false
    paymentStackView.isHidden = false

    deliveryLabel.snp.remakeConstraints { make in
      make.height.equalTo(UIConstants.Title.height)
      make.top.leading.trailing.equalToSuperview()
    }

    deliveryStackView.snp.remakeConstraints { make in
      make.top.equalTo(deliveryLabel.snp.bottom).offset(UIConstants.StackView.top)
      make.leading.trailing.equalToSuperview()
    }

    paymentLabel.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(packingView.snp.bottom).offset(UIConstants.Title.top)
    }

    paymentStackView.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(paymentLabel.snp.bottom).offset(UIConstants.StackView.top)
      make.bottom.equalToSuperview()
    }
  }
}

fileprivate enum UIConstants {
  enum StackView {
    static let spacing: CGFloat = 15
    static let top: CGFloat = 15
    static let bottom: CGFloat = 15
    static let deliveryHeight: CGFloat = 24
    static let paymentHeight: CGFloat = 24
  }

  enum Title {
    static let font = UIFont.boldAppFont(of: 14.0)
    static let textColor = UIColor(named: "textDarkGreen")!
    static let height: CGFloat = 24
    static let top: CGFloat = 24
  }

  enum ListItemImage {
    static let size: CGFloat = 24
  }

  enum ListItemTitle {
    static let font = UIFont.regularAppFont(of: 14)
    static let textColor = UIColor(named: "textDarkGreen")!
    static let leading: CGFloat = 5
    static let trailing: CGFloat = 50
  }

  enum ListItemPrice {
    static let font = UIFont.boldAppFont(of: 14.0)
    static let textColor = UIColor(named: "textDarkGreen")!
    static let width: CGFloat = 30
  }

  enum FreePackingView {
    static let top: CGFloat = 15
    static let backgroundColor = UIColor(hex: "#F6F6F6")
    static let cornerRadius: CGFloat = 20
    static let height: CGFloat = 90
    static let iconHorizontalSpacing: CGFloat = 15
    static let iconVerticalSpacing: CGFloat = 20
    static let iconSize: CGFloat = 50
    static let titlesHorizontalSpacing: CGFloat = 15
    static let titlesVerticalSpacing: CGFloat = 15
  }
}
