//
//  SelectionViewCellController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class SelectionViewCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  var selectionView: SelectionView? {
    get { return view as? SelectionView }
    set { view = newValue }
  }
  
  var titleViewModel: ImageTitleViewModel? {
    didSet { didSetViewModel() }
  }
  
  // MARK: - Actions
  private func didSetViewModel() {
    selectionView?.setTitle(titleViewModel?.title)
    selectionView?.setLeftImage(titleViewModel?.image)
  }
  
  override func setupView() {
    super.setupView()
    didSetViewModel()
  }
}
