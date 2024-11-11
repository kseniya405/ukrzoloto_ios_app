//
//  SortCellController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 06.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol SortCellControllerDelegate: AnyObject {
  func didTapOnSort(at controller: SortCellController)
}

class SortCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: SortCellControllerDelegate?
  
  var sortView: SortView? {
    set { view = newValue }
    get { return view as? SortView }
  }
  
  private(set) var sortTitle: String?
  
  // MARK: - Configuration
  override func setupView() {
    super.setupView()
    sortView?.addTarget(self,
                        action: #selector(didTapOnSort))
    setTitle(sortTitle)
  }
  
  override func unsetupView() {
    super.unsetupView()
    sortView?.removeTarget(nil, action: nil)
  }
  
  override func setup() {
    super.setup()
  }
  
  // MARK: - Interface
  func setTitle(_ title: String?) {
    self.sortTitle = title
    sortView?.setTitle(title)
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnSort() {
    delegate?.didTapOnSort(at: self)
  }
  
}
