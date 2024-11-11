//
//  FeatureView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 29.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

class FeatureView: InitView {
  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.TitleLabel.height
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.textColor)
    
    return label
  }()

  private let collapseButton = UIButton()
  private let horizontalStackView = UIStackView()
  private let verticalStackView = UIStackView()
  private var createdViews = [UIView]()

  private var isCollapsed: Bool = false

  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureTitleLabel()
    configureCollapseButton()
    configureHorizontalStackView()
    configureVerticalStackView()
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(24)
    }
  }

  private func configureCollapseButton() {
    addSubview(collapseButton)

    collapseButton.setTitle("", for: .normal)
    collapseButton.setImage(#imageLiteral(resourceName: "iconsDropDownUp"), for: .normal)

    collapseButton.snp.makeConstraints { make in
      make.height.equalTo(30)
      make.width.equalTo(30)
      make.trailing.equalToSuperview().offset(-16)
      make.centerY.equalTo(titleLabel.snp.centerY)
    }
  }

  private func configureHorizontalStackView() {
    addSubview(horizontalStackView)

    horizontalStackView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.HorizontalStackView.top)
      make.leading.equalToSuperview().offset(16)
    }

    horizontalStackView.axis = .horizontal
    horizontalStackView.spacing = UIConstants.HorizontalStackView.spacing
  }

  private func configureVerticalStackView() {
    addSubview(verticalStackView)

    verticalStackView.snp.makeConstraints { make in
      make.top.equalTo(horizontalStackView.snp.bottom).offset(UIConstants.VerticalStackView.top)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)

      make.bottom.equalToSuperview()
    }

    verticalStackView.axis = .vertical
    verticalStackView.alignment = .leading
    verticalStackView.distribution = .equalSpacing
    verticalStackView.spacing = UIConstants.VerticalStackView.spacing
  }
  
  // MARK: - Interface
  func getCollapseButton() -> UIButton {
    return self.collapseButton
  }

  func setCollapsedState() {
    isCollapsed = true

    verticalStackView.isHidden = true
    collapseButton.setImage(#imageLiteral(resourceName: "iconsDropDownDown"), for: .normal)

    horizontalStackView.snp.remakeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.HorizontalStackView.top)
      make.leading.equalToSuperview().offset(16)
      make.bottom.equalToSuperview()
    }
  }

  func setUncollapsedState() {
    isCollapsed = false

    verticalStackView.isHidden = false
    collapseButton.setImage(#imageLiteral(resourceName: "iconsDropDownUp"), for: .normal)

    horizontalStackView.snp.remakeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.HorizontalStackView.top)
      make.leading.equalToSuperview().offset(16)
    }

    verticalStackView.snp.remakeConstraints { make in
      make.top.equalTo(horizontalStackView.snp.bottom).offset(UIConstants.VerticalStackView.top)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)

      make.bottom.equalToSuperview()
    }
  }
  
  func setCharacteristics(product: Product, variant: Variant) {
    titleLabel.text = Localizator.standard.localizedString("Характеристики").uppercased()

    fillHorizontalFeaturesStackWith(product: product, variant: variant)
    fillVerticalFeaturesStackWith(product: product, variant: variant)

    if isCollapsed {
      setCollapsedState()
    } else {
      setUncollapsedState()
    }

    setNeedsUpdateConstraints()
  }

  private func fillHorizontalFeaturesStackWith(product: Product, variant: Variant) {
    horizontalStackView.removeAllArrangedSubviews()

    var filteredProperties = product.properties
      .filter { isSizeAddable(property: $0, variant: variant) }
      .filter { !$0.title.isEmpty }

    if let vstavka = variant.properties.first(where: { $0.code == "haracteristica_bril" }) {
      filteredProperties.append(vstavka)
    }

    let horizontalItems = getHorizontalItemFrom(properties: filteredProperties, variant: variant)

    if horizontalItems.isEmpty {
      collapseHorizontalFeaturesStack()
    } else {
      uncollapseHorizontalFeaturesStack()

      horizontalItems.forEach { item in
        let itemView = HorizontalItemView()
        horizontalStackView.addArrangedSubview(itemView)

        itemView.snp.makeConstraints { make in
          make.width.equalTo(UIConstants.HorizontalStackView.itemWidth)
          make.top.bottom.equalToSuperview()
        }

        itemView.configure(imageName: item.imageName, titleText: item.title)
      }
    }
  }

  private func fillVerticalFeaturesStackWith(product: Product, variant: Variant) {
    createdViews.forEach { $0.removeFromSuperview() }

    let properties = product.properties
      .filter { isSizeAddable(property: $0, variant: variant) }
      .filter { !$0.title.isEmpty }

    addWeghtAndSize(product: product, variant: variant)

    properties.forEach {
      addVerticalStackItem(name: $0.name, value: $0.title)
    }
  }

  private func addWeghtAndSize(product: Product, variant: Variant) {
    if let variantWeight = variant.properties.first(where: { $0.code == "weight_product" })?.title {
      addVerticalStackItem(name: Localizator.standard.localizedString("Вес"), value: variantWeight + " г")
    }

    if let variantSize = variant.size {
      addVerticalStackItem(name: Localizator.standard.localizedString("Размер"), value: variantSize.title)
    }

    if let vstavka = variant.properties.first(where: { $0.code == "haracteristica_bril" })?.title,
      let name = variant.properties.first(where: { $0.code == "haracteristica_bril" })?.name {
      addVerticalStackItem(name: name, value: vstavka)
    }
  }

  private func collapseHorizontalFeaturesStack() {
    horizontalStackView.isHidden = true

    verticalStackView.snp.remakeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.VerticalStackView.top)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)

      make.bottom.equalToSuperview()
    }
  }

  private func uncollapseHorizontalFeaturesStack() {
    horizontalStackView.isHidden = false

    horizontalStackView.snp.remakeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.HorizontalStackView.top)
      make.leading.equalToSuperview().offset(16)
    }

    verticalStackView.snp.remakeConstraints { make in
      make.top.equalTo(horizontalStackView.snp.bottom).offset(UIConstants.VerticalStackView.top)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)

      make.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Private methods
  private func isSizeAddable(property: Property, variant: Variant) -> Bool {
    guard property == variant.size else { return true }
    if let size = Int(property.title) {
      return size != 0
    }
    return false
  }

  private func addVerticalStackItem(name: String, value: String) {
    let view = LabelsStackView()
    
    verticalStackView.addArrangedSubview(view)
    view.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
    }
    
    view.configure(title: name + ":",
                   value: value)
    createdViews.append(view)
  }
}

