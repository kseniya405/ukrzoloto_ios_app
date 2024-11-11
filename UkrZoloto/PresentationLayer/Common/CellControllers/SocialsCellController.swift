//
//  SocialsCellController.swift
//  UkrZoloto
//
//  Created by user on 31.08.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol SocialsCellControllerDelegate: AnyObject {
  func didTapOnImage(with index: Int)
}

class SocialsCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: SocialsCellControllerDelegate?
  
  var productsView: ImageTitleImagesView? {
    set { view = newValue }
    get { return view as? ImageTitleImagesView }
  }
  
  private(set) var info = ImageTitleImagesViewModel(title: "", image: nil, images: [])
  
  // MARK: - Configure
  override func setupView() {
    super.setupView()
    updateInfo()
    productsView?.delegate = self
  }
  
  // MARK: - Interface
  func setInfo(_ info: ImageTitleImagesViewModel) {
    self.info = info
    updateInfo()
  }
  
  // MARK: - Actions
  private func updateInfo() {
    productsView?.configure(viewModel: info)
  }
}

// MARK: - ImageTitleImagesTableViewCellDelegate
extension SocialsCellController: ImageTitleImagesTableViewCellDelegate {
  func didTapOnImage(with index: Int) {
    delegate?.didTapOnImage(with: index)
  }
}
