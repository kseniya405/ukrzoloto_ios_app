//
//  BannersGroupView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/18/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

import SnapKit

class BannersGroupView: UIView {
  
  // MARK: - Private variables
  private let collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewLayout())
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private let titleLabel = UILabel()
  private var collectionViewHeightConstraint: Constraint?
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    let itemsCount = collectionView.numberOfItems(inSection: 0)
    if itemsCount == 0 {
      collectionViewHeightConstraint?.update(offset: 0)
    } else {
      let rowsCount = CGFloat(itemsCount / 2 + itemsCount % 2)
      let height = rowsCount * UIConstants.CollectionView.cellHeight + (rowsCount - 1) * UIConstants.CollectionView.interitemSpacing
      collectionViewHeightConstraint?.update(offset: height)
    }
    super.updateConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    collectionViewLayout.itemSize = CGSize(width: UIConstants.CollectionView.cellWidth,
                                           height: UIConstants.CollectionView.cellHeight)
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureTitleLabel()
    configureCollectionView()
  }
  
  private func configureTitleLabel() {
    titleLabel.config
      .font(UIConstants.TitleLabel.font)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
      .textColor(UIConstants.TitleLabel.textColor)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(UIConstants.TitleLabel.left)
    }
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureCollectionView() {
    collectionView.backgroundColor = UIConstants.CollectionView.backgroundColor
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.CollectionView.top)
      collectionViewHeightConstraint = make.height.equalTo(UIConstants.CollectionView.height).constraint
      make.bottom.equalToSuperview()
    }
    collectionView.contentInset.left = UIConstants.CollectionView.horizontalInset
    collectionView.contentInset.right = UIConstants.CollectionView.horizontalInset
    collectionView.isPagingEnabled = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.clipsToBounds = false
    
    collectionViewLayout.scrollDirection = .vertical
    collectionViewLayout.minimumInteritemSpacing = UIConstants.CollectionView.interitemSpacing
    collectionViewLayout.minimumLineSpacing = UIConstants.CollectionView.interitemSpacing
    collectionView.collectionViewLayout = collectionViewLayout
  }
  
  // MARK: - Interface
  
  func setTitle(_ title: String?) {
    titleLabel.text = title
  }
  
  func getCollectionView() -> UICollectionView {
    return collectionView
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum CollectionView {
    static let top: CGFloat = 25
    static let aspect: CGFloat = 16.0 / 9.0
    static let width = Constants.Screen.screenWidth
    static let height = (cellWidth * aspect).rounded()
    
    static let horizontalInset: CGFloat = 16
    static let interitemSpacing: CGFloat = (15 * Constants.Screen.widthCoefficient).rounded()
    
    static let cellAspect: CGFloat = 237.0 / 164.0
    static let cellWidth: CGFloat = (width - 2 * horizontalInset - interitemSpacing) / 2
    static let cellHeight: CGFloat = 302 // (cellWidth / cellAspect).rounded()
    static let backgroundColor = UIColor.clear
  }
  
  enum TitleLabel {
    static let left: CGFloat = 16
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.boldAppFont(of: 22)
    static let textAlignment = NSTextAlignment.left
    static let numberOfLines = 0
  }
}
