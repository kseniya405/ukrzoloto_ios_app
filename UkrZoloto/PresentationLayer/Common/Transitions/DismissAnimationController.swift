//
//  DismissAnimationController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  // MARK: - Public variables
  static let shared = DismissAnimationController()
  var duration: TimeInterval = 0.3
  
  // MARK: - Private variables
  private var style: TransitionStyle
  
  // MARK: - Life cycle
  init(style: TransitionStyle = .custom) {
    self.style = style
  }
  
  // MARK: - Actions
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    switch style {
    case .custom:
      guard let fromVC = transitionContext.viewController(forKey: .from),
        let fromView = fromVC.view as? (UIView & AnimationTransitionView) else { return }
      
      let containerView = transitionContext.containerView
      containerView.addSubview(fromView)
      let duration = transitionDuration(using: transitionContext)
      
      UIView.animate(
        withDuration: duration,
        animations: fromView.applyDismissAnimationChanges ) { (_) in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
      
    case .topToBottom:
      animateTopToBottom(using: transitionContext)
    }
  }
  
  func animateTopToBottom(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to) else {
        return
    }
    
    //    fromVC.beginAppearanceTransition(false, animated: true)
    //    toVC.beginAppearanceTransition(false, animated: true)
    
    fromVC.view.snapshotView(afterScreenUpdates: true)
    let containerView = transitionContext.containerView
    containerView.addSubview(fromVC.view)
    containerView.layoutIfNeeded()
    UIView.animate(withDuration: duration,
                   animations: {
                    fromVC.view.layoutIfNeeded()
                    fromVC.view.frame = CGRect(origin: CGPoint(x: toVC.view.frame.origin.x, y: -fromVC.view.frame.height),
                                               size: fromVC.view.frame.size)
    }, completion: { _ in
      //      fromVC.endAppearanceTransition()
      //      toVC.endAppearanceTransition()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
