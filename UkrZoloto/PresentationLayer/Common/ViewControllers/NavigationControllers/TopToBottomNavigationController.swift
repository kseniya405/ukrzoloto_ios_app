//
//  TopToBottomNavigationController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 15.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class TopToBottomNavigationController: ColoredNavigationController {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  private let transitionController = TransitionController(style: .topToBottom)
  
  // MARK: - Life cycle
  override init(rootViewController: UIViewController, style: ColorStyle) {
    super.init(rootViewController: rootViewController, style: style)
    initConfigure()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfigure()
  }
  
  // MARK: - Setup
  private func initConfigure() {
    transitioningDelegate = transitionController
    modalPresentationStyle = .overFullScreen
  }
}
