//
//  ShopsDeliveryView.swift
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
import SnapKit

class ShopsDeliveryView: RoundedContainerView {
	
	weak var shopCellDelegate: ShopInfoViewXIBDelegate?

  // MARK: - Private variables
  private let segmentedControl = BetterSegmentedControl()
  private let indicatorLineView = UIView()
  
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let refreshControl = UIRefreshControl()
  
  private var mapView = GMSMapView(frame: .zero,
                                   camera: GMSCameraPosition(target: Constants.Location.kievCenter,
                                                             zoom: Constants.Location.defaultZoom))
  
  private let shopInfoView = ShopInfoViewXIB.initFromNib() as! ShopInfoViewXIB
  private let saveButton = MainButton()
  
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
    configureSaveButton()
    configureTableView()
    configureRefreshControl()
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
    tableView.estimatedRowHeight = 44
    registerCells()
  }
  
  private func configureRefreshControl() {
    tableView.addSubview(refreshControl)
  }
  
  private func registerCells() {
		tableView.register(AUIReusableTableViewCell.self, forCellReuseIdentifier: UIConstants.ReuseIdentifiers.shopCell)
  }
  
	private func configureShopInfoView() {
		mapView.addSubview(shopInfoView)
		shopInfoView.snp.remakeConstraints { make in
			make.top.equalTo(mapView.snp.top)
			make.leading.trailing.equalToSuperview()
			make.height.greaterThanOrEqualTo(UIConstants.ShopInfoView.height)
		}
	}
  
  private func configureSaveButton() {
    reConfigureSaveButton()
    saveButton.isHidden = true
  }
  
  private func reConfigureShopInfoView() {
    mapView.addSubview(shopInfoView)
    shopInfoView.snp.remakeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
      make.height.greaterThanOrEqualTo(UIConstants.ShopInfoView.height)
				.priority(.medium)
    }
  }
  
  private func reConfigureSaveButton() {
    mapView.addSubview(saveButton)
    saveButton.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.SaveButton.sides)
      make.height.equalTo(UIConstants.SaveButton.height)
      make.bottom.equalToSuperview()
        .offset(Constants.Screen.screenHeight)
    }
    saveButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
    saveButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    saveButton.layer.shadowRadius = 8
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
																								 normalBorderColor: #colorLiteral(red: 0.051, green: 0.408, blue: 0.263, alpha: 1),
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
  
  func getSaveButton() -> UIButton {
    return saveButton
  }
  
  func moveCamera(to coordinate: CLLocationCoordinate2D, zoom: Float = Constants.Location.defaultZoom) {
    mapView.animate(toLocation: coordinate)
    mapView.animate(toZoom: zoom)
  }
	
  func configureMapView(centerTarget: CLLocationCoordinate2D = Constants.Location.kievCenter) {
    let frame = mapView.superview?.bounds ?? .zero
    mapView.removeFromSuperview()
    let newMapView = GMSMapView(frame: frame,
                                camera: GMSCameraPosition(target: centerTarget,
                                                          zoom: Constants.Location.defaultZoom))
    newMapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    addSubview(newMapView)
    newMapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    newMapView.mapStyle = try? GMSMapStyle(jsonString: Constants.Map.mapStyle)
    newMapView.isHidden = true
    mapView = newMapView
		mapView.settings.consumesGesturesInView = false
    reConfigureShopInfoView()
    reConfigureSaveButton()
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
  
  func configureSelectedShopInfoView(shop: NewShopsItem) {
    shopInfoView.setData(shop: shop)
  }
  
  func showShopInfoView() {
    shopInfoView.isHidden = false
    saveButton.isHidden = false
    bringSubviewToFront(shopInfoView)
    bringSubviewToFront(saveButton)
    UIView.animate(withDuration: 1, animations: {
			self.shopInfoView.snp.updateConstraints { make in
				make.top.equalToSuperview()
			}
      self.saveButton.snp.updateConstraints { make in
        make.bottom.equalToSuperview()
          .inset(UIConstants.SaveButton.bottom)
      }
			self.mapView.padding = UIEdgeInsets(top: 353, left: 0, bottom: 0, right: 0)
      self.layoutIfNeeded()
		}, completion: { _ in
			self.shopInfoView.snp.updateConstraints { make in
				make.top.equalToSuperview()
			}
			self.saveButton.snp.updateConstraints { make in
				make.bottom.equalToSuperview()
					.inset(UIConstants.SaveButton.bottom)
			}
			self.mapView.padding = UIEdgeInsets(top: 353, left: 0, bottom: 0, right: 0)
			self.layoutIfNeeded()
		}
		)
  }
  
  func hideShopInfoView() {
    guard !shopInfoView.isHidden else { return }
    UIView.animate(withDuration: 1, animations: {
			self.shopInfoView.snp.updateConstraints { make in
				make.top.equalToSuperview().offset(-UIConstants.ShopInfoView.bottom)
			}
      self.saveButton.snp.updateConstraints { make in
        make.bottom.equalToSuperview()
          .offset(Constants.Screen.screenHeight)
      }
      self.layoutIfNeeded()
			self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }, completion: { _ in
      self.shopInfoView.isHidden = true
      self.saveButton.isHidden = true
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
    static let backgroundColor = UIColor.clear
		static let shadowColor = UIColor.black.withAlphaComponent(0.13)
    static let bottomInset: CGFloat = 20
    static let leftSpacing: CGFloat = 24
    
    static let cityFont = UIFont.boldAppFont(of: 16)
    static let cityTextColor = UIColor.color(r: 62, g: 76, b: 75)
    static let shopFont = UIFont.regularAppFont(of: 14)
    static let shopTextColor = UIColor.color(r: 62, g: 76, b: 75)
    static let headerHeight: CGFloat = 63
  }
  
  enum ReuseIdentifiers {
    static let shopCell = "shopCell"
  }
  
  enum ShopInfoView {
    static let height: CGFloat = 373
    static let sides: CGFloat = 16
		static let bottom: CGFloat = 573 + Constants.Screen.topSafeAreaInset
  }
  
  enum SaveButton {
    static let top: CGFloat = 4
    static let height: CGFloat = 52
    static let sides: CGFloat = 16
    static let bottom: CGFloat = 8 + Constants.Screen.bottomSafeAreaInset
  }
}
