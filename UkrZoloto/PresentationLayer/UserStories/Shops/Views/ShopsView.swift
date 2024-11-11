//
//  ShopsView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/19/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit
import BetterSegmentedControl
import ClusterKit
import GoogleMaps
import SnapKit

class ShopsView: RoundedContainerView {
	
	weak var shopCellDelegate: ShopInfoViewXIBDelegate?

  // MARK: - Private variables
  private let segmentedControl = BetterSegmentedControl()
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let refreshControl = UIRefreshControl()
  
  private var mapView = GMSMapView(frame: .zero,
                                   camera: GMSCameraPosition(target: Constants.Location.kievCenter,
                                                             zoom: Constants.Location.defaultZoom))
	
	private let shopInfoView = ShopInfoViewXIB.initFromNib() as! ShopInfoViewXIB
  
  override func layoutSubviews() {
    super.layoutSubviews()
    subviews.forEach { $0.layoutIfNeeded() }
  }
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  private func configureSelf() {
    configureSegmentedControl()
    configureMapView()
    configureShopInfoView()
    configureTableView()
    configureRefreshControl()
//    shopInfoView.localize()
    shopInfoView.isHidden = true
  }
  
  private func configureSegmentedControl() {
    addHeaderSubview(segmentedControl)
    segmentedControl.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(UIConstants.SegmentedControl.inset)
      make.height.equalTo(UIConstants.SegmentedControl.height)
      make.top.bottom.equalToSuperview()
				.inset(20)
    }
  }
  
  private func configureTableView() {
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
		tableView.backgroundColor = UIConstants.TableView.backgroundColor
    tableView.contentInset.bottom = UIConstants.TableView.bottomInset
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 373
    registerCells()
  }
  
  private func configureRefreshControl() {
    tableView.addSubview(refreshControl)
  }
  
  private func registerCells() {
    tableView.register(AUIReusableTableViewCell.self, forCellReuseIdentifier: UIConstants.ReuseIdentifiers.selectedCityCell)
    tableView.register(AUIReusableTableViewCell.self, forCellReuseIdentifier: UIConstants.ReuseIdentifiers.shopCell)
    tableView.register(AUIReusableTableViewCell.self, forCellReuseIdentifier: UIConstants.ReuseIdentifiers.availabilityCell)
  }
  
  private func configureShopInfoView() {
    mapView.addSubview(shopInfoView)
    shopInfoView.snp.remakeConstraints { make in
			make.top.equalTo(mapView.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.greaterThanOrEqualTo(UIConstants.ShopInfoView.height)
    }
  }

  // MARK: - Interface
  func setTabTitles(_ titles: [String]) {
		
    let segments = AligmentLabelSegment.segments(withTitles: titles,
                                                 normalFont: UIConstants.SegmentedControl.textFont,
                                                 normalTextColor: UIConstants.SegmentedControl.textColor,
                                                 selectedFont: UIConstants.SegmentedControl.textFont,
                                                 selectedTextColor: UIConstants.SegmentedControl.selectedTextColor,
                                                 textAlignment: .center,
																								 segmentSpace: 10,
																								 cornerRadius: 20,
																								 normalBorderColor: UIColor(red: 0.051, green: 0.408, blue: 0.263, alpha: 1),
																								 selectedBorderColor: UIColor(named: "yellow"),
																								 borderWidth: 1)

    segmentedControl.segments = segments
		segmentedControl.setOptions([.indicatorViewInset(0)])
		segmentedControl.segments.forEach { segment in
			segment.normalView.layer.cornerRadius = 20
			segment.normalView.layer.masksToBounds = true
			segment.normalView.backgroundColor = Constants.AppColors.mainGreenColor

			segment.selectedView.layer.cornerRadius = 20
			segment.selectedView.layer.masksToBounds = true
			segment.selectedView.backgroundColor = UIColor(named: "yellow")!
		}

    segmentedControl.backgroundColor = Constants.AppColors.mainGreenColor
		segmentedControl.indicatorViewBackgroundColor = Constants.AppColors.mainGreenColor
  }
  
  func getSegmentedControl() -> BetterSegmentedControl {
    return segmentedControl
  }
  
  func getTableView() -> UITableView {
    return tableView
  }
  
  func getRefreshControl() -> UIRefreshControl {
    return refreshControl
  }
  
  func getMapView() -> GMSMapView {
    return mapView
  }
  
  func getShopInfoView() -> ShopInfoViewXIB {
    return shopInfoView
  }
  
	func moveCamera(to coordinate: CLLocationCoordinate2D, zoom: Float = Constants.Location.defaultZoom, needScrool: Bool = false) {
    mapView.animate(toLocation: coordinate)
    mapView.animate(toZoom: zoom)
  }

  func configureMapView() {
    let frame = mapView.superview?.bounds ?? .zero
    mapView.removeFromSuperview()

		let options = GMSMapViewOptions()
		options.camera = GMSCameraPosition(target: Constants.Location.kievCenter,
																			 zoom: Constants.Location.defaultZoom)
		options.frame = frame
		let newMapView = GMSMapView(options: options)
    newMapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    addSubview(newMapView)
    newMapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    newMapView.mapStyle = try? GMSMapStyle(jsonString: Constants.Map.mapStyle)
    newMapView.isHidden = true
    mapView = newMapView
		mapView.settings.consumesGesturesInView = false
    configureShopInfoView()
		mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func showMap() {
    segmentedControl.setIndex(1)
    tableView.isHidden = true
    mapView.isHidden = false
  }
  
  func showList() {
    segmentedControl.setIndex(0)
    tableView.isHidden = false
    mapView.isHidden = true
  }
  
  func createSelectedCityCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.selectedCityCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { () -> UIView in
			let view = SelectionView(style: .selectedCity)
      view.setFont(UIConstants.TableView.cityFont)
      view.setTextColor(UIConstants.TableView.cityTextColor)
      return view
    }
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.TableView.backgroundColor
    return cell
  }
  
  func createShopCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.shopCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { () -> UIView in
			let view = ShopInfoViewXIB.initFromNib() as! ShopInfoViewXIB
			view.delegate = self.shopCellDelegate
			return view
    }
    cell.setupUI(insets: UIEdgeInsets(top: 0,
                                      left: UIConstants.TableView.leftSpacing,
                                      bottom: 0,
                                      right: UIConstants.TableView.leftSpacing),
                 height: nil)
    cell.selectionStyle = .none
		cell.backgroundColor = indexPath.row == 0 ? UIConstants.TableView.backgroundColor : UIConstants.TableView.shadowColor
    return cell
  }
  
  func createAvailabilityCell(tableView: UITableView, indexPath: IndexPath) -> AUIReusableTableViewCell {
    let cell: AUIReusableTableViewCell = tableView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.availabilityCell,
                                                                       for: indexPath)
    cell.setCellCreateViewBlock { ImageLabelView() }
    cell.setupUI(insets: UIConstants.AvailabilityView.insets)
    cell.selectionStyle = .none
    cell.backgroundColor = UIConstants.AvailabilityView.backgroundColor
    return cell
  }
  
  func createHeader(tableView: UITableView) -> AUIContainerTableViewHeaderFooterView? {
    let headerView = AUIGenericContainerTableViewHeaderFooterView<UILabel>(frame: .zero)
    headerView.genericView.backgroundColor = UIConstants.TableView.backgroundColor
    headerView.genericView.textColor = UIConstants.TableView.cityTextColor
    headerView.genericView.font = UIConstants.TableView.cityFont
    headerView.genericView.frame = CGRect(x: UIConstants.TableView.leftSpacing,
                                          y: 0,
                                          width: tableView.bounds.width - 2 * UIConstants.TableView.leftSpacing,
                                          height: UIConstants.TableView.headerHeight)
    return headerView
  }
  
  func showShopInfoView() {
		shopInfoView.isUserInteractionEnabled = true
    UIView.animate(withDuration: 1, animations: {
      self.shopInfoView.snp.updateConstraints { make in
        make.top.equalToSuperview()
      }
			self.shopInfoView.isHidden = false
			self.mapView.padding = UIEdgeInsets(top: 353, left: 0, bottom: 0, right: 0)
      self.layoutIfNeeded()
		}, completion: {_ in 
			self.shopInfoView.snp.updateConstraints { make in
				make.top.equalToSuperview()
			}
			self.shopInfoView.isHidden = false
			self.mapView.padding = UIEdgeInsets(top: 353, left: 0, bottom: 0, right: 0)
		})

  }
  
  func hideShopInfoView() {
    UIView.animate(withDuration: 1, animations: {
      self.shopInfoView.snp.updateConstraints { make in
        make.top.equalToSuperview()
          .offset(-UIConstants.ShopInfoView.bottom)
      }
      self.layoutIfNeeded()
			self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }, completion: { _ in
			self.shopInfoView.snp.updateConstraints { make in
				make.top.equalToSuperview()
					.offset(-UIConstants.ShopInfoView.bottom)
			}
      self.shopInfoView.isHidden = true
			self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    })
  }
}

