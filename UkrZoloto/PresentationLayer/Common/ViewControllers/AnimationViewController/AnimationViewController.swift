//
//  AnimationViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 11.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit

protocol AnimationViewControllerInput: AnyObject {
  func animate(to offset: CGFloat)
}

class AnimationViewController: LocalizableViewController {
  
  // MARK: - Public variables
  var subview: (UIView & AnimationViewInput)?
  var subviewHeight: CGFloat = UIConstants.Subview.defaultHeight
  let windowHeight: CGFloat = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?
    .windowScene?.statusBarManager?.statusBarFrame.height ?? 0
  
  // MARK: - Private variables
  private var topConstraint: Constraint?
  private var topConstraintOffset: CGFloat = 0 {
    didSet {
      topConstraint?.update(offset: topConstraintOffset)
      updateNavigationBarCapacity()
    }
  }
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    edgesForExtendedLayout = [.top, .bottom]
    extendedLayoutIncludesOpaqueBars = true
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.configureSubview()
    transitionCoordinator?.animate(alongsideTransition: { _ in
      self.updateNavigationBarCapacity()
    })
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateNavigationBarCapacity()
  }
  
  func updateNavigationBarCapacity() {
    let style = topConstraintOffset == 0 ? ColorStyle.transparent : .goldText
    (navigationController as? ColoredNavigationController)?.configure(with: style)
  }
  
  // MARK: - Configuration
  private func configureSubview() {
    guard let subview = subview,
      let navigationController = navigationController
      else { return }
    guard !view.subviews.contains(subview) else { return }
    view.addSubview(subview)
    subview.snp.makeConstraints { make in
      topConstraint = make.top.equalToSuperview()
        .offset(UIConstants.Subview.topOffset - navigationController.navigationBar.frame.height)
        .offset(0).constraint
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(subviewHeight)
    }
  }
  
}

private enum UIConstants {
  
  
  enum Subview {
    static let defaultHeight: CGFloat = 157 + windowHeight
    static let topOffset: CGFloat = -windowHeight
    
    static var windowHeight: CGFloat = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?
      .windowScene?.statusBarManager?.statusBarFrame.height ?? 0
  }
}

// MARK: - AnimationViewControllerInput
extension AnimationViewController: AnimationViewControllerInput {
  func animate(to offset: CGFloat) {
    guard let subview = subview else { return }
		if offset > subview.bounds.height {
      subview.hideElements()
			let navBarHeight = navigationController?.navigationBar.bounds.height ?? 0
      let bottomPartHeight = -(subviewHeight - windowHeight - navBarHeight)
      topConstraintOffset = max(bottomPartHeight, -offset)
    } else {
        subview.showElements()
        topConstraintOffset = 0
    }
  }
}
