//
//  CitiesViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 22.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

public enum HighlightedCities: Int, CaseIterable {
	case kyivCityId = 1
	case odessaCityId = 31
	case kharkivCityId = 32
	case dniproCityId = 2
	case lvivCityId = 41
	case poltavaCityId = 23
	case zaporizhzhiaCityId = 40
	case vinnytsiaCityId = 5
	case khmelnitskyCityId = 30
	case cherkasyCityId = 26
	case kyivDeliveryCityId = 27193
	case odessaDeliveryCityId = 28280
	case kharkivDeliveryCityId = 29581
	case dniproDeliveryCityId = 26695
	case lvivDeliveryCityId = 27668
	case poltavaDeliveryCityId = 28646
	case zaporizhzhiaDeliveryCityId = 26923
	case vinnytsiaDeliveryCityId = 26297
	case khmelnitskyDeliveryCityId = 29597
	case cherkasyDeliveryCityId = 29699
}

public enum HighlightedCitiesForShops: String, CaseIterable {
	case kyivCityId = "kiev"
	case odessaCityId = "odessa"
	case kharkivCityId = "harkov"
	case dniproCityId = "dnepr"
	case lvivCityId = "lvov"
	case poltavaCityId = "poltava"
	case zaporizhzhiaCityId = "zaporozhe"
	case vinnytsiaCityId = "vinnica"
	case khmelnitskyCityId = "hmelnitskij"
	case cherkasyCityId = "cherkassy"
	
	case kyivCityIdUa = "kyiv"
	case odessaCityIdUa = "odesa"
	case kharkivCityIdUa = "kharkiv"
	case dniproCityIdUa = "dnipro"
	case lvivCityIdUa = "lviv"
	case zaporizhzhiaCityIdUa = "zaporizhzhia"
	case vinnytsiaCityIdUa = "vinnytsia"
	case khmelnitskyCityIdUa = "khmelnytskyi"
	case cherkasyCityIdUa = "cherkasy"
}

public class HighlightedCitiesAdapter {
	private static let citiesDict: [String: Int] = [
		"kyiv": 1,
		"kiev": 1,
		"odesa": 31,
		"odessa": 31,
		"kharkiv": 32,
		"harkov": 32,
		"dnipro": 2,
		"dnepr": 2,
		"lviv": 41,
		"lvov": 41,
		"poltava": 23,
		"zaporizhzhia": 40,
		"zaporozhe": 40,
		"vinnytsia": 5,
		"vinnica": 5,
		"khmelnytskyi": 30,
		"hmelnitskij": 30,
		"cherkasy": 26,
		"cherkassy": 26
	]
	
	static func getNumberID(for city: HighlightedCitiesForShops) -> Int? {
		citiesDict[city.rawValue]
	}
}


protocol CitiesViewControllerOutput: AnyObject {
  func selectCity(_ city: NewCity?)
  func didTapOnBack(from: CitiesViewController)
}

enum CityItem {
	case city(_ city: NewCity)
  case allCities
}

class CitiesViewController: SearchViewController, NavigationButtoned {
  // MARK: - Public variables
  var output: CitiesViewControllerOutput?

  // MARK: - Private variables
  private let selfView = SearchView<CityViewModel>()

  private var dataSource = [CityItem]()
	private var cities: [NewCity] = []
  private var filterCities: [NewCity] = []

