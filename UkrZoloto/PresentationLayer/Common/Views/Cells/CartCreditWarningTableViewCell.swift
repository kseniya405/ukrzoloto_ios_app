//
//  CartCreditWarningTableViewCell.swift
//  UkrZoloto
//
//  Created by Mykola on 11.10.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit


class CartCreditWarningTableViewCell: UITableViewCell, Reusable {
  
  private let infoIcon: UIImageView = {
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIConstants.icon
    
    return imageView
  }()
  
  private let label: UILabel = {
    
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.font)
      .textColor(UIConstants.textColor)
    
    label.lineHeight = 16.0
    label.numberOfLines = 0
    
    return label
  }()
  
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
  
  func setup(text: String) {
    label.text = text
  }
}


fileprivate extension CartCreditWarningTableViewCell {
  
  func initConfigure() {
    setupSubviews()
    selectionStyle = .none
    contentView.clipsToBounds = true
  }
  
  func setupSubviews() {
    
    contentView.addSubview(infoIcon)
    infoIcon.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.iconWidth)
      make.leading.equalToSuperview().offset(UIConstants.iconLeftPadding)
      make.top.equalToSuperview().offset(UIConstants.topPadding)
    }
    
    contentView.addSubview(label)
    label.snp.makeConstraints { make in
      make.leading.equalTo(infoIcon.snp.trailing).offset(UIConstants.iconRightPadding)
      make.top.equalToSuperview()
      make.trailing.equalToSuperview().offset(UIConstants.labelRightPadding)
      make.bottom.equalToSuperview().offset(-27.0)
    }
  }
}

fileprivate enum UIConstants {
  static let iconWidth: CGFloat = 16.0
  static let icon = UIImage(named: "credit_warning_info_icon")
  static let textColor = UIColor(hex: "#FF9500")
  static let font = UIFont.semiBoldAppFont(of: 12)
  static let topPadding: CGFloat = 6.0
  static let iconLeftPadding: CGFloat = 28.0
  static let iconRightPadding: CGFloat = 8.0
  static let labelRightPadding: CGFloat = -20.0
}

