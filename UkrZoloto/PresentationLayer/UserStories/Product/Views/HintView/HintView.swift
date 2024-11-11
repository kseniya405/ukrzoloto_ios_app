//
//  HintView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 29.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class HintView: InitView {
  
  // MARK: - Public variables
  
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
      .textColor(UIConstants.Title.textColor)
      .numberOfLines(UIConstants.Title.numberOfLines)
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Subtitle.height
    label.config
      .font(UIConstants.Subtitle.font)
      .textColor(UIConstants.Subtitle.textColor)
      .numberOfLines(UIConstants.Subtitle.numberOfLines)
    
    return label
  }()
  
  private let bottomImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
    configureLeftImage()
    configureTitle()
    configureSubtitle()
    configureBottomImage()
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    layer.cornerRadius = UIConstants.SelfView.radius
  }
  
  private func configureLeftImage() {
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.ImageView.top)
      make.height.width.equalTo(UIConstants.ImageView.side)
      make.leading.equalToSuperview()
        .offset(UIConstants.ImageView.leading)
    }
    imageView.image = UIConstants.ImageView.image
  }
  
  private func configureTitle() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView)
      make.leading.equalTo(imageView.snp.trailing)
        .offset(UIConstants.Title.leading)
      make.trailing.equalToSuperview()
        .inset(UIConstants.Title.trailing)
    }
  }
  
  private func configureSubtitle() {
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.Subtitle.top)
      make.leading.trailing.equalTo(titleLabel)
    }
  }
  
  private func configureBottomImage() {
    addSubview(bottomImageView)
    bottomImageView.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom)
        .offset(UIConstants.BottomImageView.top)
      make.leading.equalTo(titleLabel)
      make.width.equalTo(UIConstants.BottomImageView.width)
      make.height.equalTo(UIConstants.BottomImageView.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.BottomImageView.bottom)
    }
    bottomImageView.image = UIConstants.BottomImageView.image
  }
  
  // MARK: - Interface
  func configure(title: String, subtitle: String) {
    titleLabel.text = title
    subtitleLabel.text = subtitle
  }
  
  func addTarget(_ target: Any, action: Selector) {
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(target, action: action)
    addGestureRecognizer(gesture)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 246, g: 246, b: 246)
    static let radius: CGFloat = 32
  }
  
  enum ImageView {
    static let image = #imageLiteral(resourceName: "hintImage")
    
    static let side: CGFloat = 50
    static let leading: CGFloat = 24
    static let top: CGFloat = 24
  }
  
  enum Title {
    static let font = UIFont.boldAppFont(of: 16)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let numberOfLines: Int = 0
    static let height: CGFloat = 19.2
    
    static let leading: CGFloat = 16
    static let trailing: CGFloat = 24
  }
  
  enum Subtitle {
    static let font = UIFont.regularAppFont(of: 13)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let numberOfLines: Int = 0
    static let height: CGFloat = 16.9
    
    static let top: CGFloat = 10
  }
  
  enum BottomImageView {
    static let image = #imageLiteral(resourceName: "longArrowRight")
    
    static let top: CGFloat = 16
    static let height: CGFloat = 29
    static let width: CGFloat = 63
    static let bottom: CGFloat = 16
  }
}
