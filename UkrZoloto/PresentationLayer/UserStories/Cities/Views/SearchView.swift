//
//  SearchView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 22.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol SearchErrorViewInput: AnyObject {
  func setImage(_ image: UIImage)
  func setTitle(_ title: String)
}

protocol SearchViewOutput: AnyObject {
  func didSelect<T: HashableTitle>(viewModel: T)
}

class SearchView<T: HashableTitle>: InitView, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: - Public variables
  weak var delegate: SearchViewOutput?
  
  // MARK: - Private variables
  private let mainView = UIView()
  private let tableView = UITableView()
  private let searchErrorView: (UIView & SearchErrorViewInput)
  
  private var viewModels = [T]()
  
  // Life cycle
  init(errorView: (UIView & SearchErrorViewInput) = CitySearchErrorView()) {
    searchErrorView = errorView
    super.init()
  }
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
    configureMainView()
    configureTableView()
    configureSearchErrorView()
  }
  
  // MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()
    mainView.roundCorners(corners:[.layerMinXMinYCorner, .layerMinXMaxYCorner],
                          radius: UIConstants.MainView.corderRadius)
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    searchErrorView.isHidden = true
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
      make.edges.equalTo(mainView)
    }
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    tableView.dataSource = self
    tableView.delegate = self
    registerCells()
  }
  
  private func registerCells() {
    tableView.register(SearchCell.self)
  }
  
  private func configureSearchErrorView() {
    mainView.addSubview(searchErrorView)
    searchErrorView.snp.makeConstraints { make in
      make.edges.equalTo(mainView)
    }
  }
  
  // MARK: - Interface
  func configure(viewModels: [T]) {
    self.viewModels.removeAll()
    self.viewModels = viewModels
    tableView.reloadData()
    
    tableView.isHidden = false
    searchErrorView.isHidden = true
  }

  func setSearchError(text: String, image: UIImage) {
    searchErrorView.setImage(image)
    searchErrorView.setTitle(text)
    
    searchErrorView.isHidden = false
    tableView.isHidden = true
  }
  
  func setTableBottomInset(_ inset: CGFloat) {
    tableView.contentInset.bottom = inset
  }
  
  // MARK: - UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = viewModels[indexPath.row]
    let cell: SearchCell = tableView.dequeueReusableCell(for: indexPath)
    
    if let location = viewModel as? Location {
      cell.configure(viewModel: viewModel, isBold: location.isBold())
    } else if let city = viewModel as? CityViewModel {
      cell.configure(viewModel: viewModel, isBold: city.isHighlighted)
    } else {
      cell.configure(viewModel: viewModel)
    }
    
    return cell
  }
  
  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.didSelect(viewModel: viewModels[indexPath.row])
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum MainView {
    static let backgroundColor = UIColor.clear
    static let corderRadius: CGFloat = 16
    
    static let top: CGFloat = 84
  }
  
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum TableView {
    static let backgroundColor = UIColor.clear
  }
  
}
