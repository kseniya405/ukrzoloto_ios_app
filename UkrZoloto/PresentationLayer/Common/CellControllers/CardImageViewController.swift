//
//  CardImageViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/15/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class CardImageViewController: AUIDefaultViewController {

  // MARK: - Public variables
  var cardImageView: CardImageView? {
    set { view = newValue }
    get { return view as? CardImageView }
  }
  
  var imageViewModel: ImageViewModel? {
    didSet { didSetViewModel() }
  }
  
  // MARK: - Actions
  private func didSetViewModel() {
    cardImageView?.setImage(imageViewModel)
  }
  
  override func setupView() {
    super.setupView()
    didSetViewModel()
  }
}
