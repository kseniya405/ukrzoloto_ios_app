//
//  FilterView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 07.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class FilterView: TopToBottomAnimationView {
  
  // MARK: - Private variables
  private let tableView = UITableView()
  private let showProductsView = ShowProductsView()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTableView()
    configureShowProductsView()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTableView() {
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    tableView.backgroundColor = UIConstants.TableView.backgroundColor
    tableView.contentInset.bottom = UIConstants.TableView.bottomInset
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    tableView.keyboardDismissMode = .onDrag
    registerCells()
  }
  
  private func registerCells() {
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.RangeFilterCell)
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.SelectFilterCell)
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.ManyOptionsFilterCell)
  }
  
  private func configureShowProductsView() {
    addSubview(showProductsView)
    showProductsView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.ShowProductsView.height)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.ShowProductsView.sides)
      make.bottom.equalTo(safeAreaLayoutGuide)
        .inset(UIConstants.ShowProductsView.bottom)
    }
  }
  
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }
  
  func setShowProductsTitle(_ title: String) {
    showProductsView.setTitle(title)
  }
  
  func setShowProductsSubtitle(_ subtitle: String) {
    showProductsView.setSubtitle(subtitle)
  }
  
  func addShowProductsTarget(_ target: Any?, action: Selector) {
    let tapGesture = UITapGestureRecognizer(target: target, action: action)
    showProductsView.addGestureRecognizer(tapGesture)
  }
  
  func createRangeCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.RangeFilterCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { RangeSliderView() }
    cell.setupUI(insets: UIEdgeInsets(top: 24,
                                      left: 24,
                                      bottom: 48,
                                      right: 24))
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
    return cell
  }
  
  func createFilterSelectCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.SelectFilterCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { MultiSelectView() }
    cell.setupUI(insets: UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0),
                 height: nil)
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
    return cell
  }
  
  func createManyOptionsFilterCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.ManyOptionsFilterCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { ManyOptionsView() }
    cell.setupUI(insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
    return cell
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
  }
  
  enum TableView {
    static let backgroundColor = UIColor.clear
    static let bottomInset: CGFloat = UIConstants.ShowProductsView.height + 48
  }
  
  enum ShowProductsView {
    static let height: CGFloat = 52
    static let sides: CGFloat = 24
    static let bottom: CGFloat = 8
  }
  
  enum ReuseIdentifiers {
    static let RangeFilterCell = "RangeFilterCell"
    static let SelectFilterCell = "SelectFilterCell"
    static let ManyOptionsFilterCell = "ManyOptionsFilterCell"
  }
  
}
