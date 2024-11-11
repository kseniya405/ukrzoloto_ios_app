//
//  LocationSearchViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/13/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

protocol LocationSearchViewControllerOutput: AnyObject {
	func selectLocation(_ location: Location,
											deliveryCode: String,
											parentLocation: Location?,
											on viewController: LocationSearchViewController, shop: NewShopsItem?)
	func didTapOnBack(from: LocationSearchViewController)
}

class LocationSearchViewController: SearchViewController, NavigationButtoned, ErrorAlertDisplayable {
	
	// MARK: - Public variables
	var output: LocationSearchViewControllerOutput?
	
	// MARK: - Private variables
	private let selfView = SearchView<Location>()
	
	private var allLocations = [Location]()
	private var filteredLocations = [Location]()
	
	private var deliveryCode: String
	private var hostLocation: Location?
	
	// MARK: - Life cycle
	init(deliveryCode: String,
			 shouldDisplayOnFullScreen: Bool,
			 hostLocation: Location? = nil) {
		self.deliveryCode = deliveryCode
		self.hostLocation = hostLocation
		super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func loadView() {
		view = selfView
	}
	
	// MARK: - Setup
	override func initConfigure() {
		setupNavigationBar()
		addObserver()
		setupView()
		updateData()
		localize()
		loadData()
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
	
	// MARK: - Localization
	override func localize() {
		if hostLocation != nil {
			navigationItem.title = Localizator.standard.localizedString("Выбор точки выдачи")
			setSearchPlaceholder(Localizator.standard.localizedString("Я хочу найти ..."))
		} else {
			navigationItem.title = Localizator.standard.localizedString("Выбор города")
			setSearchPlaceholder(Localizator.standard.localizedString("Я хочу найти ..."))
		}
		
	}
	
	// MARK: - Actions
	private func loadData(silently: Bool = false) {
		if !silently {
			HUD.showProgress()
		}
		CartService.shared.getLocations(for: deliveryCode,
																		location: hostLocation) { [weak self] response in
			DispatchQueue.main.async {
				HUD.hide()
				guard let self = self else { return }
				switch response {
				case .failure(let error):
					self.handleError(error)
				case .success(let locations):
					let sortedLocation = self.highlightMainLocations(self.initialSortFor(locations))

					self.allLocations = sortedLocation
					self.filteredLocations = sortedLocation
					self.updateData()
				}
			}
		}
	}

	private func initialSortFor(_ locations: [Location]) -> [Location] {
		return locations.sorted(by: {
			return $0.title.localizedCompare($1.title) == ComparisonResult.orderedAscending
		})
	}
	
	private func updateData() {
		selfView.configure(viewModels: filteredLocations)
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
	
	private func highlightMainLocations(_ locations: [Location]) -> [Location] {
		var sortedLocations = locations

		var locationsResult = [Location]()

		HighlightedCities.allCases.sorted(by: { $0.rawValue < $1.rawValue }).map { $0.rawValue }.forEach { highlightedCityId in
			if let locationsListIndex = sortedLocations.firstIndex(where: { $0.id == highlightedCityId }) {
				locationsResult.append(sortedLocations[locationsListIndex])
				sortedLocations.remove(at: locationsListIndex)
			}
		}

		locationsResult.append(contentsOf: sortedLocations)
		
		return locationsResult
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
extension LocationSearchViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		guard let text = searchBar.text, text.count >= 2 else {
			if searchBar.text?.count == 1 {
				setOneDigitView()
			} else {
				filteredLocations = allLocations
				updateData()
			}

			return
		}

		applyFiltrationBy(text: text)

		if filteredLocations.isEmpty {
			setNoFoundView()
		} else {
			updateData()
		}
	}

	private func applyFiltrationBy(text: String) {
		let oneWordSlice = allLocations.filter({ $0.title.lowercased().hasPrefix(text.lowercased()) }).sorted(by: { $0.title < $1.title })
			//allLocations.filter({ $0.title.lowercased().contains(text.lowercased()) }).sorted(by: { $0.title < $1.title })
		
    filteredLocations = oneWordSlice

    let restTwoWordNameLocation = Array(Set(allLocations).subtracting(Set(oneWordSlice))).filter({ $0.title.contains(" ") })

    var sortedTwoWordNameLocation = [Location]()

    restTwoWordNameLocation.forEach { someLocation in
      let locatonNameSubpieces = someLocation.title.components(separatedBy: " ")
      locatonNameSubpieces.forEach {
				if hostLocation == nil {
					if $0.lowercased().hasPrefix(text.lowercased()) {
						sortedTwoWordNameLocation += [someLocation]
					}
				} else {
					var modifiedTitle = $0
					if (deliveryCode == "novaposhta_parcel_lockers" ||
							deliveryCode == "novaposhta_warehouse") &&
							(modifiedTitle.contains("№") ) {
						modifiedTitle.removeFirst()
					}
					if modifiedTitle.lowercased().hasPrefix(text.lowercased()) {
						sortedTwoWordNameLocation += [someLocation]
					}
				}
      }
    }

    sortedTwoWordNameLocation = sortedTwoWordNameLocation.sorted(by: { $0.title < $1.title })

    filteredLocations += sortedTwoWordNameLocation

    filteredLocations = highlightMainLocations(filteredLocations)
  }
}

// MARK: - SearchViewOutput
extension LocationSearchViewController: SearchViewOutput {
	func didSelect<T>(viewModel: T) {
		guard let viewModel = viewModel as? Location,
			let selectedLocation = allLocations.first(where: { $0.id == viewModel.id }) else {
				return
		}
		output?.selectLocation(selectedLocation,
													 deliveryCode: deliveryCode,
													 parentLocation: hostLocation,
													 on: self, shop: nil)
	}
}

enum DeliveryCode {
	static let selfDelivery = "self"
	static let address = "address"
	static let novaPoshtaLocation = "novaposhta_warehouse"
	static let novaPoshtaAddress = "novaposhta_courier"
	static let novaPoshtaParcelLockers = "novaposhta_parcel_lockers"
}
