//
//  BottomButtonsView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 16.07.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import UIKit

// class BottomBuyProductView: InitView {
class BottomButtonsView: InitView {
  // MARK: - Public Interface
  public func updateViewStateWith(_ price: Price, isInCart: Bool) {
    self.updateBuyNowContainer(price, isInCart: isInCart)
  }

  public var getBuyProductButton: UIButton {
    return buyProductButton
  }

  // MARK: - UI State Update
  private func updateBuyNowContainer(_ price: Price, isInCart: Bool) {
    let cartLocalizationString = isInCart ?
    Localizator.standard.localizedString("в корзине") :
    Localizator.standard.localizedString("в корзину")

    buyProductButton.setTitle(cartLocalizationString.uppercased(), for: .normal)

    oldPriceLabel.text = StringComposer.shared.getOldPriceAttriburedString(price: price, isLongCurrency: false)?.string
    currentPriceLabel.text = StringComposer.shared.getPriceAttributedString(price: price, isLongCurrency: false)?.string
  }

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

  private let buyProductButton: UIButton = {
    let button = UIButton()

    button.backgroundColor = UIConstants.Button.color
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = UIConstants.Button.cornerRadius
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    button.titleLabel?.font = UIConstants.Button.font

    return button
  }()

  override func initConfigure() {
    super.initConfigure()

    configureBackgroundView()
    configureOldPriceLabel()
    configureCurrentPriceLabel()
    configureBuyProductButton()
  }

  private func configureBackgroundView() {
    backgroundColor = UIConstants.SelfView.backgroundColor

    layer.borderColor = UIConstants.SelfView.borderColor.cgColor
    layer.borderWidth = UIConstants.SelfView.borderWidth
    layer.cornerRadius = UIConstants.SelfView.radius
  }

  private func configureOldPriceLabel() {
    addSubview(oldPriceLabel)

    oldPriceLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(UIConstants.OldPriceLabel.top)
      make.leading.equalToSuperview().inset(UIConstants.OldPriceLabel.leading)
      make.height.equalTo(UIConstants.OldPriceLabel.height)
    }

    oldPriceLabel.setContentHuggingPriority(.required, for: .vertical)
    oldPriceLabel.setContentCompressionResistancePriority(.required, for: .vertical)

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

  private func configureCurrentPriceLabel() {
    addSubview(currentPriceLabel)

    currentPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(oldPriceLabel.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(UIConstants.CurrentPriceLabel.leading)
      make.height.equalTo(UIConstants.CurrentPriceLabel.height)
    }
  }

  private func configureBuyProductButton() {
    addSubview(buyProductButton)

    buyProductButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(UIConstants.Button.top)
      make.trailing.equalToSuperview().inset(UIConstants.Button.trailing)
      make.height.equalTo(UIConstants.Button.height)
      make.width.equalTo(UIConstants.Button.width)
    }
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let radius: CGFloat = 24
    static let borderColor = UIColor(hex: "#E3E3E3")
    static let borderWidth: CGFloat = 1
    static let backgroundColor = UIColor(hex: "#F6F6F6")
  }

  enum OldPriceLabel {
    static let crossedLineColor = UIColor(named: "red")!
    static let crossedLineHeight: CGFloat = 2
    static let crossedLineTrailing: CGFloat = 12
    static let textColor = UIColor(named: "textDarkGreen")!
    static let font = UIFont.regularAppFont(of: 14)

    static let height: CGFloat = 20
    static let leading: CGFloat = 18
    static let top: CGFloat = 13
  }

  enum CurrentPriceLabel {
    static let textColor = UIColor(named: "textDarkGreen")!
    static let font = UIFont.boldAppFont(of: 22.0)

    static let height: CGFloat = 26
    static let leading: CGFloat = 18
    static let trailing: CGFloat = 15
    static let top: CGFloat = 4
    static let bottom: CGFloat = 96
  }

  enum Button {
    static let top: CGFloat = 12
    static let trailing: CGFloat = 14
    static let height: CGFloat = 50
    static let color = UIColor(named: "darkGreen")!
    static let cornerRadius: CGFloat = 20
    static let font = UIFont.boldAppFont(of: 14.0)
    static let width: CGFloat = 120.0
  }
}
