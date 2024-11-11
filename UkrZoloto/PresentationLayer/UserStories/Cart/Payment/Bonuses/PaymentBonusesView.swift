//
//  PaymentBonusesView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 30.04.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation

class PaymentBonusesView: InitView {
  
  // MARK: - Public variables
  let topButton = UIButton()
  let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.textColor)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
    label.lineHeight = UIConstants.TitleLabel.lineHeight
    return label
  }()
  let discountTitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.DiscountTitle.font)
      .textColor(UIConstants.DiscountTitle.textColor)
      .numberOfLines(UIConstants.DiscountTitle.numberOfLines)
      .textAlignment(.left)
    label.lineHeight = UIConstants.DiscountTitle.lineHeight
    return label
  }()
  
  let writeOffView = WriteOffBonusesView()
  
  // MARK: - Private variables
  private let stackView = UIStackView()
  private let topContainerView = InitView()
  
  private var isWriteOffVisible: Bool = false {
    didSet {
      writeOffView.isHidden = !isWriteOffVisible
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    titleLabel.preferredMaxLayoutWidth = topContainerView.frame.width
  }
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureStackView()
    configureTopContainerView()
    configureTopButton()
    configureTitleLabel()
    configureDiscountTitleLabel()
    configureWriteOffView()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureStackView() {
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.StackView.insets)
      make.bottom.equalToSuperview()
        .inset(UIConstants.StackView.bottom)
    }
    stackView.distribution = .fillProportionally
    stackView.spacing = UIConstants.StackView.spacing
    stackView.axis = .vertical
    stackView.backgroundColor = UIConstants.StackView.backgroundColor
    stackView.setContentHuggingPriority(.required, for: .vertical)
    stackView.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureTopContainerView() {
    stackView.addArrangedSubview(topContainerView)
  }
  
  private func configureTopButton() {
    topContainerView.addSubview(topButton)
    topButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
        .offset(UIConstants.TopButton.insets)
      make.height.equalTo(UIConstants.TopButton.height)
      make.width.equalTo(UIConstants.TopButton.width)
    }
    topButton.imageEdgeInsets = UIConstants.TopButton.imageEdgeInsets
    topButton.setTitleColor(UIConstants.TopButton.color, for: .normal)
    topButton.titleLabel?.font = UIConstants.TopButton.font
    topButton.contentHorizontalAlignment = .left
    topButton.semanticContentAttribute = .forceRightToLeft
  }
  
  private func configureTitleLabel() {
    topContainerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(topButton.snp.bottom)
        .offset(UIConstants.TitleLabel.top)
      make.leading.equalTo(topButton)
      make.bottom.equalToSuperview()
        .inset(UIConstants.TitleLabel.bottom)
    }
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)
  }

  private func configureDiscountTitleLabel() {
    topContainerView.addSubview(discountTitleLabel)
    discountTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel)
      make.leading.equalTo(titleLabel.snp.trailing)
        .offset(UIConstants.DiscountTitle.leading)
      make.trailing.equalToSuperview()
        .inset(UIConstants.DiscountTitle.trailing)
    }
    discountTitleLabel.isHidden = true
  }
  
  private func configureWriteOffView() {
    stackView.addArrangedSubview(writeOffView)
  }
  
  // MARK: - Interface
  func configureInitState(viewModel: PaymentBonusesViewModel, isWriteOffVisible: Bool, currentText: String? = nil) {
    self.isWriteOffVisible = isWriteOffVisible
    topButton.setTitle(viewModel.buttonTitle, for: .normal)
    if isWriteOffVisible {
      topButton.setImage(UIConstants.TopButton.minusImage, for: .normal)
    } else {
      topButton.setImage(viewModel.isWriteOffActive ? UIConstants.TopButton.plusImage : nil, for: .normal)
    }
    topButton.alpha = viewModel.isWriteOffActive ? 1 : 0.5
    topButton.isUserInteractionEnabled = viewModel.isWriteOffActive
    
    writeOffView.configureInitState(viewModel: viewModel.writeOffVM, currentText: currentText)
    
    titleLabel.text = viewModel.title
    discountTitleLabel.isHidden = true
    
    if let bonusInfo = viewModel.bonusInfo,
       bonusInfo.isWrittenOff {
      configureWithAcceptedBonuses(
        bonusInfo.acceptedBonuses,
        resultTitleString: bonusInfo.resultTitleString)
    }
  }
  
  func changeWriteOffVisibility(isWriteOffVisible: Bool) {
    topButton.setImage(isWriteOffVisible ? UIConstants.TopButton.minusImage : UIConstants.TopButton.plusImage, for: .normal)
    self.isWriteOffVisible = isWriteOffVisible
  }
  
  func setDisableBonusesView(isDisable: Bool) {
    topButton.isUserInteractionEnabled = !isDisable
    topButton.alpha = isDisable ? 0.5 : 1
    titleLabel.alpha = isDisable ? 0.5 : 1
    topButton.setImage(
      isDisable ? nil :
        isWriteOffVisible ? UIConstants.TopButton.minusImage : UIConstants.TopButton.plusImage,
      for: .normal)
  }
  
  // MARK: - Private methods
  private func configureWithAcceptedBonuses(_ bonuses: String, resultTitleString: String) {
    discountTitleLabel.text = bonuses
    titleLabel.text = resultTitleString
    discountTitleLabel.isHidden = false
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum StackView {
    static let backgroundColor = UIColor.clear
    static let spacing: CGFloat = 6
    
    static let insets: CGFloat = 16
    static let bottom: CGFloat = 20
  }
  enum TopButton {
    static let plusImage = #imageLiteral(resourceName: "greenPlusIcon")
    static let minusImage = #imageLiteral(resourceName: "greenMinusIcon")
    static let color = UIColor.color(r: 0, g: 80, b: 47)
    static let font = UIFont.boldAppFont(of: 13)
    static let imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
    static let top: CGFloat = 0
    static let height: CGFloat = 17
    static let width: CGFloat = 350
    static let insets: CGFloat = 8
  }
  enum TitleLabel {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 13)
    static let numberOfLines: Int = 0
    static let lineHeight: CGFloat = 18
    
    static let top: CGFloat = -2
    static let bottom: CGFloat = 27
  }
  enum DiscountTitle {
    static let textColor = UIColor.color(r: 255, g: 95, b: 95)
    static let font = UIFont.regularAppFont(of: 13)
    static let numberOfLines: Int = 1
    static let lineHeight: CGFloat = 18
    
    static let leading: CGFloat = 6
    static let trailing: CGFloat = 24
  }

}
