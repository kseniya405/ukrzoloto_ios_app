//
//  ProfileDataView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/11/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ProfileDataView: RoundedContainerView {

  // MARK: - Private variables
  private let tableView = UITableView()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTableView()
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
    tableView.contentInset = UIConstants.TableView.inset
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    registerCells()
  }
  
  private func registerCells() {
    tableView.register(UnderlineTableViewCell.self)
    tableView.register(TitleSubtitleTableViewCell.self)
    tableView.register(EmptyButtonTableViewCell.self)
    tableView.register(EventTableViewCell.self)
    tableView.register(SpaceTableViewCell.self)
    tableView.register(GenderPickerTableViewCell.self)
    tableView.register(LockedDateTableViewCell.self)
  }
  
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }

  func updateBottomConstraint(offset: CGFloat, duration: Double) {
    UIView.animate(withDuration: duration) { [weak self] in
      guard let self = self else { return }
      self.tableView.snp.updateConstraints({ make in
        make.bottom.equalToSuperview()
          .inset(offset + UIConstants.TableView.bottomInset)
      })
    }
  }

}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
  }
  enum TableView {
    static let backgroundColor = UIColor.clear
    static let inset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    static let bottomInset: CGFloat = 0
  }
  
}
