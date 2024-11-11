//
//  ActionDiscountContentView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 28.07.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import UIKit
import SnapKit

class ActionDiscountContentView: BaseContentView {

  // MARK: - Public variables
  weak var delegate: ActionContentViewDelegate?

  var title: String? {
    didSet {
      guard let title = title
      else { return }

      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIConstants.TitleLabel.font
      ]

      titleLabel.textAlignment = .left
      titleLabel.attributedText = NSAttributedString(string: title,
                                                     attributes: attributes)
    }
  }

  var subtitle: String? {
    didSet {
      subtitleLabel.text = subtitle
    }
  }

  var bottomTitle: String? {
    didSet {
      bottomLabel.text = bottomTitle
    }
  }

  public func update(_ price: Price) {
    discountInfoView.update(price, discount: ProfileService.shared.discountValue())

    if isBottomTitleAvailable {
      let priceWithDiscount = Price(
        current: PriceCalculationService.shared.calculatePriceWithDiscount(price),
        old: price.old,
        discount: price.discount)

      bottomValueLabel.attributedText = self.formattedPrice(priceWithDiscount)
    }
  }

  private func formattedPrice(_ price: Price) -> NSAttributedString? {
    guard let priceText = TextFormatters.priceFormatter.string(from: price.current as NSDecimalNumber) else {
      return nil
    }
    let attributes = [NSAttributedString.Key.foregroundColor: UIConstants.Price.textColor,
                      NSAttributedString.Key.font: UIConstants.Price.priceFont
    ]
    let priceString = NSMutableAttributedString(string: priceText, attributes: attributes)

    let currencyString = NSMutableAttributedString(string: Localizator.standard.localizedString("₴"))
    let currencyAttr = [NSAttributedString.Key.foregroundColor: UIConstants.Price.textColor,
                        NSAttributedString.Key.font: UIConstants.Price.currencyFont
    ]
    currencyString.addAttributes(currencyAttr,
                                 range: NSRange(location: 0, length: currencyString.length))
    priceString.append(NSAttributedString(string: " "))
    priceString.append(currencyString)

    return priceString
  }

  private var titleLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.TitleLabel.font)
      .numberOfLines(0)
      .textAlignment(.left)
      .textColor(UIConstants.TitleLabel.color)

    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()

    label.config
      .font(UIConstants.SubtitleLabel.font)
      .numberOfLines(0)
      .textAlignment(.left)
      .textColor(UIConstants.SubtitleLabel.textColor)

    return label
  }()

  private let bottomLabel: UILabel = {
    let label = UILabel()

    label.config
      .font(UIConstants.BottomLabel.font)
      .numberOfLines(0)
      .textAlignment(.left)
      .textColor(UIConstants.BottomLabel.textColor)

    return label
  }()

  private let bottomValueLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .left
    return label
  }()

  private var panableView = PanableView()
  private var bottomConstraint: Constraint?
  private var actions = [UIButton: (() -> Void)]()
  private let radioController = RadioController()
  private var lastAction: UIButton?
  private let isSubtitleAvailable: Bool
  private let isBottomTitleAvailable: Bool

  private let discountInfoView = DiscountInfoView()

  init(isSubtitleAvailable: Bool, isBottomTitleAvailable: Bool) {
    self.isSubtitleAvailable = isSubtitleAvailable
    self.isBottomTitleAvailable = isBottomTitleAvailable
    super.init(frame: .zero)
    initConfigure()
  }

  required init?(coder aDecoder: NSCoder) {
    isSubtitleAvailable = false
    isBottomTitleAvailable = false
    super.init(coder: aDecoder)
    initConfigure()
  }

  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.color
    layer.cornerRadius = UIConstants.SelfView.cornerRadius
    layout()
  }

  private func layout() {
    super.addSubview(titleLabel)
    if isSubtitleAvailable {
      super.addSubview(subtitleLabel)
    }
    super.addSubview(panableView)
    super.addSubview(discountInfoView)

    if isBottomTitleAvailable {
      super.addSubview(bottomLabel)
      super.addSubview(bottomValueLabel)
    }

    makeConstraints()
  }

  private func makeConstraints() {
    configPanableView()
    configTitleLabel()

    if isSubtitleAvailable {
      configSubtitleLabel()
    }

    configDiscountInfoView()

    if isBottomTitleAvailable {
      configBottomLabel()
    }
  }

  private func configPanableView() {
    panableView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.PanableView.height)
      make.top.equalToSuperview()
        .offset(UIConstants.PanableView.top)
      make.centerX.equalToSuperview()
      make.width.equalTo(UIConstants.PanableView.width)
    }
  }

  private func configTitleLabel() {
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(panableView.snp.bottom)
        .offset(UIConstants.TitleLabel.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.TitleLabel.leading)
      make.centerX.equalToSuperview()
        bottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
          .inset(UIConstants.TitleLabel.bottom).constraint
    }
  }

  private func configSubtitleLabel() {
    bottomConstraint?.deactivate()
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.SubtitleLabel.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.SubtitleLabel.leading)
      make.centerX.equalToSuperview()
      bottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
          .inset(UIConstants.SubtitleLabel.bottom).constraint
    }
  }

  private func configDiscountInfoView() {
    let topView = isSubtitleAvailable ? subtitleLabel : titleLabel

    discountInfoView.snp.makeConstraints { make in
      make.top.equalTo(topView.snp.bottom).offset(UIConstants.DiscountInfoView.top)
      make.left.equalToSuperview().offset(UIConstants.DiscountInfoView.leftRightPadding)
      make.right.equalToSuperview().offset(-UIConstants.DiscountInfoView.leftRightPadding)
    }
  }

  private func configBottomLabel() {
    bottomLabel.snp.makeConstraints { make in
      make.top.equalTo(discountInfoView.snp.bottom).offset(UIConstants.BottomLabel.top)
      make.leading.equalToSuperview().offset(UIConstants.SubtitleLabel.leading)
    }

    bottomValueLabel.snp.makeConstraints { make in
      make.centerY.equalTo(bottomLabel.snp.centerY)
      make.leading.equalTo(bottomLabel.snp.trailing).offset(10)
    }
  }

  private func createActionButton(action: AlertAction) -> UIButton {
    let actionButton = RadioButton()
    switch action.style {
    case .filled:
      actionButton.buttonState = .active
    case .unfilled:
      actionButton.buttonState = .inactive
    case .unfilledGreen:
      actionButton.buttonState = .inactiveGreen
    }
    actionButton.titleLabel?.font = action.isEmphasized ? UIConstants.Action.boldFont : UIConstants.Action.normalFont
    actionButton.setTitle(action.title, for: .normal)
    actions[actionButton] = action.completion
    radioController.buttons.append(actionButton)
    actionButton.addTarget(self,
                           action: #selector(didTapOnButton(_:)),
                           for: .touchUpInside)
    return actionButton
  }

  private func configNewAction(action: AlertAction) {
    let button = createActionButton(action: action)

    addSubview(button)

    bottomConstraint?.deactivate()

    button.snp.makeConstraints { make in
      if let lastButton = lastAction {
        make.top.equalTo(lastButton.snp.bottom)
          .offset(UIConstants.Action.top)
      } else {
        make.top.equalTo((isBottomTitleAvailable ? bottomLabel : discountInfoView).snp.bottom)
          .offset(UIConstants.Action.firstActionTop)
      }
      make.leading.equalToSuperview()
        .offset(UIConstants.Action.leading)
      make.centerX.equalToSuperview()

      bottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
          .inset(UIConstants.Action.bottom).constraint
      make.height.equalTo(UIConstants.Action.height)
    }

    lastAction = button
  }

  func addAction(_ action: AlertAction) {
    configNewAction(action: action)
  }

  @objc private func didTapOnButton(_ sender: RadioButton) {
    radioController.selectButton(sender)
    actions[sender]?()
    delegate?.hideView()
  }

}

