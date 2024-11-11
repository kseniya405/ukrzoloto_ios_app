//
//  FilterViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 07.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD
import WARangeSlider

enum FilterItem {
  case range(RangeSliderCellController)
  case select(MultiSelectCellController)
  case manyOptions(ManyOptionsCellController)
}

protocol FilterViewControllerOutput: AnyObject {
  func didTapOnCloseFilter()
  func didTapOnManyOptions(with filter: SelectFilter, from vc: FilterViewController)
  func didTapOnShowProducts(rangeFilters: [RangeFilter], selectFilters: [SelectFilter])
}

class FilterViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: FilterViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = FilterView()
  
  private var dataSource = [FilterItem]()
  private var rangeFilters = [RangeFilter]()
  private var selectFilters = [SelectFilter]()
  
  private let categoryId: Int
  private let sortKind: SortKind
  private var productsCount = 0
  
  // MARK: - Life cycle
  init(categoryId: Int,
       sortKind: SortKind,
       rangeFilters: [RangeFilter],
       selectFilters: [SelectFilter],
       shouldDisplayOnFullScreen: Bool) {
    self.categoryId = categoryId
    self.sortKind = sortKind
    self.rangeFilters = rangeFilters
    self.selectFilters = selectFilters
    
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewFirstAppear(_ animated: Bool) {
    super.viewFirstAppear(animated)
    loadFilters()
  }
  
  // MARK: - Setup
  override func initConfigure() {
    super.initConfigure()
    hideKeyboardWhenTappedAround()
    setupView()
    localizeLabels()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
  }
  
  private func setupNavigationBar() {
    setNavigationButton(#selector(didTapOnClose),
                        button: ButtonsFactory.closeButtonForNavigationItem(),
                        side: .left)
    setNavigationButton(#selector(didTapOnClearFilters),
                        button: ButtonsFactory.clearFilterButtonForNavItem(),
                        side: .right)
  }
  
  private func setupSelfView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
    selfView.addShowProductsTarget(self,
                                   action: #selector(didTapOnShowProducts))
  }
  
  @objc
  private func loadFilters() {
    HUD.showProgress()
    ProductService.shared.getFilterProducts(for: getFilterResponseKey()) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success(let filterData):
          self.setupDataSource(filterData)
          self.selfView.setShowProductsSubtitle(Localizator.standard.localizedString("adornment", filterData.pagination.total))
        }
      }
    }
  }
  
  // MARK: - Private methods
  private func setupDataSource(_ filterData: FilterPageData) {
    dataSource.removeAll()
    
    rangeFilters = filterData.rangeFilters
    dataSource.append(contentsOf: rangeFilters.compactMap { filter -> FilterItem? in
      let rangeController = rangeCellController(from: filter)
      return FilterItem.range(rangeController)
    })
    
    selectFilters = filterData.selectFilters
    setupDataSource(for: selectFilters)
    
    productsCount = filterData.products.count
    
    selfView.getTableView().reloadData()
  }
  
  private func setupDataSource(for selectFilters: [SelectFilter]) {
    let mainFilter = sortMainFiltersFrom(selectFilters)

    mainFilter.forEach {
      dataSource.append(.select(selecFiltertCellController(from: $0)))
    }

    var additionalFilters = selectFilters

    additionalFilters.removeAll { mainFilter.contains($0) }

    additionalFilters.forEach {
      dataSource.append(.manyOptions(manyOptionsCellController(from: $0)))
    }
  }

  private func sortMainFiltersFrom(_ filters: [SelectFilter]) -> [SelectFilter] {
    var mainFilters = [SelectFilter]()

    if let metalType = filters.first(where: { $0.id == "vyd_metalu" || $0.id == "vid_metala" }) {
      mainFilters.append(metalType)
    }

    if let metalColor = filters.first(where: { $0.id == "kolir_metalu" || $0.id == "color_metal" }) {
      mainFilters.append(metalColor)
    }

    if let insert = filters.first(where: { $0.id == "vstavka" }) {
      mainFilters.append(insert)
    }

    if let insertColor = filters.first(where: { $0.id == "kolir_vstavky" || $0.id == "color_vstavka" }) {
      mainFilters.append(insertColor)
    }

    if let size = filters.first(where: { $0.id == "rozmir" || $0.id == "size" }) {
      mainFilters.append(size)
    }

    return mainFilters
  }
  
  private func rangeCellController(from filter: RangeFilter) -> RangeSliderCellController {
    let rangeController = RangeSliderCellController(filter: filter)
    rangeController.delegate = self
    return rangeController
  }
  
  private func selecFiltertCellController(from filter: SelectFilter) -> MultiSelectCellController {
    let selectController = MultiSelectCellController(filter: filter)
    selectController.delegate = self
    return selectController
  }
  
  private func manyOptionsCellController(from filter: SelectFilter) -> ManyOptionsCellController {
    let manyOptionsController = ManyOptionsCellController(filter: filter)
    manyOptionsController.delegate = self
    return manyOptionsController
  }
  
  private func getFilterResponseKey() -> FilterResponseKey {
    return (page: 1,
            categoryId: categoryId,
            sort: sortKind,
            rangeFilters: rangeFilters,
            selectFilters: selectFilters)
  }
  
  // MARK: - Interface
  func selectVariants(for filter: SelectFilter) {
    guard let filterIndex = selectFilters.firstIndex(of: filter) else { return }
    selectFilters[filterIndex] = filter
    loadFilters()
  }
  
  // MARK: - Localization
  override func localize() {
    localizeLabels()
    loadFilters()
  }
  
  func localizeLabels() {
    navigationItem.title = Localizator.standard.localizedString("Фильтр")
    selfView.setShowProductsTitle(Localizator.standard.localizedString("Показать").uppercased())
    selfView.setShowProductsSubtitle(Localizator.standard.localizedString("adornment", productsCount))
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnClose() {
    output?.didTapOnCloseFilter()
  }
  
  @objc
  private func didTapOnClearFilters() {
    for rangeIndex in 0..<rangeFilters.count {
      rangeFilters[rangeIndex].minPrice = rangeFilters[rangeIndex].min
      rangeFilters[rangeIndex].maxPrice = rangeFilters[rangeIndex].max
    }
    for filterIndex in 0..<selectFilters.count {
      for variantIndex in 0..<selectFilters[filterIndex].variants.count {
        selectFilters[filterIndex].variants[variantIndex].status = false
      }
    }
    loadFilters()
  }
  
  @objc
  private func didTapOnShowProducts() {
    guard productsCount != 0 else { return }
    output?.didTapOnShowProducts(rangeFilters: rangeFilters,
                                 selectFilters: selectFilters)
  }
  
}

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .range(let controller):
      let cell = selfView.createRangeCell(tableView: tableView, indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    case .select(let controller):
      let cell = selfView.createFilterSelectCell(tableView: tableView, indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    case .manyOptions(let controller):
      let cell = selfView.createManyOptionsFilterCell(tableView: tableView, indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    }
  }
  
}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard dataSource.indices.contains(indexPath.row) else { return }
    switch dataSource[indexPath.row] {
    case .range(let controller):
      controller.view = nil
    case .select(let controller):
      controller.view = nil
    case .manyOptions(let controller):
      controller.view = nil
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.endEditing(false)
  }
}

