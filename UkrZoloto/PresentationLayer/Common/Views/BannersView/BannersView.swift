//
//  BannersView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class BannersView: UIView {
  
  // MARK: - Private variables
  private let collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewLayout())
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private let pageControl = UIPageControl()
  
  private var collectionViewHeight: CGFloat
  
  private var isPageInside: Bool = false
  private var cellAspect: CGFloat = 9.0 / 16.0
  
  // MARK: - Life cycle
  init(isPageInside: Bool = false, cellAspect: CGFloat = 9.0 / 16.0) {
    self.cellAspect = cellAspect
    collectionViewHeight = (Constants.Screen.screenWidth * cellAspect).rounded()
    self.isPageInside = isPageInside
    super.init(frame: .zero)
    initConfigure()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let height = (bounds.width * cellAspect).rounded()
    collectionViewLayout.itemSize = CGSize(width: bounds.width,
                                           height: height)
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureCollectionView()
    isPageInside ? configureInsidePageControl() : configurePageControl()
  }
  
  private func configureCollectionView() {
    collectionView.backgroundColor = UIConstants.CollectionView.backgroundColor
    collectionView.contentInsetAdjustmentBehavior = .never
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(collectionViewHeight)
      if isPageInside {
        make.bottom.equalToSuperview()
      }
    }
    collectionViewLayout.scrollDirection = .horizontal
    collectionView.collectionViewLayout = collectionViewLayout
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionViewLayout.minimumInteritemSpacing = 0
    collectionViewLayout.minimumLineSpacing = 0
  }
  
  private func configurePageControl() {
    pageControl.pageIndicatorTintColor = UIConstants.PageControl.indicatorTintColor
    pageControl.currentPageIndicatorTintColor = UIConstants.PageControl.currentIndicatorTintColor
    addSubview(pageControl)
    pageControl.snp.makeConstraints { make in
      make.top.equalTo(collectionView.snp.bottom).offset(UIConstants.PageControl.top)
      make.height.equalTo(UIConstants.PageControl.height)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    pageControl.hidesForSinglePage = true
  }
  
  private func configureInsidePageControl() {
    pageControl.pageIndicatorTintColor = UIConstants.PageControl.indicatorTintColor
    pageControl.currentPageIndicatorTintColor = UIConstants.PageControl.currentIndicatorTintColor
    addSubview(pageControl)
    pageControl.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.PageControl.height)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    pageControl.hidesForSinglePage = true
  }
  
  // MARK: - Interface
  func getCollectionView() -> UICollectionView {
    return collectionView
  }
  
  func getPageControl() -> UIPageControl {
    return pageControl
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum CollectionView {
    static let width = Constants.Screen.screenWidth
    static let backgroundColor = UIColor.clear
  }
  
  enum PageControl {
    static let top: CGFloat = 5
    static let height: CGFloat = 44
    static let indicatorTintColor = UIColor.color(r: 0, g: 0, b: 0, a: 0.2)
    static let currentIndicatorTintColor = UIColor.color(r: 0, g: 80, b: 47)
  }
}
