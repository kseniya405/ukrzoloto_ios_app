//
//  ProductsGroupView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/17/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit

class ProductsGroupView: UIView {
  
  // MARK: - Private variables
  private let collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewLayout())
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private let titleLabel = UILabel()
  private let showMoreButton = GreyButton()
  private var titleLabelToTopConstraint: Constraint?
  private var collectionViewHeightConstraint: Constraint?
  private var collectionViewToTopConstraint: Constraint?
  private var collectionViewToBottomConstraint: Constraint?
  private var showMoreButtonToBottomConstraint: Constraint?
  private var needsUpdateCollectionViewHeight = true
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    _ = collectionView.numberOfItems(inSection: 0)
    let hasTitleLabel = !titleLabel.isHidden
    let hasShowMoreButton = !showMoreButton.isHidden
    
    if needsUpdateCollectionViewHeight {
        updateCollectionViewHeight()  // Викликаємо метод для оновлення висоти
    }

    CATransaction.begin()
    CATransaction.setDisableActions(true)
    collectionViewToTopConstraint?.isActive = !hasTitleLabel
    titleLabelToTopConstraint?.isActive = hasTitleLabel
    collectionViewToBottomConstraint?.isActive = !hasShowMoreButton
    showMoreButtonToBottomConstraint?.isActive = hasShowMoreButton
    CATransaction.commit()
    super.updateConstraints()
  }
  
  override func layoutSubviews() {
      super.layoutSubviews()
      collectionViewLayout.itemSize = CGSize(width: CachedSizes.cellWidth,
                                             height: UIConstants.CollectionView.cellHeight)
  }
  
  deinit {
      collectionView.delegate = nil
      collectionView.dataSource = nil
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureTitleLabel()
    configureCollectionView()
    configureShowMoreButton()
    titleLabelToTopConstraint?.isActive = false
    setTitle(nil)
    showMoreButtonToBottomConstraint?.isActive = false
    setShowMoreTitle(nil)
  }
  
  private func configureTitleLabel() {
    titleLabel.config
      .font(UIConstants.TitleLabel.font)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
      .textColor(UIConstants.TitleLabel.textColor)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      titleLabelToTopConstraint = make.top.equalToSuperview().offset(UIConstants.TitleLabel.top).constraint
      make.leading.trailing.equalToSuperview().inset(UIConstants.TitleLabel.left)
    }
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func updateCollectionViewHeight() {
      let itemCount = collectionView.numberOfItems(inSection: 0)
      let rowsCount = CGFloat(itemCount / 2 + itemCount % 2)  // Ділимо на два, щоб визначити кількість рядків
      let height = rowsCount * UIConstants.CollectionView.cellHeight +
                   (rowsCount - 1) * UIConstants.CollectionView.interitemSpacing
      collectionViewHeightConstraint?.update(offset: height)
      needsUpdateCollectionViewHeight = false
  }
  
  private func configureCollectionView() {
    collectionView.backgroundColor = UIConstants.CollectionView.backgroundColor
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.CollectionView.top)
      collectionViewToTopConstraint = make.top.equalToSuperview().priority(999).constraint
      collectionViewHeightConstraint = make.height.equalTo(UIConstants.CollectionView.height).constraint
      collectionViewToBottomConstraint = make.bottom.equalToSuperview().constraint
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
  
  private func configureShowMoreButton() {
    addSubview(showMoreButton)
    showMoreButton.snp.makeConstraints { make in
      make.top.equalTo(collectionView.snp.bottom).offset(UIConstants.ShowMoreButton.top)
      make.left.right.equalToSuperview().inset(UIConstants.ShowMoreButton.left)
      make.height.equalTo(UIConstants.ShowMoreButton.height)
      showMoreButtonToBottomConstraint = make.bottom.equalToSuperview()
        .inset(UIConstants.ShowMoreButton.bottom)
        .priority(999).constraint
    }
  }
  
  // MARK: - Interface
  
  func setTitle(_ title: String?) {
    titleLabel.text = title
    titleLabel.isHidden = title == nil
    setNeedsUpdateConstraints()
  }
  
  func setShowMoreTitle(_ title: String?) {
    showMoreButton.setTitle(title, for: .normal)
    showMoreButton.isHidden = title == nil
    setNeedsUpdateConstraints()
  }
  
  func getCollectionView() -> UICollectionView {
    return collectionView
  }
  
  func getShowMoreButton() -> UIButton {
    return showMoreButton
  }
  
  private struct CachedSizes {
      static let cellWidth: CGFloat = {
          let screenWidth = UIScreen.main.bounds.width
          return (screenWidth - 2 * UIConstants.CollectionView.horizontalInset - UIConstants.CollectionView.interitemSpacing) / 2
      }()

      static let cellSize = CGSize(
          width: cellWidth,
          height: UIConstants.CollectionView.cellHeight
      )
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
    
    static let cellAspect: CGFloat = Constants.Screen.widthCoefficient >= 1 ? 16.0 / 9.0 : 17.0 / 9
    static let cellWidth: CGFloat = (width - 2 * horizontalInset - interitemSpacing) / 2
    static let cellHeight: CGFloat = 302 // OLD SOLUTION MUST BE REWISED //(cellWidth * cellAspect).rounded()
    static let backgroundColor = UIColor.clear
  }
  
  enum TitleLabel {
    static let top: CGFloat = 20
    static let left: CGFloat = 16
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.boldAppFont(of: 22)
    static let textAlignment = NSTextAlignment.left
    static let numberOfLines = 0
  }
  
  enum ShowMoreButton {
    static let top: CGFloat = 30
    static let left: CGFloat = 16
    static let height: CGFloat = 48
    static let bottom: CGFloat = 20
  }
}
