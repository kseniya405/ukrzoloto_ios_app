//
//  BannersCellController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol BannersCellControllerDelegate: AnyObject {
  func bannerCellController(_ controller: BannersCellController, didSelectBannerAt index: Int)
}

class BannersCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: BannersCellControllerDelegate?
  
  var bannersView: BannersView? {
    get { return view as? BannersView }
    set { view = newValue }
  }
  
  var currentIndex: Int = 0 {
    didSet { didSetCurrentIndex() }
  }
  
  private(set) var banners: [BannerViewModel] = [] {
    didSet { didSetBanners() }
  }
  
  // MARK: - Private variables
  private let cornerRadius: CGFloat
  private var collectionViewController = AUICollectionViewController()
  private var bannerControllers: [AUIElementCollectionViewCellController] = []
  private var associatedImageViewModels: [ASTHashedReference: BannerViewModel] = [:]
  
  // MARK: - Life cycle
  init(cornerRadius: CGFloat = UIConstants.ImageView.cornerRadius) {
    self.cornerRadius = cornerRadius
    super.init()
  }
  
  // MARK: - Configure
  override func setupView() {
    super.setupView()
    let collectionView = bannersView?.getCollectionView()
    collectionView?.register(AUIReusableCollectionCell.self,
                             forCellWithReuseIdentifier: UIConstants.ReuseIdentifiers.imageViewCell)
    collectionViewController.collectionView = collectionView
    bannersView?.getPageControl().addTarget(self,
                                            action: #selector(pageControlChanged),
                                            for: .valueChanged)
    setBanners(banners, currentIndex: currentIndex)
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
  
  func setBanners(_ banners: [BannerViewModel], currentIndex: Int) {
    self.banners = banners
    if currentIndex < banners.count {
      self.currentIndex = currentIndex
    }
  }
  
  func createImageViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    let cell: AUIReusableCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.imageViewCell,
                                                                             for: indexPath)
    cell.setCellCreateViewBlock(createImageView)
    cell.setupUI()
    return cell
  }
  
  // MARK: - Actions
  private func didSetBanners() {
    bannerControllers = []
    associatedImageViewModels = [:]
    
    bannerControllers = banners.map { bannerViewModel in
      let imageController = ImageViewCellController()
      imageController.imageViewModel = bannerViewModel.image
      imageController.delegate = self
      
      let bannerController = AUIElementCollectionViewCellController(controller: imageController,
                                                                    cellCreateBlock: createImageViewCell)
      associatedImageViewModels[ASTHashedReference(imageController)] = bannerViewModel
      return bannerController
    }
    
    collectionViewController.cellControllers = bannerControllers
    collectionViewController.reload()
    bannersView?.getPageControl().numberOfPages = banners.count
  }
  
  private func didSetCurrentIndex() {
    guard let collectionView = bannersView?.getCollectionView() else { return }
    if currentIndex < banners.count,
       !collectionView.visibleCells.contains(where: { collectionView.indexPath(for: $0)?.row == currentIndex }) {
      collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0),
                                  at: .centeredHorizontally,
                                  animated: false)
    }
    bannersView?.getPageControl().currentPage = currentIndex
  }
  
  private func createImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = UIConstants.ImageView.backgroundColor
    imageView.layer.cornerRadius = cornerRadius
    imageView.clipsToBounds = true
    return imageView
  }
  
  @objc
  private func pageControlChanged() {
    guard let index = bannersView?.getPageControl().currentPage else { return }
    currentIndex = index
  }
}

private enum UIConstants {
  enum ReuseIdentifiers {
    static let imageViewCell = "imageViewCell"
  }
  
  enum ImageView {
    static let backgroundColor = UIColor.clear
    static let cornerRadius: CGFloat = 16
  }
}

// MARK: - AUIScrollViewDelegate
extension BannersCellController: AUIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) { }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) { }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
  }
}

// MARK: - ImageViewCellControllerDelegate
extension BannersCellController: ImageViewCellControllerDelegate {
  func didTapOnImageView(from controller: ImageViewCellController) {
    if let selectedViewModel = associatedImageViewModels[ASTHashedReference(controller)],
       let index = banners.firstIndex(of: selectedViewModel) {
      delegate?.bannerCellController(self, didSelectBannerAt: index)
    }
  }
}
