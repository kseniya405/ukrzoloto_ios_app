//
//  PresentAnimationController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  // MARK: - Public variables
  static let shared = PresentAnimationController()
  
  private enum Constants {
    static let transitionDuration: TimeInterval = 0.15
  }
  var duration: TimeInterval = Constants.transitionDuration
  
  // MARK: - Private variables
  private var style: TransitionStyle
  
  // MARK: - Life cycle
  init(style: TransitionStyle = .custom) {
    self.style = style
  }
  
  // MARK: - Actions
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    switch style {
    case .custom:
      guard let toVC = transitionContext.viewController(forKey: .to),
        let toView = toVC.view as? (UIView & AnimationTransitionView) else {
          return
      }
      toView.snapshotView(afterScreenUpdates: true)
      let containerView = transitionContext.containerView
      containerView.addSubview(toView)
      containerView.layoutIfNeeded()
      
      UIView.animate(
        withDuration: duration,
        animations: toView.applyPresentAnimationChanges) { (_) in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }

    case .topToBottom:
      animateTopToBottom(using: transitionContext)
    }
    
  }
  
  func animateTopToBottom(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toVC = transitionContext.viewController(forKey: .to) else {
      return
    }
    //    toVC.beginAppearanceTransition(true, animated: true)
    //    fromVC.beginAppearanceTransition(false, animated: true)
    
    toVC.view.snapshotView(afterScreenUpdates: true)
    let containerView = transitionContext.containerView
    containerView.addSubview(toVC.view)
    containerView.layoutIfNeeded()
    let oldFrame = toVC.view.frame
    toVC.view.frame = CGRect(origin: CGPoint(x: oldFrame.origin.x, y: -oldFrame.height),
                             size: oldFrame.size)
    UIView.animate(withDuration: duration,
                   animations: {
                    toVC.view.layoutIfNeeded()
                    toVC.view.frame = oldFrame
    }, completion: { _ in
      //      toVC.endAppearanceTransition()
      //      fromVC.endAppearanceTransition()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
