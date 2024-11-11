//
//  HitTestScrollView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 25.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class HitTestScrollView: UIScrollView {
  
  // MARK: - HitTest
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let view = super.hitTest(point, with: event)
    return view == self ? nil : view
  }
  
}
