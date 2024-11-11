//
//  MainInfoView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 31.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class MainInfoView: InitView {
  
  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.TitleLabel.height
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.textColor)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
    
    return label
  }()
  
  private let hintLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.HintLabel.height
    label.config
      .font(UIConstants.HintLabel.font)
      .textColor(UIConstants.HintLabel.textColor)
      .numberOfLines(UIConstants.HintLabel.numberOfLines)
    
    return label
  }()
  
  private let bottomLineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIConstants.BottomLineView.backgroundColor
    return view
  }()
  
  private var bottomView = UIView()
  private var createdViews = [UIView]()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTitleLabel()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.TitleLabel.inset)
    }
    bottomView = titleLabel
  }
  
  // MARK: - Interface
  func setContent(_ content: DeliveryMainInfo) {
    createdViews.forEach { $0.removeFromSuperview() }
    bottomView = titleLabel
    
    titleLabel.text = content.title
    for index in 0..<content.points.count {
      createPoint(for: content.points[index],
                  space: index == 0 ?
                    UIConstants.Point.topToTitle :
                    UIConstants.Point.spaceBetween)
    }
    
    configureHint(with: content.hint)
    configureBottomLineView()
  }
  
  // MARK: - Private methods
  private func createPoint(for point: DeliveryInfoPoint, space: CGFloat) {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    
    let label = UILabel()
    label.numberOfLines = UIConstants.Point.numberOfLines
    
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel)
      make.height.width.equalTo(UIConstants.Point.imageSide)
    }
    
    addSubview(label)
    label.snp.makeConstraints { make in
      make.top.equalTo(bottomView.snp.bottom)
        .offset(space)
      make.leading.equalTo(imageView.snp.trailing)
        .offset(UIConstants.Point.textLeading)
      make.trailing.equalTo(titleLabel)
      make.centerY.equalTo(imageView)
    }
    
    imageView.image = point.image
    label.attributedText = point.text
    
    bottomView = label
    createdViews.append(label)
    createdViews.append(imageView)
  }
  
  private func configureHint(with text: String) {
    addSubview(hintLabel)
    hintLabel.snp.makeConstraints { make in
      make.top.equalTo(bottomView.snp.bottom)
        .offset(UIConstants.HintLabel.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.HintLabel.leading)
      make.trailing.equalTo(titleLabel)
    }
    hintLabel.text = text
  }
  
  private func configureBottomLineView() {
    addSubview(bottomLineView)
    bottomLineView.snp.makeConstraints { make in
      make.top.equalTo(hintLabel.snp.bottom)
        .offset(UIConstants.BottomLineView.top)
      make.height.equalTo(UIConstants.BottomLineView.height)
      make.leading.trailing.equalTo(titleLabel)
      make.bottom.equalToSuperview()
    }
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum TitleLabel {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.boldAppFont(of: 18)
    static let height: CGFloat = 21.6
    static let numberOfLines: Int = 0
    
    static let inset: CGFloat = 24
  }
  
  enum Point {
    static let numberOfLines: Int = 0
    
    static let imageSide: CGFloat = 24
    static let textLeading: CGFloat = 14
    static let topToTitle: CGFloat = 20
    static let spaceBetween: CGFloat = 12
  }
  
  enum HintLabel {
    static let textColor = UIColor.black.withAlphaComponent(0.7)
    static let font = UIFont.regularAppFont(of: 13)
    static let height: CGFloat = 16.9
    static let numberOfLines: Int = 0
    static let opacity: CGFloat = 0.8
    
    static let top: CGFloat = 36
    static let leading: CGFloat = 27
  }
  
  enum BottomLineView {
    static let height: CGFloat = 1
    static let backgroundColor = UIColor.color(r: 227, g: 227, b: 227)
    
    static let top: CGFloat = 32
  }
  
}
