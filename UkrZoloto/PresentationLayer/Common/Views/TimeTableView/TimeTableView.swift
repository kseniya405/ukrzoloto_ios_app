//
//  TimeTableView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 06.02.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class TimeTableView: InitView {
  
  // MARK: - Private variables
  private let timeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.lineHeight
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
      .numberOfLines(UIConstants.Title.numberOfLines)
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Subtitle.lineHeight
    label.config
      .font(UIConstants.Subtitle.font)
      .textColor(UIConstants.Subtitle.textColor)
      .numberOfLines(UIConstants.Subtitle.numberOfLines)
    return label
  }()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    configureImageView()
    configureTitle()
    configureSubtitle()
  }
  
  private func configureImageView() {
    addSubview(timeImageView)
    timeImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.ImageView.top)
      make.width.height.equalTo(UIConstants.ImageView.side)
      make.leading.equalToSuperview()
        .offset(UIConstants.ImageView.leading)
    }
  }
  
  private func configureTitle() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalTo(timeImageView)
      make.leading.equalTo(timeImageView.snp.trailing)
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
      make.bottom.equalToSuperview()
        .inset(UIConstants.Subtitle.bottom)
    }
  }
  
  // MARK: - Interface
  func configure(viewModel: ImageTitleSubtitleViewModel) {
    titleLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    
    guard let imageViewModel = viewModel.image else {
      timeImageView.isHidden = true
      return
    }
    timeImageView.isHidden = false
    timeImageView.setImage(from: imageViewModel)
  }
  
  func updateBottomOffset() {
    subtitleLabel.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
        .inset(UIConstants.Subtitle.bottom)
    }
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum ImageView {
    static let top: CGFloat = 5
    static let side: CGFloat = 24
    static let leading: CGFloat = 24
  }
  enum Title {
    static let font = UIFont.regularAppFont(of: 13)
    static let lineHeight: CGFloat = 18
    static let textColor = UIColor.color(r: 62, g: 76, b: 75).withAlphaComponent(0.6)
    static let numberOfLines = 0
    
    static let leading: CGFloat = 24
    static let trailing: CGFloat = 24
  }
  enum Subtitle {
    static let font = UIFont.boldAppFont(of: 18)
    static let lineHeight: CGFloat = 24
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let numberOfLines = 0
    
    static let top: CGFloat = 2
    static let bottom: CGFloat = 10
  }
}