private enum UIConstants {
  struct SelfView {
    static let color: UIColor = .white
    static let cornerRadius: CGFloat = 16
  }

  struct PanableView {
    static let height = 4
    static let top: CGFloat = 16
    static let width: CGFloat = 47
  }

  struct TitleLabel {
    static let top = 16
    static let leading = 16
    static let bottom = 100
    static let font = UIFont.boldAppFont(of: 20)
    static let color = UIColor.color(r: 62, g: 76, b: 75)
  }

  struct SubtitleLabel {
    static let leading = 16
    static let top = 16
    static let bottom = 100
    static let fontSize: CGFloat = 16
    static let textColor: UIColor = UIColor(named: "textDarkGreen")!.withAlphaComponent(0.6)
    static let font = UIFont.regularAppFont(of: 16)
    static let alignment: NSTextAlignment = .left
  }

  struct BottomLabel {
    static let leading = 16
    static let top = 15
    static let font = UIFont.regularAppFont(of: 16)
    static let textColor = UIColor(named: "textDarkGreen")!.withAlphaComponent(0.6)
    static let alignment: NSTextAlignment = .left
  }

  struct Action {
    static let firstActionTop = 25
    static let top = 15
    static let leading = 16
    static let height = 50
    static let bottom = 20

    static let normalFont = UIFont.boldAppFont(of: 14)
    static let boldFont = UIFont.boldAppFont(of: 14)
  }

  enum DiscountInfoView {
    static let top: CGFloat = 15
    static let leftRightPadding: CGFloat = 16.0
  }

  enum Price {
    static let priceFont = UIFont.boldAppFont(of: 16)
    static let currencyFont = UIFont.semiBoldAppFont(of: 12)
    static let textColor = UIColor.color(r: 4, g: 35, b: 32)
  }
}
