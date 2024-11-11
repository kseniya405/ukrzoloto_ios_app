//
//  OptionViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 12.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum OptionItem {
  case variant(OptionCellController)
}

protocol OptionsViewControllerOutput: AnyObject {
  func chooseVariants(for filter: SelectFilter, from optionsVC: OptionsViewController)
  func didTapOnBack(from optionsVC: OptionsViewController)
}

class OptionsViewController: LocalizableViewController, NavigationButtoned {
  
  // MARK: - Public variables
  var output: OptionsViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = OptionsView()
	private let initialFilterVariants: [FilterVariant]
  private var filter: SelectFilter
  private var dataSource = [OptionItem]()
  
  // MARK: - Life cycle
  init(filter: SelectFilter,
       shouldDisplayOnFullScreen: Bool) {
    self.filter = filter
		self.initialFilterVariants = filter.variants
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
    view = selfView
  }
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    setupView()
    setupDataSource()
    localize()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
  }
  
  private func setupNavigationBar() {
    navigationItem.title = filter.title
    setNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
    setNavigationButton(#selector(didTapOnClearFilters),
                        button: ButtonsFactory.clearFilterButtonForNavItem(),
                        side: .right)
  }
  
  private func setupSelfView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
    selfView.getButton().addTarget(self,
                                   action: #selector(didTapOnApply),
                                   for: .touchUpInside)
  }
  
  private func setupDataSource() {
    dataSource.removeAll()
    dataSource.append(contentsOf: filter.variants.compactMap { OptionItem.variant(optionCellController(from: $0)) })
    selfView.getTableView().reloadData()
  }
  
  private func optionCellController(from variant: FilterVariant) -> OptionCellController {
    let optionController = OptionCellController(variant: variant)
    optionController.delegate = self
    return optionController
  }
  
  // MARK: - Localization
  override func localize() {
    selfView.getButton().setTitle(Localizator.standard.localizedString("Применить").uppercased(),
                                  for: .normal)
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnBack() {
		filter.variants = initialFilterVariants
		setupDataSource()
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func didTapOnClearFilters() {
    for index in 0..<filter.variants.count {
      filter.variants[index].status = false
    }
    setupDataSource()
  }
  
  @objc
  private func didTapOnApply() {
    output?.chooseVariants(for: filter, from: self)
  }
  
}

// MARK: - UITableViewDataSource
extension OptionsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .variant(let controller):
      let cell = selfView.createOptionCell(tableView: tableView,
                                           indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    }
  }
  
}

// MARK: - UITableViewDelegate
extension OptionsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard dataSource.indices.contains(indexPath.row) else { return }
    switch dataSource[indexPath.row] {
    case .variant(let controller):
      controller.view = nil
    }
  }
}

// MARK: - OptionCellControllerDelegate
extension OptionsViewController: OptionCellControllerDelegate {
  func didTapOnOption(at controller: OptionCellController) {
    guard let index = filter.variants.firstIndex(of: controller.variant) else { return }
    filter.variants[index].status = !filter.variants[index].status
    setupDataSource()
  }
  
}
