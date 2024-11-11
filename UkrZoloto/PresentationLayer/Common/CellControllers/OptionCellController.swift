//
//  OptionCellController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 12.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol OptionCellControllerDelegate: AnyObject {
  func didTapOnOption(at controller: OptionCellController)
}

class OptionCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: OptionCellControllerDelegate?
  
  var optionView: OptionView? {
    get { return view as? OptionView }
    set { view = newValue }
  }
  
  private(set) var variant: FilterVariant {
    didSet { didSetVariant() }
  }
  
  // MARK: - Life cycle
  init(variant: FilterVariant) {
    self.variant = variant
    super.init()
  }
  
  // MARK: - Configuration
  override func setupView() {
    super.setupView()
    optionView?.addTarget(self,
                          action: #selector(didTapOnOption))
    didSetVariant()
  }
  
  override func unsetupView() {
    super.unsetupView()
    optionView?.removeTarget(nil, action: nil)
  }
  
  // MARK: - Private variables
  private func didSetVariant() {
    optionView?.configure(title: variant.value,
                          isSelected: variant.status,
                          isActive: variant.active)
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnOption() {
    guard variant.active else { return }
    delegate?.didTapOnOption(at: self)
  }
  
}
