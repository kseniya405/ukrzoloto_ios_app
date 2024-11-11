//
//  PromoBonusesView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 25.11.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

class PromoBonusesView: InitView {
  
  // MARK: - Public variables
  let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
      .numberOfLines(UIConstants.Title.numberOfLines)
      .textAlignment(.center)
    label.lineHeight = UIConstants.Title.lineHeight
    return label
  }()
  let writeOffButton = BonusesButton()
  let imageView = UIImageView()
  let resultTitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.ResultTitle.font)
      .textColor(UIConstants.ResultTitle.textColor)
      .numberOfLines(UIConstants.ResultTitle.numberOfLines)
    label.lineHeight = UIConstants.ResultTitle.lineHeight
    return label
  }()
  let resultDescriptionLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.ResultDescription.font)
      .textColor(UIConstants.ResultDescription.textColor)
      .numberOfLines(UIConstants.ResultDescription.numberOfLines)
      .textAlignment(.center)
    label.lineHeight = UIConstants.ResultDescription.lineHeight
    return label
  }()
  let cancelButton = UIButton()
  
  // MARK: - Private variables
  private let mainView = UIView()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureMainView()
    configureTitleLabel()
    configureWriteOffButton()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureMainView() {
    addSubview(mainView)
    mainView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
        .inset(UIConstants.MainView.topInsets)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.MainView.insets)
    }
    mainView.layer.cornerRadius = UIConstants.MainView.cornerRadius
    mainView.backgroundColor = UIConstants.MainView.backgroundColor
  }
  
  private func configureTitleLabel() {
    mainView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.Title.insets)
    }
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  private func configureWriteOffButton() {
    mainView.addSubview(writeOffButton)
    writeOffButton.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.WriteOffButton.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.WriteOffButton.insets)
      make.height.equalTo(UIConstants.WriteOffButton.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.WriteOffButton.bottom)
    }
  }

  private func configureImageView() {
    mainView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.ImageView.top)
      make.width.height.equalTo(UIConstants.ImageView.side)
      make.leading.equalToSuperview()
        .offset(UIConstants.ImageView.insets)
    }
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIConstants.ImageView.image
  }
  
  private func configureResultTitleLabel() {
    mainView.addSubview(resultTitleLabel)
    resultTitleLabel.snp.makeConstraints { make in
      make.centerY.equalTo(imageView)
      make.leading.equalTo(imageView.snp.trailing)
        .offset(UIConstants.ResultTitle.leading)
      make.trailing.equalToSuperview()
        .inset(UIConstants.ResultTitle.trailing)
    }
    resultTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureResultDescription() {
    mainView.addSubview(resultDescriptionLabel)
    resultDescriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(resultTitleLabel.snp.bottom)
        .offset(UIConstants.ResultDescription.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.ResultDescription.insets)
    }
    resultDescriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureCancelButton() {
    mainView.addSubview(cancelButton)
    cancelButton.snp.makeConstraints { make in
      make.top.equalTo(resultDescriptionLabel.snp.bottom)
        .offset(UIConstants.CancelButton.top)
      make.width.equalTo(UIConstants.CancelButton.width)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
        .inset(UIConstants.CancelButton.bottom)
    }
    cancelButton.setTitleColor(UIConstants.CancelButton.textColor, for: .normal)
    cancelButton.titleLabel?.font = UIConstants.CancelButton.font
  }
  
  // MARK: - Interface
  func configureInitState(viewModel: PromoBonusesViewModel) {
    writeOffButton.setTitle(viewModel.writeOffButtonTitle, for: .normal)
    titleLabel.attributedText = viewModel.title
    configure(isActive: viewModel.isActive)
    if let resultVM = viewModel.resultVM {
      configureImageView()
      configureResultTitleLabel()
      configureResultDescription()
      configureCancelButton()
      configure(resultVM: resultVM)
    } else {
      configureWriteOffButton()
      configure(withResult: false)
    }
  }
  
  // MARK: - Private methods
  private func configure(isActive: Bool) {
    writeOffButton.isEnabled = isActive
    writeOffButton.alpha = isActive ? 1 : 0.5
    titleLabel.alpha = isActive ? 1 : 0.5
  }
  
  private func configure(resultVM: ResultPromoViewModel) {
    configure(withResult: true)
    resultTitleLabel.text = resultVM.title
    resultDescriptionLabel.text = resultVM.descriptionTitle
    cancelButton.setTitle(resultVM.cancelButton, for: .normal)
  }
  
  private func configure(withResult: Bool) {
    imageView.isHidden = !withResult
    resultTitleLabel.isHidden = !withResult
    resultDescriptionLabel.isHidden = !withResult
    cancelButton.isHidden = !withResult
    titleLabel.isHidden = withResult
    writeOffButton.isHidden = withResult
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum MainView {
    static let backgroundColor = UIColor.color(r: 246, g: 246, b: 246)
    static let cornerRadius: CGFloat = 16
    static let topInsets: CGFloat = 10
    static let insets: CGFloat = 16
  }
  enum Title {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 13)
    static let numberOfLines: Int = 0
    static let lineHeight: CGFloat = 18
    
    static let top: CGFloat = 30
    static let insets: CGFloat = 50
  }
  enum WriteOffButton {
    static let top: CGFloat = 22
    static let height: CGFloat = 48
    static let insets: CGFloat = 16
    static let bottom: CGFloat = 30
  }
  enum StackView {
    static let backgroundColor = UIColor.clear
    static let spacing: CGFloat = 6
    static let top: CGFloat = 27
    static let insets: CGFloat = 16
    static let bottom: CGFloat = 20
  }
  enum ImageView {
    static let image = #imageLiteral(resourceName: "infoAccepted")
    static let top: CGFloat = 28
    static let insets: CGFloat = 36
    static let side: CGFloat = 24
  }
  enum ResultTitle {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.semiBoldAppFont(of: 15)
    static let numberOfLines: Int = 0
    static let lineHeight: CGFloat = 18

    static let leading: CGFloat = 6
    static let trailing: CGFloat = 16
  }
  enum ResultDescription {
    static let textColor = UIColor.black.withAlphaComponent(0.45)
    static let font = UIFont.regularAppFont(of: 13)
    static let numberOfLines: Int = 0
    static let lineHeight: CGFloat = 17
    
    static let top: CGFloat = 18
    static let insets: CGFloat = 29
  }
  enum CancelButton {
    static let textColor = UIColor.color(r: 0, g: 80, b: 47)
    static let font = UIFont.semiBoldAppFont(of: 15)
    
    static let top: CGFloat = 17
    static let height: CGFloat = 24
    static let width: CGFloat = 200
    static let bottom: CGFloat = 24
  }
}
