//
//  AvailabilityCellController.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 06.01.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit
import AUIKit

class AvailabilityCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  var imageLabelView: ImageLabelView? {
    get { return view as? ImageLabelView }
    set { view = newValue }
  }
  
  var viewModel: ImageTitleColorViewModel? {
    didSet { didSetViewModel() }
  }
  
  // MARK: - Actions
  private func didSetViewModel() {
    guard let viewModel = viewModel else { return }
    imageLabelView?.setImage(viewModel.image)
    imageLabelView?.setTitle(viewModel.title)
    imageLabelView?.setTitleColor(viewModel.color)
  }
  
  override func setupView() {
    super.setupView()
    didSetViewModel()
  }
}
