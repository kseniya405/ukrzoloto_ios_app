//
//  DeliveryView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class DeliveryView: InitView {

  // MARK: - Private variables
  private let tableView = UITableView()
  private let continueButton = MainButton()
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureTableView()
    configureContinueButton()
  }
  
  private func configureTableView() {
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }
    tableView.backgroundColor = UIConstants.TableView.backgroundColor
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    tableView.keyboardDismissMode = .onDrag
    registerCells()
  }

  private func registerCells() {
    tableView.register(LabelTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.TitleCell)
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.LocationCell)
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.AddressCell)
  }
  
  private func configureContinueButton() {
    continueButton.backgroundColor = UIConstants.ContinueButton.backgroundColor
    addSubview(continueButton)
    continueButton.snp.makeConstraints { make in
      make.top.equalTo(tableView.snp.bottom).offset(UIConstants.ContinueButton.top)
      make.left.right.equalToSuperview().inset(UIConstants.ContinueButton.left)
      make.bottom.equalToSuperview().inset(UIConstants.ContinueButton.bottom)
      make.height.equalTo(UIConstants.ContinueButton.height)
    }
  }
  
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }

  func setContinueTitle(_ title: String?) {
    continueButton.setTitle(title, for: .normal)
  }
  
  func setButtonEnabled(_ isEnabled: Bool) {
    continueButton.isEnabled = isEnabled
  }
  
  func setTableBottomInset(_ inset: CGFloat) {
    tableView.contentInset.bottom = inset
  }
  
  func addContinueButtonTarget(_ target: Any?,
                               action: Selector,
                               for event: UIControl.Event) {
    continueButton.addTarget(target, action: action, for: event)
  }
  
  func createTitleCell(tableView: UITableView,
                       indexPath: IndexPath) -> LabelTableViewCell {
    let cell: LabelTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.TitleCell,
                                                                 for: indexPath)
    return cell
  }
  
  func createLocationCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.LocationCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { LocationDeliveryTypeView() }
    cell.setupUI(insets: UIConstants.LocationCell.insets, height: nil)
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
    return cell
  }
  
  func createAddressCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.AddressCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { AddressDeliveryTypeView() }
    cell.setupUI(insets: UIConstants.LocationCell.insets, height: nil)
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
    static let leftSpacing: CGFloat = 16
  }
  
  enum Title {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.boldAppFont(of: 22)
    static let height: CGFloat = 26.4
    
    static let insets = UIEdgeInsets(top: 24, left: 24, bottom: 20, right: 24)
  }
  
  enum ContinueButton {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
    static let font = UIFont.boldAppFont(of: 15)
    
    static let top: CGFloat = 20
    static let left: CGFloat = 24
    static let bottom: CGFloat = 40
    static let height: CGFloat = 52
  }
  
  enum LocationCell {
    static let insets = UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
  }
  
  enum ReuseIdentifiers {
    static let TitleCell = "TitleCell"
    static let LocationCell = "LocationCell"
    static let AddressCell = "AddressCell"
  }
}
