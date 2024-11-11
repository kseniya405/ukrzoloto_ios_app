//
//  PaymentPromocodeView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 20.11.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation

class PaymentPromocodeView: InitView {
  
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
  let promocodeView = PromocodeView()

  // MARK: - Private variables
  private let stackView = UIStackView()
  private let topContainerView = InitView()
  
  private var isWriteOffVisible: Bool = false {
    didSet {
      promocodeView.isHidden = !isWriteOffVisible
    }
  }
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureStackView()
    configureTopContainerView()
    configureTopButton()
    configureTitleLabel()
    configurePromocodeView()
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
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
        .inset(UIConstants.TitleLabel.bottom)
    }
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  private func configurePromocodeView() {
    stackView.addArrangedSubview(promocodeView)
  }
  
  // MARK: - Interface
  func configureInitState(viewModel: PaymentPromocodeViewModel, isWriteOffVisible: Bool, errorTitle: String?, currentText: String?) {
    self.isWriteOffVisible = isWriteOffVisible
    titleLabel.text = viewModel.appliedString
    topButton.setTitle(viewModel.title, for: .normal)
    if isWriteOffVisible {
      topButton.setImage(UIConstants.TopButton.minusImage, for: .normal)
    } else {
      topButton.setImage(UIConstants.TopButton.plusImage, for: .normal)
    }
    promocodeView.configureInitState(viewModel: viewModel, errorTitle: errorTitle, currentText: currentText)
  }
  
  func changeWriteOffVisibility(isWriteOffVisible: Bool) {
    topButton.setImage(isWriteOffVisible ? UIConstants.TopButton.minusImage : UIConstants.TopButton.plusImage, for: .normal)
    self.isWriteOffVisible = isWriteOffVisible
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum StackView {
    static let backgroundColor = UIColor.clear
    static let spacing: CGFloat = 0
    
    static let insets: CGFloat = 16
    static let bottom: CGFloat = 20
  }
  enum TopButton {
    static let plusImage = #imageLiteral(resourceName: "greenPlusIcon")
    static let minusImage = #imageLiteral(resourceName: "greenMinusIcon")
    static let color = UIColor.color(r: 0, g: 80, b: 47)
    static let font = UIFont.boldAppFont(of: 13)
    static let imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
    static let height: CGFloat = 17
    static let width: CGFloat = 210
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
}