  // MARK: - Life cycle
	init(cities: [NewCity],
       shouldDisplayOnFullScreen: Bool) {
    self.filterCities = cities
    self.cities = cities
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func loadView() {
    view = selfView
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  // MARK: - Setup
  override func initConfigure() {
    setupNavigationBar()
    addObserver()
    setupView()
    updateData()
    localize()
  }

  private func setupView() {
    setupSelfView()
    setupSearchBar()
  }

  private func setupNavigationBar() {
    addNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
  }

  private func addObserver() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }

  private func setupSelfView() {
    view.backgroundColor = UIConstants.SelfView.backgroundColor
    selfView.delegate = self
  }

  private func setupSearchBar() {
    searchBarDelegate = self
  }

  private func updateData() {
    dataSource.removeAll()

    if filterCities.count == cities.count {
      dataSource.append(.allCities)
    }

    filterCities = highlightMainCities(filterCities)

    filterCities.forEach { dataSource.append(.city($0)) }

    selfView.configure(viewModels: createViewModels(for: dataSource))
  }

  private func setOneDigitView() {
    let text = Localizator.standard.localizedString("Для поиска введите больше двух символов")
    selfView.setSearchError(text: text,
                            image: #imageLiteral(resourceName: "component51"))
  }

  private func setNoFoundView() {
    let text = Localizator.standard.localizedString("Результатов не найдено\nПроверьте правильность ввода")
    selfView.setSearchError(text: text,
                            image: #imageLiteral(resourceName: "component51"))
  }

  private func createViewModels(for items: [CityItem]) -> [CityViewModel] {
    var viewModels = [CityViewModel]()
    var title = String()
    var id = String()
    var isHighlighted = false
    for item in items {
      switch  item {
      case .allCities:
        title = "Все города".localized()
				id = "allCities"
      case .city(let city):
        id = city.id
        title = city.title
        isHighlighted = HighlightedCitiesForShops.allCases.map { $0.rawValue }.contains(city.id)
      }
      viewModels.append(CityViewModel(id: id, title: title, isHighlighted: isHighlighted))
    }
    return viewModels
  }

  // MARK: - Localization
  override func localize() {
    navigationItem.title = Localizator.standard.localizedString("Выбор города")
  }

  // MARK: - Actions
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }

  @objc private func keyboardWillShow(notification: NSNotification) {
    guard let kbSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    guard let kbDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
    animateToBottomOffset(kbSizeValue.cgRectValue.height,
                          duration: kbDuration.doubleValue)
  }

  @objc private func keyboardWillHide(notification: NSNotification) {
    animateToBottomOffset(0, duration: 0)
  }

  private func animateToBottomOffset(_ offset: CGFloat, duration: Double) {
    UIView.animate(withDuration: duration) { [weak self] in
      guard let self = self else { return }
      self.selfView.setTableBottomInset(offset)
    }
  }

}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
  }

}

// MARK: - UISearchBarDelegate
extension CitiesViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard let text = searchBar.text, text.count >= 2 else {
      if searchBar.text?.count == 1 {
        setOneDigitView()
      } else {
        filterCities = cities
        updateData()
      }
      return
    }

    self.applyCityFiltrationBy(text: text)

    if filterCities.isEmpty {
      setNoFoundView()
    } else {
      updateData()
    }
  }

  private func applyCityFiltrationBy(text: String) {
		let beginingMatchSorted = Array(cities.filter({ $0.title.lowercased().hasPrefix(text.lowercased()) }).sorted(by: { $0.id < $1.id }))

    filterCities = beginingMatchSorted

    let restTwoWordNameLocation =  Array(Set(cities).subtracting(Set(beginingMatchSorted))).filter({ $0.title.contains(" ") })

    restTwoWordNameLocation.forEach { someLocation in
      let locatonNameSubpieces = someLocation.title.components(separatedBy: " ")
      locatonNameSubpieces.forEach {
        if $0.lowercased().hasPrefix(text.lowercased()) {
          filterCities += [someLocation]
        }
      }
    }
  }

	private func highlightMainCities(_ allCities: [NewCity]) -> [NewCity] {
    var sortedCities = allCities.sorted(by: {
      return $0.title.localizedCompare($1.title) == ComparisonResult.orderedAscending
    })

		var citiesResult: [NewCity] = []

		HighlightedCitiesForShops.allCases.sorted(by: { HighlightedCitiesAdapter.getNumberID(for: $0) < HighlightedCitiesAdapter.getNumberID(for: $1) }).map { $0.rawValue }.forEach { highlightedCityId in
      if let highlightedLocation = sortedCities.first(where: { $0.id == highlightedCityId }) {
        citiesResult.append(highlightedLocation)

        sortedCities.removeAll(where: { $0.id == highlightedLocation.id })
      }
    }

		citiesResult.append(contentsOf: sortedCities)

    return citiesResult
  }
}

// MARK: - SearchViewOutput
extension CitiesViewController: SearchViewOutput {
  func didSelect<T>(viewModel: T) {
    guard let viewModel = viewModel as? CityViewModel else { return }
		let selectedCity = cities.first(where: { $0.id == viewModel.id })
    output?.selectCity(selectedCity)
  }
}
