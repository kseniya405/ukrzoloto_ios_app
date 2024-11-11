//
//  MultiSelectView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 08.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class MultiSelectView: InitView {
  
  // MARK: - Public variables

  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.lineHeight
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
    
    return label
  }()
  
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private let filterCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewLayout())
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTitleLabel()
    configureCollectionView()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.Title.inset)
    }
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureCollectionView() {
    addSubview(filterCollectionView)
    filterCollectionView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.Collection.top)
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(UIConstants.Collection.height)
    }
    filterCollectionView.contentInset.left = UIConstants.Collection.horizontalInset
    filterCollectionView.contentInset.right = UIConstants.Collection.horizontalInset
    filterCollectionView.isPagingEnabled = false
    filterCollectionView.showsHorizontalScrollIndicator = false
    filterCollectionView.showsVerticalScrollIndicator = false
    filterCollectionView.decelerationRate = .fast
    filterCollectionView.clipsToBounds = false
    filterCollectionView.backgroundColor = UIConstants.Collection.backgroundColor
    
    collectionViewLayout.scrollDirection = .horizontal
    collectionViewLayout.minimumInteritemSpacing = 0
    collectionViewLayout.minimumLineSpacing = UIConstants.Collection.interitemSpacing
    collectionViewLayout.estimatedItemSize = CGSize(width: 20, height: 20)
    
    filterCollectionView.collectionViewLayout = collectionViewLayout
    filterCollectionView.allowsMultipleSelection = true
  }
  
  // MARK: - Interface
  func setTitle(_ title: String?) {
    titleLabel.text = title
  }
  
  func getCollectionView() -> UICollectionView {
    return filterCollectionView
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum Title {
    static let font = UIFont.boldAppFont(of: 18)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let lineHeight: CGFloat = 21.6
    
    static let inset: CGFloat = 24
  }
  
  enum Collection {
    static let top: CGFloat = 24
    static let height: CGFloat = 40
    
    static let backgroundColor = UIColor.clear
    static let horizontalInset: CGFloat = 24
    static let interitemSpacing: CGFloat = 8
  }
  
}
