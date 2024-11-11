//
//  LocationShopsViewController.swift
//  UkrZoloto
//
//  Created by user on 19.08.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import AUIKit
import BetterSegmentedControl
import ClusterKit
import GoogleMaps
import PKHUD

protocol LocationShopsViewControllerOutput: AnyObject {
  func selectLocation(_ location: Location,
                      parentLocation: Location,
											on viewController: LocationShopsViewController, shop: NewShopsItem?)
  func didTapOnBack(from: LocationShopsViewController)
	func didTapOnFilter(onlyOpenSelected: Bool, hasJewellerSelected: Bool, showOnlyOpenFilter: Bool, showHasJewellerFilter: Bool)
}

class LocationShopsViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {

  // MARK: - Public variables
	var output: LocationShopsViewControllerOutput? 
  
  // MARK: - Private variables
	private var isFiltered = false
	private var onlyOpen = false
	private var hasJeweller = false
	private var showOnlyOpenFilter = true
	private var showHasJewellerFilter = false
	private var pageForLoad = 1
	private var loadedPage = 0
	private var hasFilterButton = true
  private let selfView = ShopsDeliveryView()
	private let filterButton = ButtonsFactory.filterButtonForNavItem()
	private let tableViewController = ScrollableTableViewController()
  
  private var clusterManager: GMUClusterManager?
  private var shopsClusterItems: [MapClusterItem: NewShopsItem] = [:]
  private var city: NewCity?
  private var selectedShop: NewShopsItem?
	
	private var shopItems = [NewShopsItem]()
	private var coordinates = [ShopCoordinates]()
	
	private var hostLocation: Location
	
	private var associatedShops: [ASTHashedReference: NewShopsItem] = [:]
  
  // MARK: - Life cycle
  init(hostLocation: Location,
       shouldDisplayOnFullScreen: Bool) {
    self.hostLocation = hostLocation
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
    view = selfView
  }

  override func viewDidAppear(_ animated: Bool) {
    setupMapViewIfNeeded()

    super.viewDidAppear(animated)
  }

  // MARK: - Setup
  override func initConfigure() {
    setupNavigationBar()
    setupView()
  }
  
  private func setupNavigationBar() {
    addNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
		updateNavigationButtons()
		setNavigationButton(#selector(didTapOnFilter),
												button: filterButton,
												side: .right)
	}
	
	private func updateNavigationButtons() {
		filterButton.setImage(isFiltered ? #imageLiteral(resourceName: "activeFilterIcon") : #imageLiteral(resourceName: "filterIcon"),
													for: .normal)
	}
  
