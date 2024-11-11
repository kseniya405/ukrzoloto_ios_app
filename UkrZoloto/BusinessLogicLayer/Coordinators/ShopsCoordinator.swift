//
//  ShopsCoordinator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/19/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ShopsCoordinator: Coordinator {
  
  // MARK: - Private variables
  private weak var shopsViewController: ShopsViewController?
  private weak var filterNavController: UINavigationController?
  private weak var listingViewController: ListingViewController?
  
  // MARK: - Life cycle
  override func start(completion: (() -> Void)? = nil) {
    showShops()
  }
  
  // MARK: - Private
  private func showShops() {    
    let shopsVC = ShopsViewController(shouldDisplayOnFullScreen: false)
    shopsVC.output = self
    navigationController.pushViewController(shopsVC, animated: true)
    self.shopsViewController = shopsVC
  }
  
}

// MARK: - ShopsViewControllerOutput
extension ShopsCoordinator: ShopsViewControllerOutput {
	
	func didTapOnFilter(onlyOpenSelected: Bool, hasJewellerSelected: Bool, showOnlyOpenFilter: Bool, showHasJewellerFilter: Bool) {
		let filtersViewController = ShopsFilterViewController(shouldDisplayOnFullScreen: true)
		filtersViewController.output = self
		filtersViewController.onlyOpen = onlyOpenSelected
		filtersViewController.hasJeweller = hasJewellerSelected
		filtersViewController.showOnlyOpenFilter = showOnlyOpenFilter
		filtersViewController.showHasJewelerFilter = showHasJewellerFilter
		filtersViewController.hidesBottomBarWhenPushed = true
		navigationController.pushViewController(filtersViewController, animated: true)
	}
	
	func showSelectCityDialog(for cities: [NewCity]) {
    let citiesViewController = CitiesViewController(cities: cities, shouldDisplayOnFullScreen: true)
    citiesViewController.output = self
    citiesViewController.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(citiesViewController, animated: true)
  }
}

// MARK: - CitiesViewControllerOutput
extension ShopsCoordinator: CitiesViewControllerOutput {
  func didTapOnBack(from: CitiesViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func selectCity(_ city: NewCity?) {
    shopsViewController?.showShops(in: city)
    navigationController.popViewController(animated: true)
  }
}

extension ShopsCoordinator: ShopsFilterViewControllerOutput {
	func applyFilters(onlyOpen: Bool, hasJeweller: Bool) {
		shopsViewController?.setFilters(onlyOpen: onlyOpen, hasJeweller: hasJeweller)
		navigationController.popViewController(animated: true)
	}
	
	func didTapOnBack(from: ShopsFilterViewController) {
		navigationController.popViewController(animated: true)
	}
	
	
}
