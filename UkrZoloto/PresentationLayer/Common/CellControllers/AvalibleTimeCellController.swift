//
//  AvalibleTimeCellController.swift
//  UkrZoloto
//
//  Created by user on 31.08.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol AvalibleTimeCellControllerDelegate: AnyObject {
  
}

class AvalibleTimeCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: AvalibleTimeCellControllerDelegate?
  
  var productsView: TimeTableView? {    
    get { return view as? TimeTableView }
    set { view = newValue }
  }
  
  private(set) var info = ImageTitleSubtitleViewModel(title: "", subtitle: "", image: nil)
  
  // MARK: - Configure
  override func setupView() {
    super.setupView()
    updateInfo()
  }
  
  // MARK: - Interface
  func setInfo(_ info: ImageTitleSubtitleViewModel) {
    self.info = info
    updateInfo()
  }
  
  // MARK: - Actions
  private func updateInfo() {
    productsView?.configure(viewModel: info)
  }
}
