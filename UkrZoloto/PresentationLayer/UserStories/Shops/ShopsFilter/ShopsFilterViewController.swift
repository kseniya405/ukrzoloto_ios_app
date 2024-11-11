//
//  ShopsFilterViewController.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 23.06.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import UIKit

protocol ShopsFilterViewControllerOutput: AnyObject {
	func applyFilters(onlyOpen: Bool, hasJeweller: Bool)
	func didTapOnBack(from: ShopsFilterViewController)
}

class ShopsFilterViewController: LocalizableViewController, NavigationButtoned {
	// MARK: - Public variables
	var output: ShopsFilterViewControllerOutput?
	
	// MARK: - Private variables
	private let selfView = ShopsFilterFilter.initFromNib() as! ShopsFilterFilter
	
	var onlyOpen = false
	
	var hasJeweller = false
	
	var showOnlyOpenFilter = true
	
	var showHasJewelerFilter = true
	
	private var titles = [String]()
	
	override func loadView() {
		view = selfView
	}
	
	// MARK: - Setup
	override func initConfigure() {
		setupNavigationBar()
		setupView()
		loadData()
		localize()
	}
	
	private func setupView() {
		setupSelfView()
	}
	
	private func setupNavigationBar() {
		addNavigationButton(#selector(didTapOnBack),
												button: ButtonsFactory.backButtonForNavigationItem(),
												side: .left)
		addNavigationButton(#selector(didTapOnClearFilters),
												button: ButtonsFactory.clearFilterButtonForNavItem(),
												side: .right)
	}
	
	private func setupSelfView() {
		selfView.applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
		configureTable()
	}
	
	private func configureTable() {
		selfView.tableView.delegate = self
		selfView.tableView.dataSource = self
		selfView.tableView.register(UINib(nibName: "ShopsFilterTableViewCell", bundle: nil), forCellReuseIdentifier: UIConstants.ReuseIdentifiers.selectedCityCell)
		
	}
	
	private func loadData() {
		titles = []
		if showOnlyOpenFilter {
			titles.append(Localizator.standard.localizedString("Только открытые"))
		}
		if showHasJewelerFilter {
			titles.append(Localizator.standard.localizedString("Есть ювелир"))
		}
		selfView.tableView.reloadData()
	}
	
	// MARK: - Localization
	override func localize() {
		navigationItem.title = Localizator.standard.localizedString("Фильтр")
	}
	
	// MARK: - Actions
	@objc
	private func didTapOnBack() {
		output?.didTapOnBack(from: self)
	}
	
	@objc
	private func didTapOnClearFilters() {
		onlyOpen = false
		hasJeweller = false
		selfView.tableView.reloadData()
	}
	
	@objc
	private func applyFilters() {
		output?.applyFilters(onlyOpen: onlyOpen, hasJeweller: hasJeweller)
	}

	}

extension ShopsFilterViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		titles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ShopsFilterTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.selectedCityCell,
																																			 for: indexPath)
		switch indexPath.row {
		case 0:
			if showOnlyOpenFilter {
				cell.setup(isSelected: onlyOpen, title: titles.first ?? "", showSeparator: titles.count > 1)
			} else {
				cell.setup(isSelected: hasJeweller, title: titles.last ?? "", showSeparator: false)
			}
		case 1:
			cell.setup(isSelected: hasJeweller, title: titles.last ?? "", showSeparator: false)
		default:
			break
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		switch indexPath.row {
		case 0:
			onlyOpen.toggle()
		case 1:
			hasJeweller.toggle()
		default:
			break
		}
		tableView.deselectRow(at: indexPath, animated: false)
		tableView.reloadData()
		return indexPath
	}
	
}

private enum UIConstants {
	
	enum ReuseIdentifiers {
		static let selectedCityCell = "shopFilterCell"
	}
	
	enum ShopInfoView {
		static let height: CGFloat = 353
		static let sides: CGFloat = 16
		static let bottom: CGFloat = 353 + Constants.Screen.topSafeAreaInset
	}
}
