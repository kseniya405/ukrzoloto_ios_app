//
//  TitleHeaderController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class TitleHeaderController: AUIDefaultViewController {

  // MARK: - Public variables
  var headerView: AUIGenericContainerTableViewHeaderFooterView<UILabel>? {
    get { return view as? AUIGenericContainerTableViewHeaderFooterView<UILabel> }
    set { view = newValue }
  }
  
  var titleViewModel: TitleViewModel? {
    didSet { didSetViewModel() }
  }
    
  // MARK: - Actions
  private func didSetViewModel() {
    headerView?.genericView.text = titleViewModel?.title
  }
  
  override func setupView() {
    super.setupView()
    didSetViewModel()
  }
}