extension FeatureView {
  private func getHorizontalItemFrom(properties: [Property], variant: Variant) -> [HorizontalItem] {
    var result = [HorizontalItem]()

    if let weightProperty = variant.properties.first(where: { $0.code == "weight_product" })?.title {
      result.append(
        HorizontalItem(
          imageName: "weight_product_icon",
          title: weightProperty + " г")
      )
    }

    if let metallProperty = properties.first(where: { $0.code == "vid_metala" }) {
      var title = metallProperty.title

      if let probaProperty = properties.first(where: { $0.code == "proba" }) {
        title = metallProperty.title + "," + "\n" + probaProperty.title + " проба"
      }

      result.append(
        HorizontalItem(
          imageName: "vid_metala_icon",
          title: title)
      )
    }

    if let colorProperty = properties.first(where: { $0.code == "color_metal" }) {
      let title = colorProperty.title + "\n" + Localizator.standard.localizedString("металл")
      result.append(
        HorizontalItem(
          imageName: "color_metal_icon",
          title: title)
      )
    }

    if let vstavkaProperty = properties.first(where: { $0.code == "vstavka" }) {
      result.append(
        HorizontalItem(
          imageName: "vstavka_icon",
          title: vstavkaProperty.title)
      )
    }

    if let charactProperty = properties.first(where: { $0.code == "haracteristica_bril" }) {
      result.append(
        HorizontalItem(
          imageName: "haracteristica_bril_icon",
          title: charactProperty.title)
      )
    }

    return result
  }

  private struct HorizontalItem {
    let imageName: String
    let title: String
  }
}

  // MARK: - UIConstants
  private enum UIConstants {
    enum SegmentedControl {
      static let indicatorColor = UIColor.color(r: 0, g: 80, b: 47)
      static let indicatorCornerRadius: CGFloat = 2
      static let indicatorHeight: CGFloat = 2
      static let indicatorWidth: CGFloat = 32
      static let inset: CGFloat = 24
      static let height: CGFloat = 34
      static let indicatorTop: CGFloat = 16

      static let textFont = UIFont.regularAppFont(of: 14)
      static let textColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.6)
      static let selectedTextFont = UIFont.boldAppFont(of: 14.0)
      static let selectedTextColor = UIColor.color(r: 62, g: 76, b: 75)
    }

    enum LineView {
      static let top: CGFloat = 0
      static let inset: CGFloat = 24
      static let height: CGFloat = 2
      static let radius: CGFloat = 2

      static let backgroundColor = UIColor.color(r: 246, g: 246, b: 246)
    }

    enum VerticalStackView {
      static let spacing: CGFloat = 14
      static let top: CGFloat = 20
    }

    enum HorizontalStackView {
      static let spacing: CGFloat = 10
      static let top: CGFloat = 25
      static let itemWidth: CGFloat = 60
    }

    enum TitleLabel {
      static let font = UIFont.boldAppFont(of: 14.0)
      static let textColor = UIColor.color(r: 62, g: 76, b: 75)
      static let height: CGFloat = 20
    }
  }
