//
//  CartView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/2/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class CartView: RoundedContainerView {
  
  // MARK: - Private variables
  private let tableView = UITableView()
  private let refreshControl = UIRefreshControl()
  private let emptyView = EmptyView()
  
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
      make.top.left.right.bottom.equalToSuperview()
    }
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    registerCells()
  }
  
  private func configureRefreshControl() {
    tableView.addSubview(refreshControl)
  }
  
  private func registerCells() {
    tableView.register(LabelTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.TitleCell)
    tableView.register(CartItemTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.CartItemCell)
    tableView.register(SpaceTableViewCell.self)
    tableView.register(CartPriceTableViewCell.self)
    tableView.register(CartCreditWarningTableViewCell.self)
    tableView.register(FilledButtonTableViewCell.self)
  }
  
  private func configureEmptyView() {
    tableView.insertSubview(emptyView, at: 0)
    emptyView.snp.makeConstraints { make in
      make.edges.width.equalToSuperview()
      make.height.equalToSuperview()
        .priority(.low)
    }
  }
    
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }
  
  func getRefreshControl() -> UIRefreshControl {
    return refreshControl
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
  
  func createTitleCell(tableView: UITableView,
                       indexPath: IndexPath) -> LabelTableViewCell {
    let cell: LabelTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.TitleCell,
      for: indexPath)

    return cell
  }
  
  func createCartItemCell(tableView: UITableView,
                          indexPath: IndexPath) -> CartItemTableViewCell {
    let cell: CartItemTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.CartItemCell,
      for: indexPath)

    return cell
  }
  
  func createSpacingCell(tableView: UITableView, indexPath: IndexPath) -> SpaceTableViewCell {
    
    let cell: SpaceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    
    return cell
  }
  
  func createCreditWarningCell(tableView: UITableView, indexPath: IndexPath) -> CartCreditWarningTableViewCell {
    
    let cell: CartCreditWarningTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    
    return cell 
  }
  
  func createTotalPriceCell(tableView: UITableView, indexPath: IndexPath) -> CartPriceTableViewCell {
    
    let cell: CartPriceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    
    return cell 
  }
  
  func createButtonCell(tableView: UITableView, indexPath: IndexPath) -> FilledButtonTableViewCell {
    
    let cell: FilledButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    
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
    static let bottomInset: CGFloat = 20
    static let leftSpacing: CGFloat = 16
  }
  
  enum Title {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.boldAppFont(of: 22)
    static let height: CGFloat = 26.4
    
    static let insets = UIEdgeInsets(top: 24, left: 24, bottom: 20, right: 24)
  }
  
  enum OrderButton {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
    static let font = UIFont.boldAppFont(of: 15)
    
    static let height: CGFloat = 60
    static let bottom: CGFloat = Constants.Screen.heightCoefficient > 1 ? 100 : 110
  }
  
  enum BottomView {
    static let backgroundColor = UIColor.color(r: 246, g: 246, b: 246)
    static let cornerRadius: CGFloat = 16
    
    static let bottom: CGFloat = MainTabBarController.centerItemOffset
  }
  
  enum ReuseIdentifiers {
    static let TitleCell = "TitleCell"
    static let CartItemCell = "CartItemCell"
    static let InsuranceOptionInCartCell = "InsuranceOptionInCartCell"
  }
}
