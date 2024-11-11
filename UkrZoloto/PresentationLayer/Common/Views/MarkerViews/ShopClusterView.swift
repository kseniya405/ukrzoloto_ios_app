//
//  ShopClusterView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ShopClusterView: UIView {

  // MARK: - Private variables
  private let imageView = UIImageView()
  private let titleLabel = LineHeightLabel()
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    autoresizingMask = [.flexibleHeight, .flexibleWidth]
    configureImageView()
    configureTitleLabel()
  }
  
  private func configureImageView() {
    imageView.image = UIConstants.ImageView.image
    imageView.contentMode = UIConstants.ImageView.contentMode
    imageView.backgroundColor = UIConstants.ImageView.backgroundColor
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func configureTitleLabel() {
    titleLabel.config
      .font(UIConstants.TitleLabel.font)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
      .textColor(UIConstants.TitleLabel.textColor)
      .textAlignment(UIConstants.TitleLabel.textAlignment)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(imageView.snp.width)
    }
  }
  
  // MARK: - Interface
  func setTitle(_ title: String?) {
    titleLabel.text = title
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum ImageView {
    static let contentMode = UIView.ContentMode.scaleAspectFit
    static let backgroundColor = UIColor.clear
    static let image = #imageLiteral(resourceName: "markerPlaceholder")
  }
  
  enum TitleLabel {
    static let textColor = UIColor.color(r: 255, g: 220, b: 136)
    static let font = UIFont.boldAppFont(of: 15)
    static let textAlignment = NSTextAlignment.center
    static let numberOfLines = 1
  }
}
