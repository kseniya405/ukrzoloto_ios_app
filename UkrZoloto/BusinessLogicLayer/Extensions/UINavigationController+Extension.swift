//
//  UINavigationController+Extension.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 24.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

extension UINavigationController {
  func pushViewController(_ viewController: UIViewController,
                          animated: Bool,
                          completion: @escaping () -> Void) {
    pushViewController(viewController, animated: animated)
    guard animated,
      let coordinator = transitionCoordinator else {
        DispatchQueue.main.async { completion() }
        return
    }
    coordinator.animate(alongsideTransition: nil) { _ in completion() }
  }
  
  func addTransition(transitionType type: CATransitionType = .fade,
                     subtype: CATransitionSubtype,
                     duration: CFTimeInterval = 0.3) {
    let transition = CATransition()
    transition.duration = duration
    transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    transition.type = type
    transition.subtype = subtype
    self.view.layer.add(transition, forKey: nil)
  }
  
  func pushViewControllerWithFlipAnimation(viewController: UIViewController) {
    self.pushViewController(viewController, animated: false)
    if let transitionView = view {
      UIView.transition(with:transitionView,
                        duration: 0.8,
                        options: .curveEaseInOut,
                        animations: nil,
                        completion: nil)
    }
  }
  
  func popToRootViewController(animated: Bool,
                               completion: @escaping () -> Void) {
    popToRootViewController(animated: animated)
    guard animated,
      let coordinator = transitionCoordinator else {
        DispatchQueue.main.async { completion() }
        return
    }
    coordinator.animate(alongsideTransition: nil) { _ in completion() }
  }
}
