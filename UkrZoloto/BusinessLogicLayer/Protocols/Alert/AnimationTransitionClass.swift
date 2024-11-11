//
//  AnimationTransitionView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol AnimationTransitionView: AnyObject {
  func applyPresentAnimationChanges()
  func applyDismissAnimationChanges()
}
