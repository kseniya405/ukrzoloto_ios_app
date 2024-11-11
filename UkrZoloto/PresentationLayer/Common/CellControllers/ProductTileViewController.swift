//
//  ProductTileViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/17/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol ProductTileViewControllerDelegate: AnyObject {
  func changeFavoriteState(for tileViewModel: ProductTileViewModel)
  func openDiscountHint(for tileViewModel: ProductTileViewModel)
}

class ProductTileViewController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: ProductTileViewControllerDelegate?
  
  var tileView: ProductTileView? {
    set { view = newValue }
    get { return view as? ProductTileView }
  }
  
  var tileViewModel: ProductTileViewModel? {
    didSet { didSetViewModel() }
  }
  
  // MARK: - Configure
  override func setupView() {
    super.setupView()
    tileView?.getFavoriteButton().addTarget(self, action: #selector(didTapOnFavoriteButton), for: .touchUpInside)
    tileView?.getDiscountHintButton().addTarget(self, action: #selector(didTapOnDiscountHintButton), for: .touchUpInside)

    didSetViewModel()
  }
  
  override func unsetupView() {
    super.unsetupView()
    tileView?.getFavoriteButton().removeTarget(nil, action: nil, for: .touchUpInside)
    tileView?.getDiscountHintButton().removeTarget(nil, action: nil, for: .touchUpInside)
  }
  
  // MARK: - Actions
  private func didSetViewModel() {
    
    tileView?.setImage(tileViewModel?.image)
    tileView?.setTitle(tileViewModel?.title)
    tileView?.setFormattedOldPrice(tileViewModel?.formattedOldPrice)
    tileView?.setFormattedPrice(tileViewModel?.formattedPrice)
    tileView?.setDiscount(tileViewModel?.discountText)
    tileView?.setPromo(tileViewModel?.promo)
    tileView?.getFavoriteButton().setImage(tileViewModel?.favoriteImage, for: .normal)
    tileView?.setCredits(tileViewModel?.credits)
    if let tileViewModel = tileViewModel, !tileViewModel.indicative {
      tileView?.setDiscountHintText(tileViewModel.discountHintText)
      tileView?.setDiscountHintIcon(tileViewModel.discountHintIcon)
    }
  }
  
  @objc
  private func didTapOnFavoriteButton() {
    guard let tileViewModel = tileViewModel else { return }
    delegate?.changeFavoriteState(for: tileViewModel)
  }

  @objc
  private func didTapOnDiscountHintButton() {
    guard let tileViewModel = tileViewModel else { return }
    delegate?.openDiscountHint(for: tileViewModel)
  }
}
