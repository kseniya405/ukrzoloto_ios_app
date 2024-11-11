//
//  AnimationTransitionController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class AnimationTransitionController: NSObject,
UIViewControllerTransitioningDelegate {
    var presentDuration = UIConstants.presentDuration
    var dismissDuration = UIConstants.dismissDuration
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentController = PresentAnimationController.shared
        presentController.duration = presentDuration
        return presentController 
    }
    
    func animationController(
        forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissController = DismissAnimationController.shared
        dismissController.duration = dismissDuration
        return dismissController
    }
    
    private struct UIConstants {
        static let presentDuration = 0.3
        static let dismissDuration = 0.3
    }
}
