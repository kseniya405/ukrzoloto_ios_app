//
//  SortView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 06.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class SortView: InitView {
  
  // MARK: - Private variables
  private let sortButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "sortImageButton"), for: .normal)
    button.contentMode = .scaleAspectFit
    return button
  }()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Label.font)
      .textColor(UIConstants.Label.textColor)
    return label
  }()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureSortButton()
    configureTitleLabel()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureSortButton() {
    addSubview(sortButton)
    sortButton.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview()
      make.height.width.equalTo(UIConstants.Button.side)
    }
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(sortButton)
      make.leading.equalTo(sortButton.snp.trailing)
        .offset(UIConstants.Label.leading)
      make.trailing.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  func setTitle(_ title: String?) {
    titleLabel.text = title
  }
  
  func addTarget(_ target: Any?, action: Selector) {
    let tapGesture = UITapGestureRecognizer(target: target, action: action)
    addGestureRecognizer(tapGesture)
  }
  
  func removeTarget(_ target: Any?, action: Selector?) {
    let tapGesture = UITapGestureRecognizer(target: target, action: action)
    removeGestureRecognizer(tapGesture)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum Button {
    static let side: CGFloat = 24
  }
  
  enum Label {
    static let font = UIFont.semiBoldAppFont(of: 15)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let lineHeifht: CGFloat = 24
    
    static let leading: CGFloat = 8
  }
}
