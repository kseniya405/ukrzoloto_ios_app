//
//  OptionView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 12.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class OptionsView: InitView {
  
  // MARK: - Private variables
  private let tableView = UITableView()
  private let button = EmptyButton()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTableView()
    configureButton()
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
    tableView.contentInset = UIConstants.TableView.insets
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    registerCell()
  }
  
  private func registerCell() {
    tableView.register(AUIReusableTableViewCell.self,
                       forCellReuseIdentifier: UIConstants.ReuseIdentifiers.OptionFilterCell)
  }
  
  private func configureButton() {
    addSubview(button)
    button.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
        .inset(UIConstants.Button.bottom)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.Button.insets)
      make.height.equalTo(UIConstants.Button.height)
    }
    button.backgroundColor = UIConstants.Button.backgroundColor
    button.borderColor = UIConstants.Button.borderColor
    button.setTitleColor(UIConstants.Button.textColor, for: .normal)
  }
  
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }
  
  func getButton() -> UIButton {
    return button
  }
  
  func createOptionCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.OptionFilterCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { OptionView() }
    cell.setupUI(insets: UIEdgeInsets(top: 0,
                                      left: 24,
                                      bottom: 0,
                                      right: 24))
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
    static let insets = UIEdgeInsets(top: 32, left: 0, bottom: 106, right: 0)
  }
  
  enum Button {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
    static let borderColor = UIColor.clear
    static let textColor = UIColor.white
    
    static let bottom: CGFloat = 32
    static let insets: CGFloat = 24
    static let height: CGFloat = 52
  }
  
  enum ReuseIdentifiers {
    static let OptionFilterCell = "OptionFilterCell"
  }
  
}