private enum UIConstants {
  enum SegmentedControl {
		static let textColor = UIColor.white
    static let textFont = UIFont.regularAppFont(of: 16)
    static let selectedTextColor = UIColor(named: "textDarkGreen")!
    
    static let inset: CGFloat = 20
    static let height: CGFloat = 40
  }
  
  enum TableView {
    static let backgroundColor = UIColor.white
		static let shadowColor = UIColor.black.withAlphaComponent(0.13)
    static let bottomInset: CGFloat = 20
    static let leftSpacing: CGFloat = 24
    
    static let cityFont = UIFont.boldAppFont(of: 16)
    static let cityTextColor = UIColor.color(r: 62, g: 76, b: 75)
    static let shopFont = UIFont.regularAppFont(of: 14)
    static let shopTextColor = UIColor.color(r: 62, g: 76, b: 75)
    static let headerHeight: CGFloat = 50
  }
  
  enum AvailabilityView {
    static let backgroundColor = UIColor.clear
    static let insets = UIEdgeInsets(top: 24, left: 24, bottom: 8, right: 24)
  }
  
  enum ReuseIdentifiers {
    static let selectedCityCell = "selectedCityCell"
    static let shopCell = "shopCell"
    static let availabilityCell = "availabilityCell"
  }
  
  enum ShopInfoView {
    static let height: CGFloat = 353
    static let sides: CGFloat = 16
    static let bottom: CGFloat = 573 + Constants.Screen.topSafeAreaInset
  }
}
