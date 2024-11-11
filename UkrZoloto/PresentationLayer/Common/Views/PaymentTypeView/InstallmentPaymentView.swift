//
//  InstallmentPaymentView.swift
//  UkrZoloto
//
//  Created by Andrew on 8/26/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class InstallmentPaymentView: DeliveryTypeView {
  
  // MARK: - Private variables
  let containerView = UIView()
  let detailsLabel: UILabel = {
    
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.DetailsLabel.font)
      .textColor(UIConstants.DetailsLabel.textColor)
      .numberOfLines(0)
    
    label.lineHeight = UIConstants.DetailsLabel.lineHeight
    
    return label
  }()
    
  let imageView = UIImageView()
  
  private let partsTitleLabel: UILabel = {
  
    let label = LineHeightLabel()
    
    label.config.font(UIConstants.PartsTitleLabel.font)
      .textColor(UIConstants.PartsTitleLabel.textColor)
      .numberOfLines(0)
    
    label.lineHeight = UIConstants.PartsTitleLabel.lineHeight
    label.text = Localizator.standard.localizedString("Кол-во платежей")
    
    return label
  }()
  
  private let monthlyTitleLabel: UILabel = {
    let label = LineHeightLabel()
    
    label.config.font(UIConstants.PartsTitleLabel.font)
      .textColor(UIConstants.PartsTitleLabel.textColor)
      .numberOfLines(0)
    
    label.lineHeight = UIConstants.PartsTitleLabel.lineHeight
    label.text = Localizator.standard.localizedString("Ежемесячный платеж")
        
    return label
  }()
  
  let monthlyValueLabel: UILabel = {
    let label = LineHeightLabel()
    
    label.config.font(UIConstants.ValueLabel.font)
      .textColor(UIConstants.ValueLabel.textColor)
        
    return label
  }()
  
  let partsView = InstallmentPaymentPartsView()
    
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Init configure
  func initConfigure() {
    
    setContentHuggingPriority(.required, for: .vertical)
    setContentCompressionResistancePriority(.required, for: .vertical)
    
    configureContainerView()
    configureDetailsLabel()
    configureImageView()
    configurePartsTitleLabel()
    configureMonthlyTitleLabel()
    configurePartsView()
    configureMonthlyValueLabel()
  }
  
  func configureContainerView() {
    containerView.backgroundColor = UIConstants.containerViewColor
    addBottomView(containerView)
  }
  
  private func configureDetailsLabel() {
    containerView.addSubview(detailsLabel)
    detailsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    detailsLabel.setContentHuggingPriority(.required, for: .vertical)
    detailsLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(-15.0)
      make.left.right.equalToSuperview()
    }
  }
  
  private func configureImageView() {
    imageView.contentMode = .scaleAspectFit
    containerView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.height.width.equalTo(UIConstants.ImageView.side)
      make.top.equalTo(detailsLabel.snp.bottom).offset(26.0)
    }
  }
  
  private func configurePartsTitleLabel() {
    containerView.addSubview(partsTitleLabel)
    partsTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.top)
      make.leading.equalTo(imageView.snp.trailing).offset(UIConstants.PartsTitleLabel.leftPadding)
      make.width.equalTo(70.0)
    }
    
    partsTitleLabel.sizeToFit()
  }
  
  private func configureMonthlyTitleLabel() {
    containerView.addSubview(monthlyTitleLabel)
    monthlyTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.top)
      make.leading.equalTo(partsTitleLabel.snp.trailing).offset(UIConstants.PartsTitleLabel.interitemSpacing)
      make.trailing.greaterThanOrEqualToSuperview()
    }
    monthlyTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }

  private func configurePartsView() {
    containerView.addSubview(partsView)
    partsView.snp.makeConstraints { make in
      make.leading.equalTo(partsTitleLabel.snp.leading)
      make.top.equalTo(imageView.snp.bottom).offset(13.0)
      make.bottom.equalToSuperview()
      make.width.equalTo(51)
    }
    partsView.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureMonthlyValueLabel() {
    containerView.addSubview(monthlyValueLabel)
    monthlyValueLabel.snp.makeConstraints { make in
      make.leading.equalTo(monthlyTitleLabel)
      make.top.equalTo(monthlyTitleLabel.snp.bottom).offset(9)
      make.trailing.greaterThanOrEqualToSuperview()
    }
  }
  
  // MARK: - Interface
  func setImage(_ imageViewModel: ImageViewModel) {
    imageView.setImage(from: imageViewModel)
  }
  
  func setDetails(text: String) {
    detailsLabel.text = text
  }
  
  func setPartsValue(_ value: Int) {

    partsView.setPartsCount(count: value)
  }

  func setMonthlyValue(_ value: String) {
    monthlyValueLabel.text = "\(value) грн"
  }
  
  func setPartsAction(target: Any, action: Selector) {
    let tap = UITapGestureRecognizer(target: target, action: action)
    partsView.addGestureRecognizer(tap)
  }
}

// MARK: - UIConstants
private enum UIConstants {
  static let containerViewColor = UIColor.clear
  
  enum DetailsLabel {
    static let font = UIFont.regularAppFont(of: 12)
    static let lineHeight: CGFloat = 13.8
    static let textColor = UIColor(hex: "#1F2323")
  }
   
  enum ImageView {
    static let side: CGFloat = 30
  }
  
  enum PartsTitleLabel {
    static let font = UIFont.regularAppFont(of: 12)
    static let lineHeight: CGFloat = 15.6
    static let textColor = UIColor.black.withAlphaComponent(0.45)
    static let leftPadding: CGFloat = 17
    static let interitemSpacing: CGFloat = 24
  }
  
  enum ValueLabel {
    static let font = UIFont.boldAppFont(of: 16)
    static let textColor = UIColor(hex: "#042320")
    
    static let top: CGFloat = 14
  }
  
  enum TitleLabel {
    static let textAlignment = NSTextAlignment.left
    static let font = UIFont.regularAppFont(of: 13)
    static let lineHeight: CGFloat = 15.6
    static let numberOfLines = 2
    static let textColor = UIColor.color(r: 0, g: 0, b: 0, a: 0.45)
    
    static let left: CGFloat = 17
    static let interitemSpacing: CGFloat = 24
  }
  
  enum PartsTextField {
    static let height: CGFloat = 33
    static let width: CGFloat = 51
  }
}
