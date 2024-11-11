//
//  ShowProductsView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 13.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ShowProductsView: InitView {
  
  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
    return label
  }()
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.Subtitle.font)
      .textColor(UIConstants.Subtitle.textColor)
      .textAlignment(.right)
    return label
  }()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTitleLabel()
    configureSubtitleLabel()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    layer.cornerRadius = UIConstants.SelfView.cornerRadius
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview()
        .offset(UIConstants.Title.leading)
    }
  }
  
  private func configureSubtitleLabel() {
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.firstBaseline.equalTo(titleLabel)
      make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing)
        .offset(UIConstants.Subtitle.leading)
      make.trailing.equalToSuperview()
        .inset(UIConstants.Subtitle.trailing)
    }
  }
  
  // MARK: - Interface
  func setTitle(_ title: String) {
    titleLabel.text = title
  }
  
  func setSubtitle(_ subtitle: String) {
    subtitleLabel.text = subtitle
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let cornerRadius: CGFloat = 26
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
  }
  
  enum Title {
    static let textColor = UIColor.white
    static let font = UIFont.boldAppFont(of: 15)
    
    static let top: CGFloat = 14
    static let leading: CGFloat = 22
    static let bottom: CGFloat = 14
  }
  
  enum Subtitle {
    static let textColor = UIColor.white
    static let font = UIFont.regularAppFont(of: 15)
    
    static let leading: CGFloat = 24
    static let trailing: CGFloat = 20
  }
}