// MARK: - MultiSelectCellControllerDelegate
extension FilterViewController: MultiSelectCellControllerDelegate {
  func multiSelectCellController(_ controller: MultiSelectCellController, didSelectValueAt index: Int) {
    let filter = controller.filter
    filter.variants[index].status = !filter.variants[index].status 
    if let index = selectFilters.firstIndex(of: filter) {
      selectFilters[index] = filter
      loadFilters()
    }
  }
  
}

// MARK: - ManyOptionsCellControllerDelegate
extension FilterViewController: ManyOptionsCellControllerDelegate {
  func didTapOnManyOptions(at controller: ManyOptionsCellController) {
    output?.didTapOnManyOptions(with: controller.filter, from: self)
  }
  
}

// MARK: - RangeSliderCellControllerDelegate
extension FilterViewController: RangeSliderCellControllerDelegate {
  func didTextFieldsEditing(_ controller: RangeSliderCellController, sender: UITextField) {
    guard let index = rangeFilters.firstIndex(of: controller.filter) else { return }
    rangeFilters[index] = controller.filter
    checkTextFieldRange()
  }
  
  func didChangeRangeValue(_ controller: RangeSliderCellController, sender: RangeSlider) {
    guard let index = rangeFilters.firstIndex(of: controller.filter) else { return }
    rangeFilters[index] = controller.filter
    loadFilters()
  }
  
  private func checkTextFieldRange() {
    NSObject.cancelPreviousPerformRequests(withTarget: self,
                                           selector: #selector(loadFilters),
                                           object: nil)
    let delay = TimeInterval(Constants.rangeTimeInterval)
    perform(#selector(loadFilters), with: nil, afterDelay: delay)
  }
  
}

// MARK: - UITextFieldDelegate
extension FilterViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
    if let newString = newString {
      let allowedSymbolsOnly = string.rangeOfCharacter(from: Validator.allowedCharacterSet(for: .price).inverted) == nil
      return newString.withoutWhitespaces().count <= Validator.maxSymbolsCount(for: .price) && allowedSymbolsOnly
    }
    return true
  }
}
