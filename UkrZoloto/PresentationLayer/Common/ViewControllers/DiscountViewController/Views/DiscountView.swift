//
//  DiscountView.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 02.11.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol DiscountViewDelegate: AnyObject {
  func didTapOnAgreementButton()
}

class DiscountView: InitView {
  
  // MARK: - Public variables
  weak var delegate: DiscountViewDelegate?
  
  // MARK: - Private variables
  private let arrowImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "panArrow"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let barcodeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.transform = imageView.transform.rotated(by: .pi / 2)
    return imageView
  }()
  
  private let discountLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.color)
      .textAlignment(.center)
      .numberOfLines(0)
    label.lineHeight = UIConstants.TitleLabel.height
    
    return label
  }()
  
  private let agreementButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = UIConstants.AgreementButton.backgroundColor
    button.titleLabel?.font = UIConstants.AgreementButton.font
    button.titleLabel?.textColor = UIConstants.AgreementButton.color
    return button
  }()
  
  private let bottomImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "greenBackground"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
    
  // MARK: - Configure
  override func initConfigure() {
    super.initConfigure()
    setupView()
    setupArrowImageView()
    setupBarcodeImageView()
    setupBottomImageView()
    setupDiscountLabel()
    setupAgreementButton()
  }
  
  private func setupView() {
    backgroundColor = .white
    clipsToBounds = true
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    layer.cornerRadius = UIConstants.SelfView.cornerRadius
  }
  
  private func setupArrowImageView() {
    addSubview(arrowImageView)
    arrowImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.ArrowImageView.top)
      make.centerX.equalToSuperview()
      make.width.equalTo(UIConstants.ArrowImageView.width)
      make.height.equalTo(UIConstants.ArrowImageView.height)
    }
  }
  
  private func setupBarcodeImageView() {
    addSubview(barcodeImageView)
    barcodeImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
        .multipliedBy(UIConstants.BarcodeImageView.verticalMultiplier)
      make.top.equalToSuperview()
        .offset(UIConstants.BarcodeImageView.top)
      make.leading.equalToSuperview()
        .inset(UIConstants.BarcodeImageView.inset)
      make.height.equalTo(barcodeImageView.snp.width)
        .multipliedBy(UIConstants.BarcodeImageView.aspect)
        .priority(999)
    }
  }
  
  private func setupBottomImageView() {
    addSubview(bottomImageView)
    bottomImageView.snp.makeConstraints { make in
      make.top.equalTo(barcodeImageView.snp.bottom)
        .offset(UIConstants.BottomImageView.top)
        .priority(999)
      make.leading.equalToSuperview()
        .inset(UIConstants.BottomImageView.inset)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
        .offset(UIConstants.BottomImageView.bottom)
        .priority(.low)
      make.height.equalTo(bottomImageView.snp.width)
        .multipliedBy(UIConstants.BottomImageView.aspect)
    }
  }
  
  private func setupDiscountLabel() {
    addSubview(discountLabel)
    discountLabel.snp.makeConstraints { make in
      make.top.equalTo(bottomImageView)
        .offset(UIConstants.TitleLabel.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.TitleLabel.inset)
      make.centerX.equalToSuperview()
    }
    discountLabel.setContentHuggingPriority(.required, for: .vertical)
    discountLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupAgreementButton() {
    addSubview(agreementButton)
    agreementButton.snp.makeConstraints { make in
      make.top.equalTo(discountLabel.snp.bottom)
        .offset(UIConstants.AgreementButton.top)
      make.leading.equalToSuperview()
        .inset(UIConstants.AgreementButton.inset)
      make.centerX.equalToSuperview()
      make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        .inset(UIConstants.AgreementButton.bottom)
      make.height.equalTo(UIConstants.AgreementButton.height)
    }
  }
  
  // MARK: - Public
  func setImage(_ image: UIImage?) {
    barcodeImageView.image = image
  }
  
  func setTitle(_ text: String) {
    discountLabel.text = text
  }
  
  func setButtonTitle(_ text: String?) {
    agreementButton.setTitle(text, for: .normal)
  }
  
  func addTargetOnButton(_ target: Any?,
                         action: Selector,
                         for event: UIControl.Event) {
    agreementButton.addTarget(target, action: action, for: event)
  }
}

private enum UIConstants {
  enum SelfView {
    static let cornerRadius: CGFloat = 16
  }
  
  enum ArrowImageView {
    static let top: CGFloat = 22
    static let width: CGFloat = 37
    static let height: CGFloat = 11
  }
  
  enum BarcodeImageView {
    static let top: CGFloat = 120
    static let inset: CGFloat = 10
    static let verticalMultiplier: CGFloat = 0.8
    static let aspect: CGFloat = 174.0 / 327.0
  }
  
  enum TitleLabel {
    static let color = UIColor.white
    static let font = UIFont.boldAppFont(of: 22 * min(Constants.Screen.heightCoefficient, 1))
    static let height: CGFloat = (24 * min(Constants.Screen.heightCoefficient, 1)).rounded()
    
    static let top: CGFloat = (16 * min(Constants.Screen.heightCoefficient, 1)).rounded()
    static let inset: CGFloat = (28 * min(Constants.Screen.heightCoefficient, 1)).rounded()
  }
  
  enum AgreementButton {
    static let backgroundColor = UIColor.clear
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 15)
    
    static let top: CGFloat = (5 * min(Constants.Screen.heightCoefficient, 1)).rounded()
    static let bottom: CGFloat = (6 * min(Constants.Screen.heightCoefficient, 1)).rounded()
    static let inset: CGFloat = (28 * min(Constants.Screen.heightCoefficient, 1)).rounded()
    static let height: CGFloat = 24
  }
  
  enum BottomImageView {
    static let top: CGFloat = 95
    static let inset: CGFloat = (22 * min(Constants.Screen.heightCoefficient, 1)).rounded()
    static let bottom: CGFloat = 30
    static let aspect: CGFloat = 606.0 / 981.0
  }
}
