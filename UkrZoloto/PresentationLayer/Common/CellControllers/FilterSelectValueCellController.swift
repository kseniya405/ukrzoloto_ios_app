//
//  FilterSelectValueCellController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 08.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class FilterSelectValueCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  var valueView: FilterSelectValueView? {
    get { return view as? FilterSelectValueView }
    set { view = newValue }
  }
  
  private(set) var isSelected: Bool?
  private var variant: FilterVariant
  
  // MARK: - Life cycle
  init(variant: FilterVariant) {
    self.variant = variant
    super.init()
  }
  
  // MARK: - Configuration
  override func setupView() {
    super.setupView()
    configure()
  }
  
  // MARK: - Interface
  func configure() {
    valueView?.configure(for: variant)
  }

}
