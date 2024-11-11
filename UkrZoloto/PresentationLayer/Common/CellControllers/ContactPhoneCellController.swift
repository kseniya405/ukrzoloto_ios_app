//
//  ContactPhoneCellController.swift
//  UkrZoloto
//
//  Created by user on 28.08.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol ContactPhoneCellControllerDelegate: AnyObject {
  func didTapOnPhone()
}

class ContactPhoneCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: ContactPhoneCellControllerDelegate?
  
  var productsView: PhoneNumberContactView? {    
    get { return view as? PhoneNumberContactView }
    set { view = newValue }
  }
  
  private(set) var info = ImageTitleSubtitleViewModel(title: "", subtitle: "", image: nil)
  
  // MARK: - Configure
  override func setupView() {
    super.setupView()
    updateInfo()
    productsView?.delegate = self
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

// MARK: - PhoneNumberTableViewCellDelegate
extension ContactPhoneCellController: PhoneNumberTableViewCellDelegate {
  func didTapOnPhone() {
    delegate?.didTapOnPhone()
  }
}
