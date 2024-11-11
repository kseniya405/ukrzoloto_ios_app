//
//  TopToBottomAnimationView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 15.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class TopToBottomAnimationView: InitView, AnimationTransitionView {
  
  // MARK: - Public variables
  var duration: TimeInterval = 0.3
  
  // MARK: - Animations
  func applyPresentAnimationChanges() {
    let oldFrame = frame
    frame = CGRect(origin: CGPoint(x: oldFrame.origin.x, y: -oldFrame.height),
                   size: oldFrame.size)
    UIView.animate(withDuration: duration,
                   animations: { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.layoutIfNeeded()
                    weakSelf.frame = oldFrame
    })
  }
  
  func applyDismissAnimationChanges() {
    UIView.animate(withDuration: duration,
                   animations: { [weak self] in
                    guard let self = self else { return }
                    self.layoutIfNeeded()
                    self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: -self.frame.height),
                                        size: self.frame.size)
    })
  }
}
