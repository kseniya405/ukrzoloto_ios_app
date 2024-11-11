//
//  ImageViewCellController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol ImageViewCellControllerDelegate: AnyObject {
  func didTapOnImageView(from controller: ImageViewCellController)
}

class ImageViewCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: ImageViewCellControllerDelegate?
  
  var imageView: UIImageView? {
    get { return view as? UIImageView }
    set { view = newValue }
  }
  
  var imageViewModel: ImageViewModel? {
    didSet { didSetViewModel() }
  }
  
  // MARK: - Private variables
  private var gesture: UITapGestureRecognizer?
  
  // MARK: - Actions
  private func didSetViewModel() {
    if let imageViewModel = imageViewModel {
      imageView?.setImage(from: imageViewModel)

      addTapGesture()
    } else {
      imageView?.image = nil

      removeTapGesture()
    }
  }
  
  override func setupView() {
    super.setupView()

    didSetViewModel()
  }
  
  override func unsetupView() {
    removeTapGesture()

    super.unsetupView()
  }

  private func addTapGesture() {
    guard imageView?.gestureRecognizers?.first == nil else { return }

    let gesture = UITapGestureRecognizer(target: self,
                                     action: #selector(didTapOnImageView))
    imageView?.addGestureRecognizer(gesture)
    imageView?.isUserInteractionEnabled = true
  }

  private func removeTapGesture() {
    guard let tapGesture = imageView?.gestureRecognizers?.first else { return }

    imageView?.removeGestureRecognizer(tapGesture)
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnImageView() {
    delegate?.didTapOnImageView(from: self)
  }
}
