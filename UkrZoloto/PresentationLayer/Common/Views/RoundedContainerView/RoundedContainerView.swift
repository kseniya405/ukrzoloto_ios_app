//
//  RoundedContainerView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/20/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit

class RoundedContainerView: InitView {
  
  // MARK: - Public variables
  override var backgroundColor: UIColor? {
    get {
      return containerView.backgroundColor
    }
    set {
      containerView.backgroundColor = newValue
    }
  }
  
  var headerBackgroundColor: UIColor? {
    get {
      return super.backgroundColor
    }
    set {
      super.backgroundColor = newValue
    }
  }
  
  // MARK: - Private variables
  private var containerView = UIView()
  private var headerView = UIView()
  private var headerViewHeightConstraint: Constraint?
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    headerBackgroundColor = UIConstants.headerBackgroundColor
    configureHeaderContainerView()
    configureContainerView()
  }
  
  private func configureHeaderContainerView() {
    headerView.backgroundColor = .clear
    super.addSubview(headerView)
    headerView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      self.headerViewHeightConstraint = make.height.equalTo(0).priority(1).constraint
    }
  }
  
  private func configureContainerView() {
    backgroundColor = UIConstants.containerBackgroundColor
    containerView.clipsToBounds = true
    containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    containerView.layer.cornerRadius = UIConstants.cornerRadius
    super.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.top.equalTo(headerView.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  
  override func addSubview(_ view: UIView) {
    containerView.addSubview(view)
  }
  
  func addHeaderSubview(_ view: UIView) {
    headerView.addSubview(view)
  }
  
  func removeHeaderSubviews() {
    headerView.subviews.forEach { $0.removeFromSuperview() }
  }
}

private enum UIConstants {
  static let headerBackgroundColor = UIColor.color(r: 0, g: 80, b: 47)
  static let containerBackgroundColor = UIColor.white
  static let cornerRadius: CGFloat = 16
}
