//
//  GiftRequestView.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 15.03.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class GiftRequestView: InitView {
  
  // MARK: - Private variables
  
  private let giftImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.color)
      .textAlignment(.left)
      .numberOfLines(0)
    label.lineHeight = UIConstants.TitleLabel.height
    
    return label
  }()
  
  private let arrowImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  // MARK: - Configure
  override func initConfigure() {
    super.initConfigure()
    setupView()
    setupGiftImageView()
    setupTitleLabel()
    setupArrowImageView()
  }
  
  private func setupView() {
    backgroundColor = UIConstants.backgroundColor
    layer.cornerRadius = UIConstants.cornerRadius
  }
  
  private func setupGiftImageView() {
    addSubview(giftImageView)
    giftImageView.image = UIConstants.GiftImageView.image
    
    giftImageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.GiftImageView.side)
      make.top.equalToSuperview()
        .offset(UIConstants.GiftImageView.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.GiftImageView.leading)
    }
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.TitleLabel.top)
      make.leading.equalTo(giftImageView.snp.trailing)
        .offset(UIConstants.TitleLabel.leading)
      make.trailing.equalToSuperview()
        .inset(UIConstants.TitleLabel.trailing)
    }
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
  }
  
  private func setupArrowImageView() {
    addSubview(arrowImageView)
    arrowImageView.image = UIConstants.ArrowImageView.image
    
    arrowImageView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.ArrowImageView.height)
      make.width.equalTo(UIConstants.ArrowImageView.width)
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.ArrowImageView.top)
      make.trailing.equalToSuperview()
        .inset(UIConstants.ArrowImageView.trailing)
      make.bottom.equalToSuperview()
        .inset(UIConstants.ArrowImageView.bottom)
    }
  }
  
  // MARK: - Public
  func setTitle(_ text: String?) {
    titleLabel.text = text
  }
}

private enum UIConstants {
  
  static let backgroundColor = UIColor.color(r: 255, g: 220, b: 136, a: 0.2)
  static let cornerRadius: CGFloat = 24
  
  enum GiftImageView {
    static let image = #imageLiteral(resourceName: "gift")
    static let top: CGFloat = 18
    static let leading: CGFloat = 18
    static let side: CGFloat = 44
  }
  
  enum TitleLabel {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.regularAppFont(of: 16)
    static let height: CGFloat = 19
    
    static let top: CGFloat = 19
    static let leading: CGFloat = 12
    static let trailing: CGFloat = 23
  }
  
  enum ArrowImageView {
    static let image = #imageLiteral(resourceName: "next")
    static let top: CGFloat = 29
    static let trailing: CGFloat = 20
    static let height: CGFloat = 29
    static let width: CGFloat = 63
    static let bottom: CGFloat = 20
  }
}
