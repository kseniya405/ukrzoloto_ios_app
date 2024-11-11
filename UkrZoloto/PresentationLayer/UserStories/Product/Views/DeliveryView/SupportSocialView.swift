//
//  SupportSocialView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/25/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol SupportSocialViewDelegate: AnyObject {
  func didTapOnImage(with index: Int)
}

class SupportSocialView: InitView {
  
  // MARK: - Public variables
  weak var delegate: SupportSocialViewDelegate?
  
  var textColor = UIConstants.Title.textColor {
    didSet {
      titleLabel.textColor = textColor
    }
  }
  
  var titleFont = UIConstants.Title.font {
    didSet {
      titleLabel.font = titleFont
    }
  }
  
  // MARK: - Private variables
  private let mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.lineHeight
    label.numberOfLines = UIConstants.Title.numberOfLines
    return label
  }()
  
  private let stackView = UIStackView()
  
  override func initConfigure() {
    configureImageView()
    configureTitle()
    configureStackView()
  }
  
  private func configureImageView() {
    addSubview(mainImageView)
    mainImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
        .offset(UIConstants.ImageView.leading)
      make.width.height.equalTo(UIConstants.ImageView.side)
    }
  }
  
  private func configureTitle() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalTo(mainImageView)
      make.leading.equalTo(mainImageView.snp.trailing)
        .offset(UIConstants.Title.leading)
      make.trailing.equalToSuperview()
        .inset(UIConstants.Title.trailing)
    }
    titleLabel.config
      .font(titleFont)
      .textColor(textColor)
  }
  
  private func configureStackView() {
    addSubview(stackView)
    let spacing = (UIScreen.main.bounds.width - 42.0 - 160.0) / 4
    stackView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.StackView.top)
      make.leading.equalTo(mainImageView)
      make.trailing.equalToSuperview().offset(UIConstants.StackView.trailing)
      make.bottom.equalToSuperview()
    }
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = spacing
    stackView.isUserInteractionEnabled = true
  }
  
  // MARK: - Configuration
  func configure(viewModel: ImageTitleImagesViewModel) {
    titleLabel.text = viewModel.title
    if let mainImage = viewModel.image {
      configureWithMainImage(image: mainImage)
    } else {
      configureWithoutMainImage()
    }
    
    stackView.subviews.forEach { $0.removeFromSuperview() }
    stackView.removeAllArrangedSubviews()
    viewModel.images.forEach { addImage($0) }
    stackView.arrangedSubviews.forEach { view in
      view.isUserInteractionEnabled = true
      let tapGesture = UITapGestureRecognizer(target: self,
                                              action: #selector(didTapOnImage))
      view.addGestureRecognizer(tapGesture)
    }
  }
  
  // MARK: - Private methods
  private func addImage(_ image: ImageViewModel) {
    let imageView = UIImageView()
    imageView.setImage(from: image)
    stackView.addArrangedSubview(imageView)
  }
  
  private func configureWithMainImage(image: ImageViewModel) {
    mainImageView.setImage(from: image)
    mainImageView.isHidden = false
    
    titleLabel.snp.remakeConstraints { make in
      make.centerY.equalTo(mainImageView)
      make.leading.equalTo(mainImageView.snp.trailing)
        .offset(UIConstants.Title.leading)
      make.trailing.equalToSuperview()
        .inset(UIConstants.Title.trailing)
    }
  }
  
  private func configureWithoutMainImage() {
    mainImageView.isHidden = true
    
    titleLabel.snp.remakeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
        .offset(UIConstants.ImageView.leading)
      make.trailing.equalToSuperview()
        .inset(UIConstants.Title.trailing)
    }
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnImage(gestureRecognizer: UIGestureRecognizer) {
		if let index = stackView.arrangedSubviews.firstIndex(of: gestureRecognizer.view!) {
      delegate?.didTapOnImage(with: index)
    }
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum ImageView {
    static let side: CGFloat = 24
    static let leading: CGFloat = 24
  }
  enum Title {
    static let font = UIFont.regularAppFont(of: 12)
    static let lineHeight: CGFloat = 18
    static let textColor = UIColor.color(r: 62, g: 76, b: 75).withAlphaComponent(0.6)
    static let numberOfLines = 0
    
    static let leading: CGFloat = 24
    static let trailing: CGFloat = 23
  }
  enum StackView {
    static let top: CGFloat = 20
    static let space: CGFloat = 30
    static let trailing: CGFloat = -24
  }
}
