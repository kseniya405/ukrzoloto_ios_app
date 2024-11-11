//
//  AddEventView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class AddEventView: InitView {
  
  // MARK: - Private variables
  private let tableView = UITableView()
  private let mainButton = MainButton()

  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTableView()
    configureGreyButton()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTableView() {
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
    tableView.backgroundColor = UIConstants.TableView.backgroundColor
    tableView.contentInset = UIConstants.TableView.inset
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    registerCells()
  }
  
  private func registerCells() {
    tableView.register(UnderlineTableViewCell.self)
    tableView.register(SpaceTableViewCell.self)
  }
  
  private func configureGreyButton() {
    addSubview(mainButton)
    mainButton.snp.makeConstraints { make in
      make.top.equalTo(tableView.snp.bottom)
        .offset(UIConstants.MainButton.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.MainButton.insets)
      make.height.equalTo(UIConstants.MainButton.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.MainButton.bottom)
    }
  }
  
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }

  func getMainButton() -> MainButton {
    return mainButton
  }
  
  func updateBottomConstraint(offset: CGFloat, duration: Double) {
    UIView.animate(withDuration: duration) { [weak self] in
      guard let self = self else { return }
      self.mainButton.snp.updateConstraints({ make in
        make.bottom.equalToSuperview()
          .inset(offset + UIConstants.MainButton.bottom)
      })
    }
  }
  
  func setButtonTitle(_ title: String) {
    mainButton.setTitle(title, for: .normal)
  }

}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
  }
  enum TableView {
    static let backgroundColor = UIColor.clear
    static let inset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
  }
  enum MainButton {
    static let height: CGFloat = 52
    static let top: CGFloat = 15
    static let bottom: CGFloat = 32
    static let insets: CGFloat = 24
  }

}
