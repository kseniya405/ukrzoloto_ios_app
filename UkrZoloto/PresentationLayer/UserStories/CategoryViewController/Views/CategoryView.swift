//
//  CategoryView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/29/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class CategoryView: InitView {
  
  // MARK: - Private variables
  private let tableView = UITableView()
  private let refreshControl = UIRefreshControl()
  
  // MARK: - Кешовані значення
  private struct CachedSizes {
    static let subcategoriesInsets = UIEdgeInsets(
      top: 0,
      left: UIConstants.TableView.leftSpacing,
      bottom: UIConstants.SubcategoriesView.bottomSpacing,
      right: UIConstants.TableView.leftSpacing
    )
    
    static let productsGroupInsets = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: UIConstants.ProductsGroupView.bottomSpacing,
      right: 0
    )
    
    static let bannerInsets = UIEdgeInsets(
      top: UIConstants.BannerView.topSpacing,
      left: 0,
      bottom: UIConstants.BannerView.bottomSpacing,
      right: 0
    )
  }
  
  private let cellIdentifiers: [String] = [
    UIConstants.ReuseIdentifiers.SubcategoriesCell,
    UIConstants.ReuseIdentifiers.ProductsGroupCell,
    UIConstants.ReuseIdentifiers.BannerCell
  ]
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureTableView()
    configureRefreshControl()
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
    registerCells()
  }
  
  private func configureRefreshControl() {
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
  }
  
  private func registerCells() {
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.SubcategoriesCell)
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.ProductsGroupCell)
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.BannerCell)
  }
  
  private func configureCell(_ cell: AUIReusableTableViewCell,
                             viewCreator: @escaping () -> UIView,
                             insets: UIEdgeInsets,
                             height: CGFloat? = nil) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    cell.setCellCreateViewBlock(viewCreator)
    cell.setupUI(insets: insets, height: height)
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
    
    CATransaction.commit()
  }
  
  // MARK: - Refresh control handler
  @objc private func refreshData() {
    // Perform your data refresh action here
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.refreshControl.endRefreshing()
      self.tableView.reloadData() // Optionally reload data after refresh
    }
  }
  
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }
  
  func getRefreshControl() -> UIRefreshControl {
    return refreshControl
  }
  
  func createSubcategoriesCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.SubcategoriesCell,
      for: indexPath
    )
    configureCell(
      cell,
      viewCreator: { CategoriesView() },
      insets: CachedSizes.subcategoriesInsets
    )
    return cell
  }
  
  func createProductsGroupCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.ProductsGroupCell,
      for: indexPath
    )
    configureCell(
      cell,
      viewCreator: { ProductsGroupView() },
      insets: CachedSizes.productsGroupInsets
    )
    return cell
  }
  
  func createBannerCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.BannerCell,
      for: indexPath
    )
    configureCell(
      cell,
      viewCreator: { self.createImageView() },
      insets: CachedSizes.bannerInsets,
      height: UIConstants.BannerView.cellHeight
    )
    return cell
  }
  
  private func createImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = UIConstants.BannerView.backgroundColor
    return imageView
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 245, g: 245, b: 245)
  }
  
  static let topViewColor = UIColor.color(r: 0, g: 80, b: 47)
  
  enum TableView {
    static let backgroundColor = UIColor.clear
    static let bottomInset: CGFloat = 20
    static let leftSpacing: CGFloat = 16
  }
  
  enum SubcategoriesView {
    static let bottomSpacing: CGFloat = 50
  }
  
  enum ProductsGroupView {
    static let bottomSpacing: CGFloat = (15 * Constants.Screen.widthCoefficient).rounded()
  }
  
  enum BannerView {
    static let bottomSpacing: CGFloat = 50
    static let topSpacing: CGFloat = 35
    static let backgroundColor = UIColor.clear
    static let cellAspect: CGFloat = 16.0 / 9.0
    static let cellWidth: CGFloat = (Constants.Screen.screenWidth - 2 * UIConstants.TableView.leftSpacing)
    static let cellHeight: CGFloat = 302 // (cellWidth / cellAspect).rounded()
  }
  
  enum ReuseIdentifiers {
    static let SubcategoriesCell = "SubcategoriesCell"
    static let ProductsGroupCell = "ProductsGroupCell"
    static let BannerCell = "BannerCell"
  }
}
