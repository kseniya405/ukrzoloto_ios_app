//
//  CompilationsCellController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/15/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol CompilationsCellControllerDelegate: AnyObject {
  func compilationsCellController(_ controller: CompilationsCellController, didSelectCompilationAt index: Int)
}

class CompilationsCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: CompilationsCellControllerDelegate?
  
  var compilationsView: CompilationsView? {
    set { view = newValue }
    get { return view as? CompilationsView }
  }
  
  private(set) var title: String?
  private(set) var banners = [BannerViewModel]()
  private(set) var currentIndex = 0
  
  private var collectionViewController = AUICollectionViewController()
  private var bannerControllers: [AUIElementCollectionViewCellController] = []
  private var associatedImageViewModels: [ASTHashedReference: BannerViewModel] = [:]
  
  // MARK: - Configure
  override func setupView() {
    super.setupView()
    let collectionView = compilationsView?.getCollectionView()
    collectionView?.register(AUIReusableCollectionCell.self,
                             forCellWithReuseIdentifier: UIConstants.ReuseIdentifiers.imageViewCell)
    collectionViewController.collectionView = collectionView
    setTitleAndBanners(title: title, banners: banners, currentIndex: currentIndex)
  }
  
  override func unsetupView() {
    super.unsetupView()
    collectionViewController.collectionView = nil
  }
  
  override func setup() {
    super.setup()
    collectionViewController.scrollDelegate = self
  }
  
  // MARK: - Interface
  
  func setTitleAndBanners(title: String?, banners: [BannerViewModel], currentIndex: Int) {
    self.title = title
    self.banners = banners
    compilationsView?.setTitle(title)
    updateBanners()
    
    if currentIndex < banners.count {
      self.currentIndex = currentIndex
      updateCurrentIndex()
    }
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
    if bannerControllers.isEmpty {
      associatedImageViewModels = [:]
      bannerControllers = banners.map { bannerViewModel in
        let imageController = CardImageViewController()
        imageController.imageViewModel = bannerViewModel.image
        
        let bannerController = AUIElementCollectionViewCellController(controller: imageController,
                                                                      cellCreateBlock: createImageViewCell)
        bannerController.didSelectDelegate = self
        associatedImageViewModels[ASTHashedReference(bannerController)] = bannerViewModel
        return bannerController
      }
    } else {
      // Оновлюємо лише змінені банери, не створюючи нові контролери
      banners.enumerated().forEach { (index, bannerViewModel) in
        if index < bannerControllers.count {
          let existingController = bannerControllers[index]
          if let existingViewModel = associatedImageViewModels[ASTHashedReference(existingController)],
             existingViewModel != bannerViewModel {
            if let imageController = existingController.controller as? CardImageViewController {
              imageController.imageViewModel = bannerViewModel.image
            }
          }
        } else {
          // Створюємо нові контролери для нових банерів
          let imageController = CardImageViewController()
          imageController.imageViewModel = bannerViewModel.image
          let bannerController = AUIElementCollectionViewCellController(controller: imageController,
                                                                        cellCreateBlock: createImageViewCell)
          bannerController.didSelectDelegate = self
          bannerControllers.append(bannerController)
          associatedImageViewModels[ASTHashedReference(bannerController)] = bannerViewModel
        }
      }
    }
    
    collectionViewController.cellControllers = bannerControllers
    collectionViewController.reload()
  }
  
  private func updateCurrentIndex() {
    guard let collectionView = compilationsView?.getCollectionView() else { return }
    if currentIndex < banners.count {
      collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0),
                                  at: .centeredHorizontally,
                                  animated: false)
    }
  }
}

private enum UIConstants {
  enum ReuseIdentifiers {
    static let imageViewCell = "imageViewCell"
  }
}

// MARK: - AUIScrollViewDelegate
extension CompilationsCellController: AUIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) { }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) { }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let newIndex = Int((scrollView.contentOffset.x + scrollView.contentInset.left) / (scrollView.frame.size.width - 3 * scrollView.contentInset.left))
    if newIndex != currentIndex {
      currentIndex = newIndex
      updateCurrentIndex()
    }
  }
}

// MARK: - AUICollectionViewCellControllerDelegate
extension CompilationsCellController: AUICollectionViewCellControllerDelegate {
  func didSelectCollectionViewCellController(_ cellController: AUICollectionViewCellController) {
    if let selectedViewModel = associatedImageViewModels[ASTHashedReference(cellController)],
       let index = banners.firstIndex(of: selectedViewModel) {
      delegate?.compilationsCellController(self, didSelectCompilationAt: index)
    }
  }
}
