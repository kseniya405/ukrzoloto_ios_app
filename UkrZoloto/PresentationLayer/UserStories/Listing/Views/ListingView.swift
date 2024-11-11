//
//  ListingView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 06.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class ListingView: RoundedContainerView {
  
  // MARK: - Private variables
  private let tableView = UITableView()
  private let refreshControl = UIRefreshControl()
  private let emptyView = EmptyView()
  
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
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureTableView()
    configureRefreshControl()
    configureEmptyView()
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
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.SortCell)
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.ProductsGroupCell)
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.BannerCell)
    tableView.register(ErrorReloadingTableViewCell.self)
    tableView.register(SpaceTableViewCell.self)
  }
  
  private func configureRefreshControl() {
    tableView.addSubview(refreshControl)
  }
  
  private func configureEmptyView() {
    tableView.insertSubview(emptyView, at: 0)
    emptyView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.height.equalToSuperview()
    }
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
  
  func setEmptyView(image: UIImage,
                    title: String,
                    subtitle: String,
                    buttonTitle: String) {
    emptyView.setImage(image)
    emptyView.setTitle(title)
    emptyView.setSubtitle(subtitle)
    emptyView.setButtonTitle(buttonTitle)
  }
  
  func setEmptyViewHidden(_ isHidden: Bool) {
    emptyView.isHidden = isHidden
  }
  
  func addEmptyViewButtonTarget(_ target: Any?,
                                action: Selector,
                                for event: UIControl.Event) {
    emptyView.addTargetOnButton(target, action: action, for: event)
  }
  
  func createSortCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.SortCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { SortView() }
    cell.setupUI(insets: UIConstants.sortViewInsets)
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
  
  func createBannerCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.BannerCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { self.createImageView() }
    cell.setupUI(insets: UIConstants.BannerView.insets,
                 height: UIConstants.BannerView.cellHeight)
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
    return cell
  }
  
  // MARK: - Private mwthods
  private func createImageView() -> UIImageView {
    let imageView = RoundedImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = UIConstants.BannerView.backgroundColor
    imageView.clipsToBounds = true
    imageView.cornerRadius = UIConstants.BannerView.cornerRadius
    return imageView
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
    static let bottomInset: CGFloat = 120
  }
  
  enum ProductsGroupView {
    static let bottomSpacing: CGFloat = (15 * Constants.Screen.widthCoefficient).rounded()
  }
  
  enum BannerView {
    static let backgroundColor = UIColor.clear
    static let cellAspect: CGFloat = 237.0 / 164.0
    static let cellWidth: CGFloat = (Constants.Screen.screenWidth - 2 * UIConstants.TableView.leftSpacing)
    static let cellHeight: CGFloat = 302 // (cellWidth / cellAspect).rounded()
    static let cornerRadius: CGFloat = 16
    static let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  }
  
  enum ReuseIdentifiers {
    static let SortCell = "SortCell"
    static let ProductsGroupCell = "ProductsGroupCell"
    static let BannerCell = "BannerCell"
  }
  
  static let sortViewInsets = UIEdgeInsets(top: 23, left: 16,
                                           bottom: 24, right: 16)
  static let footerViewFrame = CGRect(x: 0, y: 0, width: Constants.Screen.screenWidth, height: 50)
  static let indicatorViewFrame = CGRect(origin: CGPoint(x: Constants.Screen.screenWidth / 2 - 25, y: 0),
                                         size: CGSize(width: 50, height: 50))
}
