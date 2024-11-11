//
//  ManyOptionsCellController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 12.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol ManyOptionsCellControllerDelegate: AnyObject {
  func didTapOnManyOptions(at controller: ManyOptionsCellController)
}

class ManyOptionsCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: ManyOptionsCellControllerDelegate?
  
  var manyOptionsView: ManyOptionsView? {
    get { return view as? ManyOptionsView }
    set { view = newValue }
  }
  
  private(set) var filter: SelectFilter {
    didSet { didSetFilter() }
  }
  
  // MARK: - Life cycle
  init(filter: SelectFilter) {
    self.filter = filter
    super.init()
  }
  
  // MARK: - Configuration
  override func setupView() {
    super.setupView()
    manyOptionsView?.addTarget(self,
                               action: #selector(didTapOnManyOptions))
    didSetFilter()
  }
  
  override func unsetupView() {
    super.unsetupView()
    manyOptionsView?.removeTarget(nil, action: nil)
  }
  
  // MARK: - Private methods
  private func didSetFilter() {
    guard !StringComposer.shared.getFilterValueString(from: filter).isEmpty else {
      manyOptionsView?.setTitles(title: filter.title,
                                 value: nil)
      return
    }
    manyOptionsView?.setTitles(
      title: StringComposer.shared.getFilterValueString(from: filter),
      value: filter.title)
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnManyOptions() {
    delegate?.didTapOnManyOptions(at: self)
  }
  
}
