//
//  SearchResultFilterViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/27/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD
import WARangeSlider

protocol SearchResultFilterViewControllerOutput: AnyObject {
  func didTapOnCloseFilter(from vc: SearchResultFilterViewController)
  func didTapOnManyOptions(with filter: SelectFilter, from vc: SearchResultFilterViewController)
  func didTapOnShowProducts(rangeFilters: [RangeFilter], selectFilters: [SelectFilter], from vc: SearchResultFilterViewController, searchResult: SearchPageData)
}

class SearchResultFilterViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: SearchResultFilterViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = FilterView()
  
  private var dataSource = [FilterItem]()
  
  private let searchText: String
  private var rangeFilters = [RangeFilter]()
  private var selectFilters = [SelectFilter]()
  private var initialSearchPageData: SearchPageData = .zero
  private var searchResult: SearchPageData = .zero
  
  private var productsCount = 0
  
  // MARK: - Life cycle
  init(searchText: String,
       rangeFilters: [RangeFilter],
       selectFilters: [SelectFilter],
       shouldDisplayOnFullScreen: Bool,
       initialSearchPageData: SearchPageData) {
    self.searchText = searchText
    self.rangeFilters = rangeFilters
    self.selectFilters = selectFilters
    self.initialSearchPageData = initialSearchPageData

    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.setupDataSource(self.initialSearchPageData)
    self.selfView.setShowProductsSubtitle(Localizator.standard.localizedString("adornment", self.initialSearchPageData.pagination.total))
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
  }
  
  // MARK: - Setup
  override func initConfigure() {
    super.initConfigure()
    setupView()
    localizeLabels()
    logViewSearchResult()
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
  
  private func logViewSearchResult() {
    EventService.shared.logSearchResults(search: searchText)
  }
  
  @objc
  private func loadFilters() {
    HUD.showProgress()
    SearchService.shared.search(for: getSearchResponseInfo()) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success(let searchData):
          self.setupDataSource(searchData)
          self.selfView.setShowProductsSubtitle(Localizator.standard.localizedString("adornment", searchData.pagination.total))
        }
      }
    }
  }
  
  // MARK: - Private methods
  private func setupDataSource(_ searchData: SearchPageData) {
    dataSource.removeAll()
    
    rangeFilters = searchData.rangeFilters

    dataSource.append(contentsOf: rangeFilters.compactMap { filter -> FilterItem? in
      let rangeController = rangeCellController(from: filter)
      return FilterItem.range(rangeController)
    })
    
    selectFilters = searchData.selectFilters
    setupDataSource(for: selectFilters)
    
    productsCount = searchData.products.count

    searchResult = searchData
    
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
  
  private func getSearchResponseInfo() -> SearchResponseInfo {
    return (searchText: searchText,
            page: 1,
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
  
  private func localizeLabels() {
    navigationItem.title = Localizator.standard.localizedString("Фильтр")
    selfView.setShowProductsTitle(Localizator.standard.localizedString("Показать").uppercased())
    selfView.setShowProductsSubtitle(Localizator.standard.localizedString("adornment", productsCount))
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnClose() {
    output?.didTapOnCloseFilter(from: self)
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
    EventService.shared.filterWasApplied()

//    self.selectFilters.forEach { filterCategory in
//      filterCategory.variants.forEach { filter in
//        if filter.status == true {
//          print("  ☄️  ********* Show SEARCH RESULT -> \(filter.slug)")
//        }
//      }
//    }

    output?.didTapOnShowProducts(rangeFilters: rangeFilters,
                                 selectFilters: selectFilters,
                                 from: self,
                                 searchResult: searchResult)
  }
}

// MARK: - UITableViewDataSource
extension SearchResultFilterViewController: UITableViewDataSource {
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
extension SearchResultFilterViewController: UITableViewDelegate {
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
}

// MARK: - MultiSelectCellControllerDelegate
extension SearchResultFilterViewController: MultiSelectCellControllerDelegate {
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
extension SearchResultFilterViewController: ManyOptionsCellControllerDelegate {
  func didTapOnManyOptions(at controller: ManyOptionsCellController) {
    output?.didTapOnManyOptions(with: controller.filter,
                                from: self)
  }
  
}

// MARK: - RangeSliderCellControllerDelegate
extension SearchResultFilterViewController: RangeSliderCellControllerDelegate {
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
extension SearchResultFilterViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
    if let newString = newString {
      let allowedSymbolsOnly = string.rangeOfCharacter(from: Validator.allowedCharacterSet(for: .price).inverted) == nil
      return newString.withoutWhitespaces().count <= Validator.maxSymbolsCount(for: .price) && allowedSymbolsOnly
    }
    return true
  }
}
