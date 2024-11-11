//
//  BlockView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 31.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit

class BlockView: InitView {
  
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
  func setContent(_ content: BlockContent) {
    createdViews.forEach { $0.removeFromSuperview() }
    bottomView = titleLabel
    
    titleLabel.text = content.title
    for index in 0..<content.points.count {
      createPointLabel(space: index == 0 ?
        UIConstants.Point.topToTitle :
        UIConstants.Point.spaceBetween,
                       text: content.points[index])
    }
    
    configureBottomLineView()
  }
  
  // MARK: - Private methods
  private func createPointLabel(space: CGFloat, text: String) {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Point.height
    label.config
      .font(UIConstants.Point.font)
      .textColor(UIConstants.Point.textColor)
      .numberOfLines(UIConstants.Point.numberOfLines)
    
    addSubview(label)
    label.snp.makeConstraints { make in
      make.top.equalTo(bottomView.snp.bottom)
        .offset(space)
      make.leading.trailing.equalTo(titleLabel)
    }
    
    label.text = text
    bottomView = label
    createdViews.append(label)
  }
  
  private func configureBottomLineView() {
    addSubview(bottomLineView)
    bottomLineView.snp.makeConstraints { make in
      make.top.equalTo(bottomView.snp.bottom)
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
    static let textColor = UIColor.black.withAlphaComponent(0.7)
    static let font = UIFont.regularAppFont(of: 14)
    static let height: CGFloat = 18.2
    static let numberOfLines: Int = 0
    
    static let topToTitle: CGFloat = 16
    static let spaceBetween: CGFloat = 10
  }
  
  enum BottomLineView {
    static let height: CGFloat = 1
    static let backgroundColor = UIColor.color(r: 227, g: 227, b: 227)
    
    static let top: CGFloat = 40
  }
}
