//
//  FavoritesView.swift
//  UkrZoloto
//
//  Created by user on 24.03.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit
import AUIKit

class FavoritesView: RoundedContainerView {

  private let tableView = UITableView()
  private let refreshControl = UIRefreshControl()
  private let emptyView = EmptyView()

  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }

  private func configureSelf() {
    setupSelfView()
    configureTableView()
    configureRefreshControl()
    configureEmptyView()
  }

  private func setupSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }

  private func configureTableView() {
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    tableView.backgroundColor = UIConstants.TableView.backgroundColor
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    registerCells()
  }

  private func registerCells() {
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.ProductsGroupCell)
  }

  private func configureRefreshControl() {
    tableView.addSubview(refreshControl)
  }

  private func configureEmptyView() {
    tableView.insertSubview(emptyView, at: 0)
    emptyView.snp.makeConstraints { make in
      make.edges.width.height.equalToSuperview()
    }
  }

  // MARK: - Interface

  public func getTableView() -> UITableView {
    return tableView
  }

  public func getRefreshControl() -> UIRefreshControl {
    return refreshControl
  }

  public func setupEmptyView(image: UIImage,
                             title: String,
                             subtitle: String,
                             buttonTitle: String) {
    emptyView.setImage(image)
    emptyView.setTitle(title)
    emptyView.setSubtitle(subtitle)
    emptyView.setButtonTitle(buttonTitle)
    emptyView.isHidden = true
  }

  public func setEmptyViewHidden(_ isHidden: Bool) {
    emptyView.isHidden = isHidden
  }

  public func addEmptyViewButtonTarget(_ target: Any?,
                                       action: Selector,
                                       for event: UIControl.Event) {
    emptyView.addTargetOnButton(target, action: action, for: event)
  }

  public func createProductsGroupCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.ProductsGroupCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { ProductsGroupView() }
    cell.setupUI(insets: UIEdgeInsets(top: UIConstants.TableView.topSpacing,
                                      left: .zero,
                                      bottom: .zero,
                                      right: .zero),
                 height: nil)
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
    return cell
  }
}

private enum UIConstants {

  enum SelfView {
    static let backgroundColor = UIColor.white
  }

  enum TableView {
    static let backgroundColor = UIColor.clear
    static let topSpacing: CGFloat = 16
  }

  enum ReuseIdentifiers {
    static let ProductsGroupCell = "ProductsGroupCell"
  }
}
