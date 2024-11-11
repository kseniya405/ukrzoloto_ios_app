//
//  ProductTileView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/17/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ProductTileView: UIView {
  
  // MARK: - Private variables
  private let imageView = UIImageView()
  private let titleLabel = LineHeightLabel()
  private let oldPriceLabel = UILabel()
  private let priceLabel = UILabel()
  private let discountLabel = UILabel()
  private let promoLabel = UILabel()
  private let favoriteButton = UIButton()
  
  private let discountHorizontalStackView: UIStackView = {
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 5
    stackView.distribution = .equalSpacing
    
    return stackView
  }()
  
  private let creditStackView: UIStackView = {
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = UIConstants.CreditStackView.spacing
    stackView.distribution = .fillEqually
    
    return stackView
  }()
  
  private let discountHintLabel = UILabel()
  private let discountHintIcon = UIImageView()
  private let discountHintButton = UIButton()
  
  private var shadowPath: CGPath?
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateLayers(with: bounds)
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureImageView()
    configureTitleLabel()
    configureOldPriceLabel()
    configurePriceLabel()
    configureDiscountLabel()
    configurePromoLabel()
    configureFavoriteButton()
    configureDiscountHintLabel()
    configureDiscountHintIcon()
    configureDiscountHintButton()
  }
  
  private func configureImageView() {
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = UIConstants.ImageView.backgroundColor
    imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    imageView.layer.cornerRadius = UIConstants.SelfView.cornerRadius
    imageView.clipsToBounds = true
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(UIConstants.ImageView.topInset)
      make.left.right.equalToSuperview().inset(UIConstants.ImageView.leftInset)
      make.height.equalTo(UIConstants.ImageView.height)
    }
    
    imageView.addSubview(creditStackView)
    creditStackView.snp.makeConstraints { make in
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  private func configureTitleLabel() {
    titleLabel.config
      .font(UIConstants.TitleLabel.font)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
      .textColor(UIConstants.TitleLabel.textColor)
      .textAlignment(UIConstants.TitleLabel.textAlignment)
    titleLabel.lineHeight = UIConstants.TitleLabel.lineHeight
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(UIConstants.TitleLabel.top)
      make.leading.trailing.equalToSuperview().inset(UIConstants.TitleLabel.trailing)
      make.height.greaterThanOrEqualTo(UIConstants.TitleLabel.height)
    }
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureOldPriceLabel() {
    oldPriceLabel.config
      .numberOfLines(UIConstants.OldPriceLabel.numberOfLines)
      .textAlignment(UIConstants.OldPriceLabel.textAlignment)
    addSubview(oldPriceLabel)
    oldPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.OldPriceLabel.top)
      make.leading.trailing.equalToSuperview().inset(UIConstants.OldPriceLabel.left)
      make.height.equalTo(UIConstants.OldPriceLabel.height)
    }
    oldPriceLabel.setContentHuggingPriority(.required, for: .vertical)
    oldPriceLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configurePriceLabel() {
    priceLabel.config
      .numberOfLines(UIConstants.PriceLabel.numberOfLines)
      .textAlignment(UIConstants.PriceLabel.textAlignment)
    addSubview(priceLabel)
    priceLabel.snp.makeConstraints { make in
      make.top.equalTo(oldPriceLabel.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(UIConstants.PriceLabel.left)
      make.height.equalTo(UIConstants.PriceLabel.height)
    }
    priceLabel.setContentHuggingPriority(.required, for: .vertical)
    priceLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureDiscountLabel() {
    discountLabel.config
      .font(UIConstants.DiscountLabel.font)
      .numberOfLines(UIConstants.DiscountLabel.numberOfLines)
      .textColor(UIConstants.DiscountLabel.textColor)
      .textAlignment(UIConstants.DiscountLabel.textAlignment)
    discountLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    discountLabel.layer.cornerRadius = UIConstants.DiscountLabel.cornerRadius
    discountLabel.backgroundColor = UIConstants.DiscountLabel.backgroundColor
    discountLabel.clipsToBounds = true
    addSubview(discountLabel)
    discountLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().offset(UIConstants.DiscountLabel.top)
      make.height.equalTo(UIConstants.DiscountLabel.height)
      make.width.equalTo(UIConstants.DiscountLabel.width)
    }
    discountLabel.setContentHuggingPriority(.required, for: .vertical)
    discountLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configurePromoLabel() {
    promoLabel.config
      .font(UIConstants.PromoLabel.font)
      .numberOfLines(UIConstants.PromoLabel.numberOfLines)
      .textColor(UIConstants.PromoLabel.textColor)
      .textAlignment(UIConstants.PromoLabel.textAlignment)
    
    promoLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    promoLabel.layer.cornerRadius = UIConstants.PromoLabel.cornerRadius
    promoLabel.layer.borderWidth = UIConstants.PromoLabel.borderWidth
    promoLabel.layer.borderColor = UIConstants.PromoLabel.borderColor.cgColor
    promoLabel.backgroundColor = UIConstants.PromoLabel.backgroundColor
    promoLabel.clipsToBounds = true
    
    addSubview(promoLabel)
    
    promoLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(UIConstants.PromoLabel.top)
      make.leading.equalTo(discountLabel.snp.trailing).offset(UIConstants.PromoLabel.leading)
      make.height.equalTo(UIConstants.PromoLabel.height)
      make.width.equalTo(UIConstants.PromoLabel.width)
    }
    
    promoLabel.setContentHuggingPriority(.required, for: .vertical)
    promoLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureFavoriteButton() {
    favoriteButton.setTitle(nil, for: .normal)
    addSubview(favoriteButton)
    favoriteButton.snp.makeConstraints { make in
      make.top.trailing.equalToSuperview().inset(UIConstants.FavoriteButton.top)
      make.height.equalTo(UIConstants.FavoriteButton.height)
      make.width.equalTo(UIConstants.FavoriteButton.width)
    }
  }
  
  private func configureDiscountHintLabel() {
    addSubview(discountHorizontalStackView)
    
    discountHorizontalStackView.snp.makeConstraints { make in
      make.top.equalTo(priceLabel.snp.bottom)
      make.height.equalTo(UIConstants.DiscontHintLabel.height)
      make.centerX.equalTo(priceLabel.snp.centerX).offset(2)
      make.bottom.equalToSuperview().inset(UIConstants.DiscontHintLabel.bottom)
    }
    
    discountHintLabel.config
      .font(UIConstants.DiscontHintLabel.font)
      .numberOfLines(UIConstants.DiscontHintLabel.numberOfLines)
      .textColor(UIConstants.DiscontHintLabel.textColor)
      .textAlignment(UIConstants.DiscontHintLabel.textAlignment)
    
    discountHorizontalStackView.addArrangedSubview(discountHintLabel)
    
    discountHintLabel.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.DiscontHintLabel.height)
    }
    
    discountHintLabel.setContentHuggingPriority(.required, for: .vertical)
    discountHintLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureDiscountHintIcon() {
    discountHorizontalStackView.addArrangedSubview(discountHintIcon)
    
    discountHintIcon.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.DiscontHintIcon.height)
      make.width.equalTo(UIConstants.DiscontHintIcon.width)
    }
  }
  
  private func configureDiscountHintButton() {
    addSubview(discountHintButton)
    
    discountHintButton.snp.makeConstraints { make in
      make.top.equalTo(discountHintLabel.snp.top)
      make.leading.equalTo(discountHintLabel.snp.leading)
      make.bottom.equalTo(discountHintLabel.snp.bottom)
      make.trailing.equalTo(discountHintIcon.snp.trailing)
    }
  }
  
  private func updateLayers(with rect: CGRect) {
    layer.cornerRadius = UIConstants.SelfView.cornerRadius
    
    setupShadow()
  }
  
  func setupShadow() {
    if shadowPath == nil {
      let shadowRadius = UIConstants.SelfView.shadowRadius
      let shadowRect = CGRect(
        origin: CGPoint(x: bounds.origin.x - shadowRadius / 2,
                        y: bounds.origin.y + shadowRadius),
        size: CGSize(width: bounds.width + shadowRadius,
                     height: bounds.height)
      )
      shadowPath = UIBezierPath(
        roundedRect: shadowRect,
        cornerRadius: UIConstants.SelfView.cornerRadius
      ).cgPath
    }
    layer.shadowColor = UIConstants.SelfView.shadowColor.cgColor
    layer.shadowOffset = .zero
    layer.shadowRadius = UIConstants.SelfView.shadowRadius / 2
  }
  
  // MARK: - Interface
  func setImage(_ imageViewModel: ImageViewModel?) {
    if let imageViewModel = imageViewModel {
      imageView.setImage(from: imageViewModel)
    } else {
      imageView.image = nil
    }
  }
  
  func setTitle(_ title: String?) {
    titleLabel.text = title
  }
  
  func setFormattedOldPrice(_ oldPrice: NSAttributedString?) {
    oldPriceLabel.attributedText = oldPrice
  }
  
  func setFormattedPrice(_ price: NSAttributedString?) {
    priceLabel.attributedText = price
  }
  
  func setDiscount(_ discount: String?) {
    discountLabel.text = discount
    discountLabel.isHidden = discount == nil
  }
  
  func setPromo(_ promo: String?) {
    promoLabel.text = promo
    promoLabel.isHidden = promo == nil
    
    if discountLabel.isHidden {
      promoLabel.snp.remakeConstraints { make in
        make.top.equalToSuperview().offset(UIConstants.PromoLabel.top)
        make.leading.equalToSuperview().offset(UIConstants.PromoLabel.leading)
        make.height.equalTo(UIConstants.PromoLabel.height)
        make.width.equalTo(UIConstants.PromoLabel.width)
      }
    }
  }
  
  func setDiscountHintText(_ hintText: String?) {
    discountHintLabel.text = hintText
  }
  
  func setDiscountHintIcon(_ icon: UIImage?) {
    discountHintIcon.image = icon
  }
  
  func getFavoriteButton() -> UIButton {
    return favoriteButton
  }
  
  func getDiscountHintButton() -> UIButton {
    return discountHintButton
  }
  
  func setCredits(_ credits: [DisplayableCredit]?) {
    
    creditStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    guard let credits = credits, !credits.isEmpty else { return }
    // Створюємо пул views для перевикористання
    let imageViews = credits.map { model -> UIImageView in
      let imgView = UIImageView()
      imgView.contentMode = .scaleAspectFit
      imgView.layer.backgroundColor = UIColor.white.cgColor
      imgView.roundCorners(
        radius: 12,
        borderWidth: 1,
        borderColor: UIColor(red: 0.892, green: 0.892, blue: 0.892, alpha: 1).cgColor
      )
      
      if let path = model.icon {
        imgView.frame = CGRect(
          x: 0, y: 0,
          width: UIConstants.CreditStackView.iconSideSize,
          height: UIConstants.CreditStackView.iconSideSize
        )
        imgView.setImage(path: path, size: CGSize(width: 16, height: 16))
        imgView.contentMode = .center
      } else {
        imgView.snp.makeConstraints { $0.size.equalTo(UIConstants.CreditStackView.iconSideSize) }
        imgView.setImage(from: ImageViewModel.image(model.image))
      }
      
      return imgView
    }
    
    imageViews.forEach { creditStackView.addArrangedSubview($0) }
    
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
    static let cornerRadius: CGFloat = 10
    static let shadowRadius: CGFloat = 6.0
    static let shadowOpacity: Float = 0.2
    
    static let shadowColor = UIColor.color(r: 157, g: 164, b: 183)
  }
  
  enum ImageView {
    static let backgroundColor = UIColor.white
    static let leftInset: CGFloat = 10
    static let topInset: CGFloat = 0
    static let height = 160
  }
  
  enum TitleLabel {
    static let top: CGFloat = 1
    static let trailing: CGFloat = 12
    static let textColor = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.regularAppFont(of: 12)
    static let lineHeight: CGFloat = 15
    static let textAlignment = NSTextAlignment.center
    static let numberOfLines = 3
    static let height = 50
  }
  
  enum OldPriceLabel {
    static let left: CGFloat = 6
    static let textAlignment = NSTextAlignment.center
    static let numberOfLines = 1
    static let top = 5
    static let height = 21
  }
  
  enum PriceLabel {
    static let left: CGFloat = 6
    static let textAlignment = NSTextAlignment.center
    static let numberOfLines = 1
    static let height = 21
  }
  
  enum DiscountLabel {
    static let top: CGFloat = 4
    static let height: CGFloat = 24
    static let width: CGFloat = 56
    static let cornerRadius: CGFloat = 12
    static let backgroundColor = UIColor.color(r: 255, g: 95, b: 95)
    static let textColor = UIColor.white
    static let font = UIFont.aliceRegularFont(of: 18)
    static let textAlignment = NSTextAlignment.center
    static let numberOfLines = 1
  }
  
  enum PromoLabel {
    static let top: CGFloat = 4
    static let leading: CGFloat = 4
    static let height: CGFloat = 24
    static let width: CGFloat = 67
    static let cornerRadius: CGFloat = 12
    static let backgroundColor = UIColor.white
    static let textColor = UIColor(named: "textDarkGreen")!
    static let font = UIFont.aliceRegularFont(of: 12)
    static let textAlignment = NSTextAlignment.center
    static let numberOfLines = 1
    static let borderWidth: CGFloat = 0.5
    static let borderColor = UIColor(hex: "#E3E3E3")
  }
  
  enum DiscontHintLabel {
    static let bottom: CGFloat = 10
    static let height: CGFloat = 24
    static let textColor = UIColor(named: "textDarkGreen")!
    static let font = UIFont.regularAppFont(of: 12)
    static let textAlignment = NSTextAlignment.center
    static let numberOfLines = 1
    static let leading: CGFloat = 20
  }
  
  enum DiscontHintIcon {
    static let leading: CGFloat = 5
    static let height: CGFloat = 24
    static let width: CGFloat = 24
  }
  
  enum FavoriteButton {
    static let top: CGFloat = 4
    static let height: CGFloat = 24
    static let width: CGFloat = 24
  }
  
  enum CreditStackView {
    static let spacing: CGFloat = -7.0
    static let iconSideSize: CGFloat = 24.0
  }
}
