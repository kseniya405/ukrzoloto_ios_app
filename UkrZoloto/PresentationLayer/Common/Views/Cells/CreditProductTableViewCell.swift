//
//  CreditProductTableViewCell.swift
//  UkrZoloto
//
//  Created by Mykola on 25.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class CreditProductTableViewCell: UITableViewCell, Reusable {
  
  private let titleLabel: LineHeightLabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.TitleLabel.font)
      .textAlignment(.left)
      .textColor(UIConstants.TitleLabel.textColor)
    
    label.lineHeight = UIConstants.TitleLabel.lineHieght
    return label
  }()
  
  private let strikedLabel: LineHeightLabel = {
    
    let label = LineHeightLabel()
    return label
  }()
  
  private let productImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = UIConstants.ImageView.cornerRadius
    imageView.clipsToBounds = true
    imageView.layer.borderColor = UIConstants.ImageView.borderColor.cgColor
    imageView.layer.borderWidth = 1.0
    return imageView
  }()
  
  private let productTitleLabel: LineHeightLabel = {
    
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.ProductLabel.font)
      .numberOfLines(3)
      .textColor(UIConstants.ProductLabel.textColor)
    label.lineHeight = UIConstants.ProductLabel.lineHeight
    
    return label
  }()
  
  private let priceLabel: LineHeightLabel = {
    
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.PriceLabel.font)
      .textColor(UIConstants.PriceLabel.textColor)
      
    label.lineHeight = UIConstants.PriceLabel.lineHeight
    
    return label
  }()
  
  // MARK: - Life cycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfigure()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initConfigure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initConfigure()
  }
  
  private func initConfigure() {
    selectionStyle = .none
    setupSubviews()
  }
  
  func configure(imageUrl: URL?, title: String, price: Price) {
    
    productImageView.setImage(url: imageUrl)
    productTitleLabel.text = title
    titleLabel.text = Localizator.standard.localizedString("Название товара")
    priceLabel.text = "\(price.current) грн"
    
    guard price.current != price.old else { return }
    
    let attributedString: NSAttributedString = {
      
      let text = "\(price.old) грн"
      
      let attr = NSMutableAttributedString(string: text,
                                           attributes: [.font: UIConstants.OldPriceLabel.font as Any,
                                                        .foregroundColor: UIConstants.OldPriceLabel.textColor as Any])
      let strikeLength = text.count - 4
      
      attr.addAttributes([.strikethroughColor: UIConstants.OldPriceLabel.strikeColor,
                          .strikethroughStyle: 4], range: NSRange(location: 0, length: strikeLength))
      
      return attr
    }()
    
    strikedLabel.attributedText = attributedString
  }
  
  func setupSubviews() {
    
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.TitleLabel.padding)
      make.top.equalToSuperview().offset(UIConstants.TitleLabel.padding)
    }
    
    contentView.addSubview(productImageView)
    productImageView.snp.makeConstraints { make in
      
      make.leading.equalTo(titleLabel.snp.leading)
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.ImageView.topOffset)
      make.width.height.equalTo(UIConstants.ImageView.side)
    }
    
    contentView.addSubview(productTitleLabel)
    productTitleLabel.snp.makeConstraints { make in
      make.leading.equalTo(productImageView.snp.trailing).offset(UIConstants.ProductLabel.leftPadding)
      make.top.equalTo(productImageView.snp.top)
      make.trailing.equalToSuperview().offset(-UIConstants.ProductLabel.rightPadding)
    }
    
    contentView.addSubview(priceLabel)
    priceLabel.snp.makeConstraints { make in
      make.leading.equalTo(productTitleLabel.snp.leading)
      make.top.equalTo(productTitleLabel.snp.bottom).offset(UIConstants.PriceLabel.topOffset)
    }
    
    contentView.addSubview(strikedLabel)
    strikedLabel.snp.makeConstraints { make in
      make.leading.equalTo(priceLabel.snp.trailing).offset(UIConstants.OldPriceLabel.rightPadding)
      make.bottom.equalTo(priceLabel.snp.bottom).offset(-2)
    }
  }
}

private enum UIConstants {
  
  enum TitleLabel {
    static let lineHieght: CGFloat = 18.0
    static let font = UIFont.regularAppFont(of: 13)
    static let textColor = UIColor(named: "textDarkGreen")!.withAlphaComponent(0.6)
    static let padding: CGFloat = 24.0
  }
  
  enum ImageView {
    static let cornerRadius: CGFloat = 16.0
    static let side: CGFloat = 60.0
    static let topOffset: CGFloat = 16.0
    static let corderRadius: CGFloat = 16.0
    static let borderColor = UIColor(named: "card")!
  }
  
  enum ProductLabel {
    static let font = UIFont.boldAppFont(of: 15)
    static let textColor = UIColor(named: "textDarkGreen")!
    static let lineHeight: CGFloat = 19.5
    static let leftPadding: CGFloat = 16.0
    static let rightPadding: CGFloat = 24.0
  }
  
  enum PriceLabel {
    static let font = UIFont.boldAppFont(of: 16)
    static let textColor = UIColor(hex: "#042320")
    static let topOffset: CGFloat = 16.0
    static let lineHeight: CGFloat = 24.0
  }
  
  enum OldPriceLabel {
    static let textColor = UIColor(hex: "#042320").withAlphaComponent(0.4)
    static let font = UIFont.regularAppFont(of: 12)
    static let strikeColor = UIColor(hex: "#FF5935")
    static let rightPadding: CGFloat = 8.0
  }
}
