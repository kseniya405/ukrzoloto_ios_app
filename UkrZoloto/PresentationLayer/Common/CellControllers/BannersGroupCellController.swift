//
//  BannersGroupCellController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/18/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol BannersGroupCellControllerDelegate: AnyObject {
  func bannerCellController(_ controller: BannersGroupCellController, didSelectBannerAt index: Int)
}

class BannersGroupCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: BannersGroupCellControllerDelegate?
  
  var compilationsView: BannersGroupView? {
    set { view = newValue }
    get { return view as? BannersGroupView }
  }
  
  private(set) var title: String?
  
  private(set) var banners = [BannerViewModel]()
  
  private var collectionViewController = AUICollectionViewController()
  private var bannerControllers: [AUIElementCollectionViewCellController] = []
  private var associatedImageViewModels: [ASTHashedReference: BannerViewModel] = [:]
  
  private var selectedIndex: Int?
  
  // MARK: - Configure
  override func setupView() {
    super.setupView()
    let collectionView = compilationsView?.getCollectionView()
    collectionView?.register(AUIReusableCollectionCell.self,
                             forCellWithReuseIdentifier: UIConstants.ReuseIdentifiers.imageViewCell)
    collectionViewController.collectionView = collectionView
    setTitle(title)
    setBanners(banners)
  }
  
  override func unsetupView() {
    super.unsetupView()
    collectionViewController.collectionView = nil
  }
  
  // MARK: - Interface
  
  func setTitle(_ title: String?) {
    self.title = title
    compilationsView?.setTitle(title)
  }
  
  func setBanners(_ banners: [BannerViewModel]) {
    self.banners = banners
    updateBanners()
  }
  
  func createImageViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    let cell: AUIReusableCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.imageViewCell,
                                                                             for: indexPath)
    cell.setCellCreateViewBlock { CardImageView() }
    cell.setupUI()
    return cell
  }
  
  // MARK: - Actions
  private func updateBanners() {
    let currentBannerControllers = bannerControllers
    var newBannerControllers: [AUIElementCollectionViewCellController] = []
    var newAssociatedImageViewModels: [ASTHashedReference: BannerViewModel] = [:]
    
    banners.enumerated().forEach { (index, bannerViewModel) in
      if index < currentBannerControllers.count {
        let existingController = currentBannerControllers[index]
        if let existingViewModel = associatedImageViewModels[ASTHashedReference(existingController)],
           existingViewModel != bannerViewModel {
          if let imageController = existingController.controller as? CardImageViewController {
            imageController.imageViewModel = bannerViewModel.image
          }
        }
        newBannerControllers.append(existingController)
        newAssociatedImageViewModels[ASTHashedReference(existingController)] = bannerViewModel
      } else {
        let imageController = CardImageViewController()
        imageController.imageViewModel = bannerViewModel.image
        
        let bannerController = AUIElementCollectionViewCellController(controller: imageController,
                                                                      cellCreateBlock: createImageViewCell)
        bannerController.didSelectDelegate = self
        newBannerControllers.append(bannerController)
        newAssociatedImageViewModels[ASTHashedReference(bannerController)] = bannerViewModel
      }
    }
    
    bannerControllers = newBannerControllers
    associatedImageViewModels = newAssociatedImageViewModels
    
    collectionViewController.cellControllers = newBannerControllers
    collectionViewController.reload()
    compilationsView?.setNeedsUpdateConstraints()
  }
}

private enum UIConstants {
  enum ReuseIdentifiers {
    static let imageViewCell = "imageViewCell"
  }
}

// MAR: - AUICollectionViewCellControllerDelegate
extension BannersGroupCellController: AUICollectionViewCellControllerDelegate {
  func didSelectCollectionViewCellController(_ cellController: AUICollectionViewCellController) {
    if let selectedViewModel = associatedImageViewModels[ASTHashedReference(cellController)],
       let index = banners.firstIndex(of: selectedViewModel) {
      delegate?.bannerCellController(self, didSelectBannerAt: index)
    }
  }
}