  private func setupView() {
    if let tabBarHeight = tabBarController?.tabBar.frame.height {
      let bottom = tabBarHeight - Constants.Screen.bottomSafeAreaInset - MainTabBarController.centerItemOffset
      additionalSafeAreaInsets = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: bottom,
                                              right: 0)
    }
    setupSelfView()
    localize()
  }
  
  private func setupSelfView() {
    selfView.getRefreshControl().addTarget(self,
                                           action: #selector(refresh),
                                           for: .valueChanged)
    selfView.getSegmentedControl().addTarget(self,
                                             action: #selector(segmentedControlValueChanged(_:)),
                                             for: .valueChanged)
    selfView.getSaveButton().addTarget(self,
                                       action: #selector(didTapOnSaveButton),
                                       for: .touchUpInside)
		selfView.getShopInfoView().getCloseButton().addTarget(self,
																										 action: #selector(didTapOnCloseInfoButton),
																										 for: .touchUpInside)
		tableViewController.view = selfView.getTableView()
		selfView.shopCellDelegate = self
		selfView.hideShopInfoView()
  }
  
  private func configureClusterManager() {
    let mapView = selfView.getMapView()
    let iconGenerator = MapIconGenerator()
    let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
    renderer.delegate = self
    clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
    clusterManager?.setDelegate(self, mapDelegate: self)
  }
  
  override func localize() {
    navigationItem.title = Localizator.standard.localizedString("Выбор магазина")
    selfView.setTabTitles([Localizator.standard.localizedString("Списком"),
                           Localizator.standard.localizedString("На карте")])
    selfView.getSaveButton().setTitle("Выбрать".localized().uppercased(), for: .normal)
		loadData()
  }
  
	private func loadData(silently: Bool = false) {
		if !silently {
			HUD.showProgress()
		}
		var parameters: [String: Any] = [:]
		parameters["page"] = pageForLoad
		if let city = city?.id {
			parameters["city"] = city
		}
		if onlyOpen {
			parameters["open"] = 1
		}
		if hasJeweller {
			parameters["jeweler"] = 1
		}
		ShopsService.shared.getShopsList(parameters: parameters) { [weak self] response in
				DispatchQueue.main.async {
			 HUD.hide()
			 guard let self = self else { return }
			 self.selfView.getRefreshControl().endRefreshing()
			 switch response {
			 case .failure(let error):
				 self.handleError(error)
			 case .success(let shops):
				 self.setupDataSource(shops)
			 }
			}
		}
	}
	
	private func setupDataSource(_ shops: NewShops?) {
		if let cities = shops?.cities, let city = cities.first(where: { $0.title == self.hostLocation.title }) {
			if city != self.city {
				self.city = city
				selfView.hideShopInfoView()
				self.shopItems = []
				self.coordinates = []
				self.pageForLoad = 1
				loadData()
				return
			}
		}
		if let onlyOpenFilter = shops?.filter?.filterOpen {
			showOnlyOpenFilter = onlyOpenFilter > 0
		}
		if let hasJewellerilter = shops?.filter?.jeweler {
			showHasJewellerFilter = hasJewellerilter > 0
		}
		if !showOnlyOpenFilter && !showHasJewellerFilter {
			removeButtonItemOn(.right)
			hasFilterButton = false
		} else if !hasFilterButton {
			setupNavigationBar()
		} else {
			updateNavigationButtons()
		}
		if let shopItems = shops?.items, let coordinates = shops?.coordinates {
			self.loadedPage = self.pageForLoad
      if !shopItems.isEmpty {
				self.shopItems.append(contentsOf: shopItems)
				self.coordinates.append(contentsOf: coordinates)
				self.pageForLoad += 1
			}
		}
		displayShops(shopItems)
		setupMapViewIfNeeded()
		reloadCellControllers()
	}
	
  private func reloadCellControllers() {
    associatedShops = [:]
    var sectionControllers = [AUIDefaultTableViewSectionController]()
    let sectionController = shopsSection(from: shopItems)
    sectionControllers.append(sectionController)
    sectionControllers.forEach { $0.cellControllers.forEach {
      $0.didSelectDelegate = self
      $0.willDisplayDelegate = self
    }
    }
    tableViewController.sectionControllers = sectionControllers
    tableViewController.reload()
  }
	
	private func shopsSection(from shops: [NewShopsItem]) -> AUIDefaultTableViewSectionController {
		let sectionController = AUIDefaultTableViewSectionController()
		var cellControllers = [AUIElementTableViewCellController]()
		if !shops.isEmpty {
			shops.forEach { shop in
				let selectionController = ShopViewCellController()
				selectionController.titleViewModel = TitleViewModel(title: shop.title ?? "")
				selectionController.isShorView = true
				selectionController.shop = shop
				cellControllers.append(AUIElementTableViewCellController(controller: selectionController,
																																 cell: selfView.createShopCell))
				associatedShops[ASTHashedReference(selectionController)] = shop
			}
		}
		sectionController.cellControllers = cellControllers
		return sectionController
	}
	
	func setFilters(onlyOpen: Bool, hasJeweller: Bool) {
		if onlyOpen != self.onlyOpen || hasJeweller != self.hasJeweller {
			self.isFiltered = onlyOpen || hasJeweller
			self.onlyOpen = onlyOpen
			self.hasJeweller = hasJeweller
			self.shopItems = []
			self.coordinates = []
			self.pageForLoad = 1
			loadData()
		}
	}
	
	func showOnMap(shop: NewShopsItem) {
		guard let coordinates = shop.coordinates else { return }
		selfView.showMap()
		selfView.moveCamera(to: coordinates, zoom: Constants.Location.shopZoom)
		selfView.getShopInfoView().setData(shop: shop)
		self.selectedShop = shop
		selfView.showShopInfoView()
	}
  
  private func displayShops(_ shops: [NewShopsItem]) {
		configureClusterManager()
		shopsClusterItems.removeAll()
		var items = [MapClusterItem]()
		for shop in shops {
			if let coordinates = shop.coordinates {
				let clusterItem = MapClusterItem(position: coordinates, icon: UIConstants.availableMarker)
				shopsClusterItems[clusterItem] = shop
				items.append(clusterItem)
			}
		}
		clusterManager?.clearItems()
		clusterManager?.add(items)
		clusterManager?.cluster()
    moveCameraToTheCenter()
  }
  
  private func setupMapViewIfNeeded() {
		selfView.configureMapView()
		configureClusterManager()
	guard !shopItems.isEmpty, !coordinates.isEmpty else {
		selfView.moveCamera(to: Constants.Location.kievCenter)
		return
	}
		displayShops(shopItems)
		moveCameraToTheCenter()
  }
  
  private func moveCameraToTheCenter() {
		guard !shopItems.isEmpty, !coordinates.isEmpty else {
			selfView.moveCamera(to: Constants.Location.kievCenter)
			return
		}
		let citiesShopsCoordinates = shopItems.compactMap { $0.coordinates }
		let centerOfShopsCoordinates = shopItems.count == coordinates.count ? citiesShopsCoordinates.center() : Constants.Location.kievCenter
			let zoom = getZoomRateFor(citiesShopsCoordinates)
			selfView.moveCamera(to: centerOfShopsCoordinates, zoom: zoom)
  }

  private func getZoomRateFor(_ coordinates: [CLLocationCoordinate2D]) -> Float {
    let pointsSortedByLatitude = coordinates.sorted(by: { $0.latitude < $1.latitude })
    let mostDistanceByLatitude = self.distanceFrom(pointsSortedByLatitude.first!, to: pointsSortedByLatitude.last!)

    let pointsSortedByLongitude = coordinates.sorted(by: { $0.longitude < $1.longitude })
    let mostDistanceByLongitude = self.distanceFrom(pointsSortedByLongitude.first!, to: pointsSortedByLongitude.last!)

    let mostDistance = mostDistanceByLatitude > mostDistanceByLongitude ? mostDistanceByLatitude : mostDistanceByLongitude

    if mostDistance == 0 {
      return 15
    } else if mostDistance < 10 {
      return 40
    } else if mostDistance < 100 {
      return 30
    } else if mostDistance < 1000 {
      return 15
    } else if mostDistance < 10000 {
      return 12
    } else if mostDistance < 30000 {
      return 10.5
    } else {
      return Constants.Location.defaultZoom
    }
  }

  private func distanceFrom(
    _ firstPoint: CLLocationCoordinate2D,
    to secondPoint: CLLocationCoordinate2D) -> CLLocationDistance {
      return CLLocation(latitude: firstPoint.latitude, longitude: firstPoint.longitude)
        .distance(from: CLLocation(latitude: secondPoint.latitude, longitude: secondPoint.longitude))
    }
  
  // MARK: - Interface
  
  // MARK: - Actions
	@objc
	private func didTapOnFilter() {
		output?.didTapOnFilter(onlyOpenSelected: onlyOpen, hasJewellerSelected: hasJeweller, showOnlyOpenFilter: showOnlyOpenFilter, showHasJewellerFilter: showHasJewellerFilter)
	}
	
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func refresh() {
    loadData(silently: true)
  }
  
  @objc
  private func segmentedControlValueChanged(_ sender: BetterSegmentedControl) {
    if sender.index == 0 {
			selfView.showList()
			selfView.hideShopInfoView()
			displayShops(shopItems)
			setupMapViewIfNeeded()
		} else {
      selfView.showMap()
    }
  }
  
  @objc
  private func didTapOnSaveButton() {
    guard let selectedShop = selectedShop else { return }
    output?.selectLocation(Location(shop: selectedShop),
                           parentLocation: hostLocation,
													 on: self, shop: selectedShop)
  }
	
	@objc
	private func didTapOnCloseInfoButton() {
		guard !selfView.getShopInfoView().isHidden else { return }
		selfView.hideShopInfoView()
	}
	
	private func didSelectCell(atIndexPath indexPath: IndexPath) {
	 if let cellController = tableViewController.sectionControllers[indexPath.section].cellControllers[indexPath.row] as? AUIElementTableViewCellController,
							let shop = associatedShops[ASTHashedReference(cellController.controller)] {
			showOnMap(shop: shop)
		}
	}
}

