//
//  CompilationsView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/15/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class CompilationsView: UIView {
  
  // MARK: - Private variables
  private let collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewLayout())
  private let collectionViewLayout = CompilationLayout()
  private let titleLabel = UILabel()
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
      collectionView.delegate = nil
      collectionView.dataSource = nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    collectionViewLayout.itemSize = CGSize(width: UIConstants.CollectionView.cellWidth,
                                           height: UIConstants.CollectionView.height)
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
      .textAlignment(UIConstants.TitleLabel.textAlignment)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.TitleLabel.top)
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
      make.height.equalTo(UIConstants.CollectionView.height)
      make.bottom.equalToSuperview()
    }
    collectionView.contentInset.left = UIConstants.CollectionView.horizontalInset
    collectionView.contentInset.right = UIConstants.CollectionView.horizontalInset
    collectionView.isPagingEnabled = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.decelerationRate = .fast
    collectionView.clipsToBounds = false
    
    collectionViewLayout.scrollDirection = .horizontal
    collectionViewLayout.minimumInteritemSpacing = UIConstants.CollectionView.interitemSpacing
    collectionViewLayout.minimumLineSpacing = UIConstants.CollectionView.interitemSpacing
    collectionView.collectionViewLayout = collectionViewLayout
  }
  
  // MARK: - Interface
  func getCollectionView() -> UICollectionView {
    return collectionView
  }
  
  func setTitle(_ title: String?) {
    guard titleLabel.text != title else { return }
    titleLabel.text = title
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
    static let height = (cellWidth / aspect).rounded()
    static let horizontalInset: CGFloat = interitemSpacing + visiblePartWidth
    static let interitemSpacing: CGFloat = 8
    static let visiblePartWidth: CGFloat = 24
    static let cellWidth: CGFloat = (width - 2 * (visiblePartWidth + interitemSpacing))
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
}
