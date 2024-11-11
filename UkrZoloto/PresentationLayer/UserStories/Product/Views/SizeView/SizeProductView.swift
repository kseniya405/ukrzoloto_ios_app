//
//  SizeProductView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 26.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class SizeProductView: InitView {
  
  // MARK: - Public variables
  weak var collectionController: (UICollectionViewDataSource & UICollectionViewDelegate)? {
    didSet {
      sizeCollectionView.dataSource = collectionController
      sizeCollectionView.delegate = collectionController
    }
  }
  
  // MARK: - Private variables
  private let chooseSizeLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.ChooseSizeLabel.height
    label.config
      .font(UIConstants.ChooseSizeLabel.font)
      .textColor(UIConstants.ChooseSizeLabel.color)
      .numberOfLines(UIConstants.ChooseSizeLabel.numberOfLines)
    return label
  }()

  private let currentSizeLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.CurrentSizeLabel.height
    label.config
      .font(UIConstants.CurrentSizeLabel.font)
      .textColor(UIConstants.CurrentSizeLabel.color)
      .numberOfLines(UIConstants.CurrentSizeLabel.numberOfLines)
    return label
  }()

  private let currentSizeValueLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.CurrentSizeValueLabel.height
    label.config
      .font(UIConstants.CurrentSizeValueLabel.font)
      .textColor(UIConstants.CurrentSizeValueLabel.color)
      .numberOfLines(UIConstants.CurrentSizeValueLabel.numberOfLines)
    return label
  }()

  private let currentWeightLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.CurrentWeightLabel.height
    label.config
      .font(UIConstants.CurrentWeightLabel.font)
      .textColor(UIConstants.CurrentWeightLabel.color)
      .numberOfLines(UIConstants.CurrentWeightLabel.numberOfLines)
    return label
  }()

  private let currentWeightValueLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.CurrentWeightValueLabel.height
    label.config
      .font(UIConstants.CurrentWeightValueLabel.font)
      .textColor(UIConstants.CurrentWeightValueLabel.color)
      .numberOfLines(UIConstants.CurrentWeightValueLabel.numberOfLines)
    return label
  }()
  
  private let knowSizeButton = RightImageButton()
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private let sizeCollectionView = UICollectionView(frame: .zero,
                                                    collectionViewLayout: UICollectionViewLayout())
  
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureChooseSizeLabel()
    configureButton()
    configureCollectionView()
    configureCurrentSizeLabel()
    configureCurrentWeightLabel()
  }
  
  private func configureSelfView() {
    
  }
  
  private func configureChooseSizeLabel() {
    addSubview(chooseSizeLabel)
    chooseSizeLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(UIConstants.ChooseSizeLabel.leading)
    }
  }
  
  private func configureButton() {
    knowSizeButton.setImage(UIConstants.Button.image, for: .normal)
    knowSizeButton.textFont = UIConstants.Button.font
    knowSizeButton.textColor = UIConstants.Button.color
    
    addSubview(knowSizeButton)
    knowSizeButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.greaterThanOrEqualTo(chooseSizeLabel.snp.trailing)
        .offset(UIConstants.Button.leading)
      make.height.equalTo(UIConstants.Button.height)
      make.trailing.equalToSuperview()
        .inset(UIConstants.Button.trailing)
      make.width.greaterThanOrEqualTo(UIConstants.Button.width)
    }
  }
  
  private func configureCollectionView() {
    addSubview(sizeCollectionView)
    sizeCollectionView.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(knowSizeButton.snp.bottom)
        .offset(UIConstants.CollectionView.top)
      make.top.greaterThanOrEqualTo(chooseSizeLabel.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(UIConstants.CollectionView.height)
    }

    sizeCollectionView.contentInset.left = UIConstants.CollectionView.horizontalInset
    sizeCollectionView.contentInset.right = UIConstants.CollectionView.horizontalInset
    sizeCollectionView.isPagingEnabled = false
    sizeCollectionView.showsHorizontalScrollIndicator = false
    sizeCollectionView.showsVerticalScrollIndicator = false
    sizeCollectionView.decelerationRate = .fast
    sizeCollectionView.clipsToBounds = false
    sizeCollectionView.backgroundColor = UIConstants.CollectionView.backgroundColor
    
    collectionViewLayout.scrollDirection = .horizontal
    collectionViewLayout.minimumInteritemSpacing = UIConstants.CollectionView.interitemSpacing
    collectionViewLayout.minimumLineSpacing = UIConstants.CollectionView.interitemSpacing
    collectionViewLayout.estimatedItemSize = CGSize(width: 20, height: 20)
    sizeCollectionView.collectionViewLayout = collectionViewLayout
    sizeCollectionView.allowsMultipleSelection = false
    sizeCollectionView.register(SizeCollectionViewCell.self,
                                reuseIdentifier: SizeCollectionViewCell.reuseID)
  }

  private func configureCurrentSizeLabel() {
    addSubview(currentSizeLabel)
    currentSizeLabel.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(sizeCollectionView.snp.bottom).offset(UIConstants.CurrentSizeLabel.top)
      make.leading.equalToSuperview().offset(UIConstants.CurrentSizeLabel.leading)
      make.height.equalTo(UIConstants.CurrentSizeLabel.height)
      make.bottom.equalToSuperview()
    }

    addSubview(currentSizeValueLabel)
    currentSizeValueLabel.snp.makeConstraints { make in
      make.centerY.equalTo(currentSizeLabel.snp.centerY)
      make.height.equalTo(UIConstants.CurrentSizeValueLabel.height)
      make.leading.equalTo(currentSizeLabel.snp.trailing).offset(UIConstants.CurrentSizeValueLabel.leading)
    }
  }

  private func configureCurrentWeightLabel() {
    addSubview(currentWeightLabel)
    currentWeightLabel.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(sizeCollectionView.snp.bottom).offset(UIConstants.CurrentWeightLabel.top)
      make.height.equalTo(UIConstants.CurrentWeightLabel.height)
      make.leading.equalTo(currentSizeValueLabel.snp.trailing).offset(UIConstants.CurrentWeightLabel.leading)
    }

    addSubview(currentWeightValueLabel)
    currentWeightValueLabel.snp.makeConstraints { make in
      make.centerY.equalTo(currentWeightLabel.snp.centerY)
      make.height.equalTo(UIConstants.CurrentWeightValueLabel.height)
      make.leading.equalTo(currentWeightLabel.snp.trailing).offset(UIConstants.CurrentWeightValueLabel.leading)
    }
  }
  
  // MARK: - Interface
  func updateViewStateWith(_ variant: Variant?, product: Product?) {
    knowSizeButton.setTitle("Узнать свой размер".localized(),
                            for: .normal)
    chooseSizeLabel.text = "Выберите размер".localized()
    currentSizeLabel.text = "Размер".localized()
    currentWeightLabel.text = "Вес изделия".localized()

    if let product = product {
      knowSizeButton.isHidden = product.shouldHideKnowSize()
    }

    if let variantSize = variant?.size {
      currentSizeValueLabel.text = variantSize.title
    }

    if let variantWeight = variant?.properties.first(where: { $0.code == "weight_product" })?.title {
      currentWeightLabel.isHidden = false
      currentWeightValueLabel.isHidden = false
      currentWeightValueLabel.text = variantWeight + " г"
    } else {
      currentWeightLabel.isHidden = true
      currentWeightValueLabel.isHidden = true
    }
  }

  func showOnlyWieght(_ variant: Variant?) {
    if let variantWeight = variant?.properties.first(where: { $0.code == "weight_product" })?.title {
      self.subviews.forEach { $0.removeFromSuperview() }

      currentWeightLabel.isHidden = false
      currentWeightValueLabel.isHidden = false
      currentWeightValueLabel.text = variantWeight + " г"

      addSubview(currentWeightLabel)
      currentWeightLabel.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(-10)
        make.bottom.equalToSuperview()
        make.leading.equalToSuperview().offset(16)
        make.height.equalTo(35)
      }

      addSubview(currentWeightValueLabel)
      currentWeightValueLabel.snp.makeConstraints { make in
        make.centerY.equalTo(currentWeightLabel.snp.centerY)
        make.height.equalTo(UIConstants.CurrentWeightValueLabel.height)
        make.leading.equalTo(currentWeightLabel.snp.trailing).offset(UIConstants.CurrentWeightValueLabel.leading)
      }

      self.setNeedsUpdateConstraints()
      self.layoutIfNeeded()
    }
  }
  
  func getSizeCollectionView() -> UICollectionView {
    return sizeCollectionView
  }
  
  func getKnowSizeButton() -> UIButton {
    return knowSizeButton
  }

  func getCurrentSizeValueLabel() -> UILabel {
    return currentSizeValueLabel
  }

  func getCurrentWeightValueLabel() -> UILabel {
    return currentWeightValueLabel
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum ChooseSizeLabel {
    static let font = UIFont.regularAppFont(of: 13)
    static let height: CGFloat = 18
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let numberOfLines: Int = 0
    
    static let top: CGFloat = 0
    static let leading: CGFloat = 16
  }

  enum CurrentSizeLabel {
    static let font = UIFont.regularAppFont(of: 14)
    static let height: CGFloat = 20
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let numberOfLines: Int = 0

    static let top: CGFloat = 10
    static let leading: CGFloat = 16
  }

  enum CurrentSizeValueLabel {
    static let font = UIFont.boldAppFont(of: 14.0)
    static let height: CGFloat = 20
    static let color = UIColor.color(r: 0, g: 80, b: 47)
    static let numberOfLines: Int = 0

    static let top: CGFloat = 10
    static let leading: CGFloat = 5
  }

  enum CurrentWeightLabel {
    static let font = UIFont.regularAppFont(of: 14)
    static let height: CGFloat = 20
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let numberOfLines: Int = 0

    static let top: CGFloat = 10
    static let leading: CGFloat = 20
  }

  enum CurrentWeightValueLabel {
    static let font = UIFont.boldAppFont(of: 14.0)
    static let height: CGFloat = 20
    static let color = UIColor.color(r: 0, g: 80, b: 47)
    static let numberOfLines: Int = 0

    static let top: CGFloat = 10
    static let leading: CGFloat = 5
  }
  
  enum Button {
    static let font = UIFont.regularAppFont(of: 13)
    static let color = UIColor.color(r: 0, g: 80, b: 47)
    static let image = #imageLiteral(resourceName: "greenRightArrow")
    
    static let leading: CGFloat = 5
    static let trailing: CGFloat = 20
    static let height: CGFloat = 22
    static let width: CGFloat = 170
  }
  
  enum CollectionView {
    static let top: CGFloat = 13
    static let height: CGFloat = 36
    static let backgroundColor = UIColor.white
    
    static let horizontalInset: CGFloat = 16
    static let interitemSpacing: CGFloat = 8
  }
}
