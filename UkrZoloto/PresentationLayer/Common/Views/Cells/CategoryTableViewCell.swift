//
//  CategoryTableViewCell.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/26/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Private variables
  private let categoryView = SelectionView(style: .big, frame: .zero)
  
  // MARK: - Life Cycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfigure()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initConfigure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initConfigure()
  }
  
  private func initConfigure() {
    selectedBackgroundView = getSelectedView()
    setupCategoryView()
  }
  
  private func setupCategoryView() {
    contentView.addSubview(categoryView)
    categoryView.snp.makeConstraints { make in
      make.top.bottom.trailing.equalToSuperview()
      make.leading.equalToSuperview().inset(UIConstants.CategoryView.left)
    }
    categoryView.setFont(UIConstants.Title.font)
    categoryView.setTextColor(UIConstants.Title.color)
  }
  
  // MARK: - Interface
  func configure(viewModel: ImageTitleImageViewModel, separatorPosition: SeparatorPosition) {
    categoryView.setTitle(viewModel.title)
    categoryView.setLeftImage(viewModel.leftImageViewModel)
    categoryView.setRightImage(viewModel.rightImageViewModel)
    categoryView.setSeparatorPosition(separatorPosition)
  }
  
  // MARK: - Private methods
  private func getSelectedView() -> UIView {
    let view = UIView()
    view.backgroundColor = UIConstants.CategoryView.backgroundColor
    return view
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum Title {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 18)
  }
  
  enum CategoryView {
    static let left: CGFloat = 12
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47).withAlphaComponent(0.05)
  }
}