// MARK: - AUITableViewCellControllerDidSelectDelegate
extension LocationShopsViewController: AUITableViewCellControllerDidSelectDelegate {
	func didSelectTableViewCellController(_ cellController: AUITableViewCellController) {
		for (sectionIndex, sectionController) in tableViewController.sectionControllers.enumerated() {
			for (cellIndex, controller) in sectionController.cellControllers.enumerated() where controller === cellController {
				didSelectCell(atIndexPath: IndexPath(row: cellIndex, section: sectionIndex))
			}
		}
	}
}

extension LocationShopsViewController: AUITableViewCellControllerWillDisplayDelegate {
	func willDisplayTableViewCellController(_ cellController: any AUIKit.AUITableViewCellController, indexPath: IndexPath) {
		if indexPath.row > 8, indexPath.row == shopItems.count - 1, self.pageForLoad > self.loadedPage {
			loadData()
		}
	}
}

// MARK: - GMSMapViewDelegate
extension LocationShopsViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    //        mapView.clusterManager.updateClustersIfNeeded()
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    if let shopItem = marker.userData as? MapClusterItem,
       let shop = shopsClusterItems[shopItem] {
      self.selectedShop = shop
      selfView.configureSelectedShopInfoView(shop: shop)
			selfView.moveCamera(to: marker.position, zoom: Constants.Location.shopZoom)
			selfView.showShopInfoView()
    }
    return true
  }
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    if !selfView.getShopInfoView().isHidden {
      selfView.hideShopInfoView()
    }
  }
}

// MARK: - GMUClusterManagerDelegate
extension LocationShopsViewController: GMUClusterManagerDelegate {
  func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
    let mapView = selfView.getMapView()
    selfView.moveCamera(to: cluster.position,
                        zoom: mapView.camera.zoom + Constants.Location.zoomStep)
    return true
  }
  
}

// MARK: - GMUClusterRendererDelegate
extension LocationShopsViewController: GMUClusterRendererDelegate {
  func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
    guard let clusterItem = object as? MapClusterItem else { return nil }
    let marker = ShopMapMarker(position: clusterItem.position)
    marker.configure(icon: clusterItem.icon)
    return marker
  }
}

extension LocationShopsViewController: ShopInfoViewXIBDelegate {
	func needUIUpdates() {
		tableViewController.tableView?.performBatchUpdates(nil)
	}
}

// MARK: - UIConstants
private enum UIConstants {
  enum Cell {
    static let image = #imageLiteral(resourceName: "iconsShops")
    static let font = UIFont.systemFont(ofSize: 14)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let edgeInsets = UIEdgeInsets(top: 0,
                                         left: 24,
                                         bottom: 0,
                                         right: 24)
  }
	
	static let availableMarker = #imageLiteral(resourceName: "ShopMarker")
}
