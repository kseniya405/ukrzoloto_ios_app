//
//  ProfileView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/3/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

struct GuestViewTextValues {
  let title: String
  let subtitle: String
  let clickedTitle: String?
  let buttonTitle: String
}

class ProfileView: InitView {
  
  // MARK: - Private variables
  private let tableView = UITableView()
  private let refreshControl = UIRefreshControl()

  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  private func configureSelf() {
    configureTableView()
    setupPullToRefresh()
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
  
  private func setupPullToRefresh() {
    tableView.addSubview(refreshControl)
    refreshControl.tintColor = UIConstants.RefreshControll.backgroundColor
  }
  
  private func registerCells() {
    tableView.register(ProfileMainInfoDiscountTableViewCell.self)
    tableView.register(ProfileMainInfoTableViewCell.self)
    tableView.register(ProfileMainGuestTableViewCell.self)
    tableView.register(ProfileInfoTableViewCell.self)
    tableView.register(CustomerInfoTableViewCell.self)
    tableView.register(PhoneNumberTableViewCell.self)
    tableView.register(TimeTableViewCell.self)
    tableView.register(ImageTitleImagesTableViewCell.self)
    tableView.register(SpaceTableViewCell.self)
    tableView.register(LanguageTableViewCell.self)
    tableView.register(DeleteAccountTableViewCell.self)
    tableView.register(SupportTableViewCell.self)
  }
  
  // MARK: - Interface
  func getTableView() -> UITableView {
    return tableView
  }
  
  func getRefreshControl() -> UIRefreshControl {
    return refreshControl
  }

}

// MARK: - UIConstants
private enum UIConstants {
  enum TableView {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
    static let font = UIFont.regularAppFont(of: 16)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    
    static let inset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
  }
  enum RefreshControll {
    static let backgroundColor = UIColor.black
  }
}
