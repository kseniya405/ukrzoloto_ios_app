//
//  MainView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class MainView: InitView {
  
  // MARK: - Public variables
  var topInset: CGFloat = 0 {
    didSet {
      tableView.contentInset.top = topInset
    }
  }
  
  // MARK: - Private variables
  private let tableView = UITableView()
  private let refreshControl = UIRefreshControl()
  private let emptyView = EmptyView()
  private let popupView = MainScreenPopupView(type: .unregistered)
  
  private let cellIdentifiers: [String] = [
    UIConstants.ReuseIdentifiers.bannersCell,
    UIConstants.ReuseIdentifiers.compilationsCell,
    UIConstants.ReuseIdentifiers.productsGroupCell,
    UIConstants.ReuseIdentifiers.bannersGroupCell,
    UIConstants.ReuseIdentifiers.certsCell,
    UIConstants.ReuseIdentifiers.categoriesCell,
    UIConstants.ReuseIdentifiers.phoneNumberCell,
    UIConstants.ReuseIdentifiers.timeCell,
    UIConstants.ReuseIdentifiers.imageTitleImages,
    UIConstants.ReuseIdentifiers.contactsCell
  ]
  
  // MARK: - Кешовані значення
  private struct CachedSizes {
    static let defaultInsets = UIEdgeInsets(
      top: 0,
      left: UIConstants.TableView.leftSpacing,
      bottom: UIConstants.TableView.defaultCellSpacing - 1,
      right: UIConstants.TableView.leftSpacing
    )
    
    static let bannerInsets = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: UIConstants.TableView.bannerCellSpacing - 1,
      right: 0
    )
    
    static let categoryInsets = UIEdgeInsets(
      top: 0,
      left: UIConstants.CategoryView.leftSpacing,
      bottom: UIConstants.CategoryView.bottomSpacing - 1,
      right: UIConstants.CategoryView.rightSpacing
    )
    
    static let certsInsets = UIEdgeInsets(
      top: 0,
      left: UIConstants.TableView.leftSpacing,
      bottom: UIConstants.TableView.certsCellSpacing,
      right: UIConstants.TableView.leftSpacing
    )
    
    static let compilationCellInsets = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: UIConstants.TableView.defaultCellSpacing,
      right: 0
    )
    
    static let defaultCellInsets = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: UIConstants.TableView.defaultCellSpacing - 1,
      right: 0
    )
  }
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
    optimizeTableView()
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureTableView()
    configureRefreshControl()
    configureEmptyView()
    configurePopupView()
  }
  
  private func configureTableView() {
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(UIConstants.TableView.top)
      make.left.right.bottom.equalToSuperview()
    }
    tableView.backgroundColor = UIConstants.TableView.backgroundColor
    tableView.contentInset.top = topInset
    tableView.contentInset.bottom = UIConstants.TableView.bottomInset - 1
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    registerCells()
  }
  
  private func optimizeTableView() {
    if #available(iOS 15.0, *) {
      tableView.isPrefetchingEnabled = true
    }
    tableView.estimatedSectionHeaderHeight = 0
    tableView.estimatedSectionFooterHeight = 0
  }
  
  private func configureRefreshControl() {
    tableView.addSubview(refreshControl)
  }
  
  private func registerCells() {
    cellIdentifiers.forEach {
      tableView.register(AUIReusableTableViewCell.self, forCellReuseIdentifier: $0)
    }
  }
  
  private func configureEmptyView() {
    tableView.insertSubview(emptyView, at: 0)
    emptyView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.height.equalToSuperview()
    }
  }
  
  private func configurePopupView() {
    addSubview(popupView)
    popupView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.PopupView.sides)
      make.bottom.equalToSuperview()
        .offset(Constants.Screen.screenHeight)
    }
    popupView.isHidden = true
  }
  
  private func configureCell(_ cell: AUIReusableTableViewCell,
                             viewCreator: @escaping () -> UIView,
                             insets: UIEdgeInsets) {
    cell.setCellCreateViewBlock(viewCreator)
    cell.setupUI(insets: insets, height: nil)
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
  }
  
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }
  
  func getRefreshControl() -> UIRefreshControl {
    return refreshControl
  }
  
  func getPopupView() -> MainScreenPopupView {
    return popupView
  }
  
  func setEmptyView(image: UIImage,
                    title: String,
                    subtitle: String,
                    buttonTitle: String) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    emptyView.setImage(image)
    emptyView.setTitle(title)
    emptyView.setSubtitle(subtitle)
    emptyView.setButtonTitle(buttonTitle)
    CATransaction.commit()
  }
  
  func setEmptyViewHidden(_ isHidden: Bool) {
    guard emptyView.isHidden != isHidden else { return }
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    emptyView.isHidden = isHidden
    CATransaction.commit()
  }
  
  func addEmptyViewButtonTarget(_ target: Any?,
                                action: Selector,
                                for event: UIControl.Event) {
    emptyView.addTargetOnButton(target, action: action, for: event)
  }
  
  // MARK: - Cell Creation
  func createBannersCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.bannersCell,
      for: indexPath
    )
    configureCell(cell, viewCreator: { BannersView() }, insets: CachedSizes.bannerInsets)
    return cell
  }
  
  func createCategoriesCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.categoriesCell,
      for: indexPath
    )
    configureCell(cell, viewCreator: { CategoriesView() }, insets: CachedSizes.categoryInsets)
    return cell
  }
  
  func createCompilationsCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.compilationsCell,
      for: indexPath
    )
    configureCell(cell, viewCreator: { CompilationsView() }, insets: CachedSizes.defaultCellInsets)
    return cell
  }
  
  func createProductsGroupCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.productsGroupCell,
      for: indexPath
    )
    configureCell(cell, viewCreator: { ProductsGroupView() }, insets: CachedSizes.defaultCellInsets)
    return cell
  }
  
  func createCertsCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.certsCell,
      for: indexPath
    )
    configureCell(cell, viewCreator: { BannersView() }, insets: CachedSizes.certsInsets)
    return cell
  }
  
  func createContactsCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.contactsCell,
      for: indexPath
    )
    configureCell(cell, viewCreator: { SupportView() }, insets: .zero)
    return cell
  }
  
  func createPhoneNumberCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.phoneNumberCell,
      for: indexPath
    )
    configureCell(cell, viewCreator: { PhoneNumberContactView() }, insets: .zero)
    return cell
  }
  
  func createTimeCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.timeCell,
      for: indexPath
    )
    configureCell(cell, viewCreator: { TimeTableView() }, insets: .zero)
    return cell
  }
  
  func createImageTitleImagesCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(
      withReuseIdentifier: UIConstants.ReuseIdentifiers.imageTitleImages,
      for: indexPath
    )
    configureCell(cell, viewCreator: { ImageTitleImagesView() }, insets: .zero)
    return cell
  }
  
  func showPopupView() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    popupView.snp.updateConstraints { make in
      make.bottom.equalToSuperview()
        .inset(UIConstants.PopupView.bottom)
    }
    
    CATransaction.commit()
  }
  
  func hidePopupView() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    popupView.snp.updateConstraints { make in
      make.bottom.equalToSuperview()
        .offset(Constants.Screen.screenHeight)
    }
    
    CATransaction.commit()
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 245, g: 245, b: 245)
  }
  enum TableView {
    static let top: CGFloat = 0
    static let backgroundColor = UIColor.clear
    static let bottomInset: CGFloat = 20
    static let leftSpacing: CGFloat = 16
    static let defaultCellSpacing: CGFloat = 60
    static let bannerCellSpacing: CGFloat = 24
    static let certsCellSpacing: CGFloat = 50
  }
  
  enum CategoryView {
    static let leftSpacing: CGFloat = 12
    static let rightSpacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 50
  }
  
  enum ReuseIdentifiers {
    static let bannersCell = "bannersCell"
    static let compilationsCell = "compilationsCell"
    static let productsGroupCell = "productsGroupCell"
    static let bannersGroupCell = "bannersGroupCell"
    static let spacingCell = "spacingCell"
    static let certsCell = "certsCell"
    static let categoriesCell = "categoriesCell"
    static let phoneNumberCell = "phoneNumberCell"
    static let timeCell = "timeCell"
    static let imageTitleImages = "imageTitleImages"
    static let contactsCell = "contactsCell"
  }
  
  enum PopupView {
    static let bottom: CGFloat = 131
    static let sides: CGFloat = 16
  }
}
