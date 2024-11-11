//
//  ProductSearchView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 8/30/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol ProductSearchViewOutput: AnyObject {
  func didSelect(viewModel: ProductSearchViewModel)
}

class ProductSearchView: InitView {
  
  // MARK: - Public variables
  //  weak var delegate: SearchViewOutput?
  
  // MARK: - Private variables
  private let mainView = UIView()
  private let tableView = UITableView()
  private let searchErrorView: (UIView & SearchErrorViewInput)
  
  private lazy var indicatorView: AnimatedViewContainer = {
    let view = AnimatedViewContainer(frame: UIConstants.footerViewFrame)
    view.backgroundColor = .clear
    let indicator = AnimatedImageView(image: #imageLiteral(resourceName: "loader"))
    indicator.frame = UIConstants.indicatorViewFrame
    view.animatedView = indicator
    view.addSubview(indicator)
    return view
  }()
  
  // Life cycle
  init(errorView: (UIView & SearchErrorViewInput) = CitySearchErrorView()) {
    searchErrorView = errorView
    super.init()
  }
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  // MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()
    mainView.roundCorners(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner],
                          radius: UIConstants.MainView.corderRadius)
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureMainView()
    configureTableView()
    configureSearchErrorView()
  }
  
  private func configureMainView() {
    addSubview(mainView)
    mainView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.MainView.top)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func configureTableView() {
    mainView.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    tableView.backgroundColor = UIConstants.TableView.backgroundColor
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
//    tableView.estimatedRowHeight = 44
    registerCell()
  }
  
  private func registerCell() {
    tableView.register(
      AUIReusableTableViewCell.self,
      forCellReuseIdentifier: UIConstants.ReuseIdentifiers.TitleCell)
    tableView.register(
      AUIReusableTableViewCell.self,
      forCellReuseIdentifier: UIConstants.ReuseIdentifiers.ProductsGroupCell)
  }
  
  private func configureSearchErrorView() {
    mainView.addSubview(searchErrorView)
    searchErrorView.snp.makeConstraints { make in
      make.edges.equalTo(mainView)
    }
  }
  
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }
  
  func getIndicatorView() -> AnimatedViewContainer {
    return indicatorView
  }
  
  func setSearchError(text: String, image: UIImage) {
    searchErrorView.setImage(image)
    searchErrorView.setTitle(text)
    
    searchErrorView.isHidden = false
    tableView.isHidden = true
  }
  
  func setErrorViewHidden(_ isHidden: Bool) {
    if isHidden {
      tableView.isHidden = false
      searchErrorView.isHidden = true
    } else {
      searchErrorView.isHidden = false
      tableView.isHidden = true
    }
  }
  
  func setTableBottomInset(_ inset: CGFloat) {
    tableView.contentInset.bottom = inset
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
    static let backgroundColor = UIColor.clear
  }
  
  enum MainView {
    static let backgroundColor = UIColor.clear
    static let corderRadius: CGFloat = 16
    
    static let top: CGFloat = 84
  }
  
  enum TableView {
    static let backgroundColor = UIColor.white
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
