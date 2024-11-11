//
//  TransitionController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 15.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum TransitionStyle {
  case topToBottom
  case custom
}

class TransitionController: NSObject, UIViewControllerTransitioningDelegate {
  
  // MARK: - Public variables
  var presentDuration = 0.3
  var dismissDuration = 0.3
  
  // MARK: - Private variables
  private var style: TransitionStyle
  
  // MARK: - Life cycle
  init(style: TransitionStyle = .custom) {
    self.style = style
  }
  
  // MARK: - Actions
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let presentController = PresentAnimationController(style: style)
    presentController.duration = presentDuration
    return presentController
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let dismissController = DismissAnimationController(style: style)
    dismissController.duration = dismissDuration
    return dismissController
  }
}
