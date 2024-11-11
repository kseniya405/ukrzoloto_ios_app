//
//  TitleViewCellController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 8/23/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class TitleViewCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  var titleView: TitleView? {
    set { view = newValue }
    get { return view as? TitleView }
  }
  
  private(set) var title: String
  
  // MARK: - Life cycle
  init(title: String) {
    self.title = title
    super.init()
  }
  
  // MARK: - Configuration
  override func setupView() {
    super.setupView()
    setTitle(title)
  }
  
  // MARK: - Interface
  func setTitle(_ title: String) {
    self.title = title
    titleView?.setText(title)
  }
  
}
