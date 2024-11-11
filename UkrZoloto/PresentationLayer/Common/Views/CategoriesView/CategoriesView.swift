//
//  CategoriesView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/26/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit

class CategoriesView: InitView {
  
  // MARK: - Private variables
  private let titleLabel = UILabel()
  private let tableView = ShadowedView(RoundedTableView())
  private var tableViewHeightConstraint: Constraint?
  
  // MARK: - Life cycle
  override func updateConstraints() {
    let rowsCount = tableView.view.numberOfRows(inSection: 0)
    let height = CGFloat(rowsCount) * UIConstants.TableView.cellHeight
    tableViewHeightConstraint?.update(offset: height)
    super.updateConstraints()
  }
  
  // MARK: - Init configure
  override func initConfigure() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    clipsToBounds = false
    configureTitleLabel()
    configureTableView()
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
  
  private func configureTableView() {
    tableView.backgroundColor = UIConstants.TableView.backgroundColor
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.TableView.top)
      tableViewHeightConstraint = make.height.equalTo(UIConstants.TableView.cellHeight).priority(999).constraint
      make.bottom.equalToSuperview()
    }
    tableView.view.separatorStyle = .none
    tableView.view.showsVerticalScrollIndicator = false
    tableView.view.rowHeight = UITableView.automaticDimension
    tableView.view.estimatedRowHeight = UITableView.automaticDimension
  }
  
  // MARK: - Interface
  func setTitle(_ title: String?) {
    titleLabel.text = title
  }
  
  func getTableView() -> UITableView {
    return tableView.view
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum TableView {
    static let top: CGFloat = 25
    static let width = Constants.Screen.screenWidth
    static let cellHeight: CGFloat = 68
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
