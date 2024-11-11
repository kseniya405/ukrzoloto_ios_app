//
//  ProductSearchErrorView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 8/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ProductSearchErrorView: InitView {
  
  // MARK: - Private variables
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.height
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.color)
      .numberOfLines(UIConstants.Title.numberOfLines)
    return label
  }()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
    configureImage()
    configureTitle()
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureImage() {
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Result.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.Result.inset)
      make.height.width.equalTo(UIConstants.Image.side)
    }
  }
  
  private func configureTitle() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom)
        .offset(UIConstants.Title.top)
      make.leading.equalTo(imageView)
      make.centerX.equalToSuperview()
      make.bottom.lessThanOrEqualTo(snp.bottom)
    }
  }
  
}

// MARK: - SearchErrorViewInput
extension ProductSearchErrorView: SearchErrorViewInput {
  func setImage(_ image: UIImage) {
    imageView.image = image
  }
  
  func setTitle(_ title: String) {
    titleLabel.text = title
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
  }
  enum Result {
    static let numberOfLines: Int = 0
    static let height: CGFloat = 22.5
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    
    static let top: CGFloat = 40
    static let inset: CGFloat = 32
    
    enum Title {
      static let font = UIFont.regularAppFont(of: 18)
    }
    enum Value {
      static let font = UIFont.boldAppFont(of: 18)
    }
  }
  enum Image {
    static let side: CGFloat = 68
    static let top: CGFloat = 32
  }
  enum Title {
    static let numberOfLines: Int = 0
    static let font = UIFont.regularAppFont(of: 15)
    static let height: CGFloat = 22.5
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    
    static let top: CGFloat = 24
  }
}
