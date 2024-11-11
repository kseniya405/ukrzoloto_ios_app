//
//  CreditOptionsView.swift
//  UkrZoloto
//
//  Created by Mykola on 25.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class CreditOptionsView: InitView {
  private let tableView = RoundedTableView()
  private let productDetailsView = CreditProductTableViewCell()
  
  override func initConfigure() {
    super.initConfigure()
    setupSelf()
  }
  
  private func setupSelf() {
    setupTableView()
  }
  
  func setupTableView() {
    backgroundColor = UIConstants.backgroundColor

    configureProductDetailsView()
    configureTableView()
  }

  private func configureProductDetailsView() {
    addSubview(productDetailsView)

    productDetailsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    productDetailsView.layer.cornerRadius = UIConstants.ProductDetailsView.topCornerRadius
    productDetailsView.clipsToBounds = true

    productDetailsView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.height.equalTo(UIConstants.ProductDetailsView.height)
    }

    let separatorView = UIView()
    separatorView.backgroundColor = .gray.withAlphaComponent(0.5)

    productDetailsView.addSubview(separatorView)

    separatorView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(0.5)
    }
  }

  private func configureTableView() {
    addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(productDetailsView.snp.bottom)
      make.bottom.equalToSuperview().offset(UIConstants.TableView.bottomOffset)
    }

    tableView.allowsSelection = true
    tableView.backgroundColor = .white
    tableView.separatorInset = .zero
    tableView.tableFooterView = UIView()
    tableView.clipsToBounds = true
    tableView.showsVerticalScrollIndicator = false

    tableView.register(CreditProductTableViewCell.self)
    tableView.register(CreditOptionTableViewCell.self)
  }
  
  func getTableView() -> UITableView {
    return tableView
  }

  func getProductDetailsView() -> CreditProductTableViewCell {
    return productDetailsView
  }
  
  func localizeContent() {
    tableView.reloadData()
  }
}

fileprivate enum UIConstants {
  static let backgroundColor = UIColor(named: "darkGreen")!

  enum TableView {
    static let bottomOffset: CGFloat = 16
  }

  enum ProductDetailsView {
    static let height: CGFloat = 182
    static let topCornerRadius: CGFloat = 16
  }
}
