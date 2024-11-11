//
//  SearchResultView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 8/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class SearchResultView: RoundedContainerView {
  
  // MARK: - Private variables
  private let tableView = UITableView()
  private let refreshControl = UIRefreshControl()
  
  private lazy var indicatorView: AnimatedViewContainer = {
    let view = AnimatedViewContainer(frame: UIConstants.footerViewFrame)
    view.backgroundColor = .clear
    let indicator = AnimatedImageView(image: #imageLiteral(resourceName: "loader"))
    indicator.frame = UIConstants.indicatorViewFrame
    view.animatedView = indicator
    view.addSubview(indicator)
    return view
  }()
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
    configureTableView()
    configureRefreshControl()
  }
  
  private func configureSelf() {
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
    registerCell()
  }
  
  private func registerCell() {
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.TitleCell)
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.ProductsGroupCell)
  }
  
  private func configureRefreshControl() {
    tableView.addSubview(refreshControl)
  }
  
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }
  
  func getRefreshControl() -> UIRefreshControl {
    return refreshControl
  }
  
  func getIndicatorView() -> AnimatedViewContainer {
    return indicatorView
  }
  
  func createTitleCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.TitleCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { TitleView() }
    cell.setupUI(insets: UIConstants.titleViewInsets)
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
    return cell
  }
  
  func createProductsGroupCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.ProductsGroupCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { ProductsGroupView() }
    cell.setupUI(insets: UIEdgeInsets(top: 0,
                                      left: 0,
                                      bottom: UIConstants.ProductsGroupView.bottomSpacing,
                                      right: 0),
                 height: nil)
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
    return cell
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 246, g: 246, b: 246)
  }
  enum TableView {
    static let backgroundColor = UIColor.clear
    static let leftSpacing: CGFloat = 16
    static let bottomInset: CGFloat = 20
  }
  
  enum ProductsGroupView {
    static let bottomSpacing: CGFloat = (15 * Constants.Screen.widthCoefficient).rounded()
  }
  
  enum ReuseIdentifiers {
    static let TitleCell = "TitleCell"
    static let ProductsGroupCell = "ProductsGroupCell"
  }
  
  static let titleViewInsets = UIEdgeInsets(top: 24, left: 16,
                                            bottom: 32, right: 16)
  static let footerViewFrame = CGRect(x: 0, y: 0, width: Constants.Screen.screenWidth, height: 50)
  static let indicatorViewFrame = CGRect(origin: CGPoint(x: Constants.Screen.screenWidth / 2 - 25, y: 0),
                                         size: CGSize(width: 50, height: 50))
}
