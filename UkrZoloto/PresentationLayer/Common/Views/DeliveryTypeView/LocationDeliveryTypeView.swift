//
//  LocationDeliveryTypeView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class LocationDeliveryTypeView: DeliveryTypeView {

  // MARK: - Private variables
  private let containerView = UIView()
	private let cityView = SelectionView(withoutLeftSpace: true)
	private let officeView = SelectionView(withoutLeftSpace: true)
	private let shopScheduleView = ShopDeliveryScheduleView.initFromNib() as! ShopDeliveryScheduleView

  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Init configure
  private func initConfigure() {
    configureContainerView()
    configureCityView()
    configureOfficeView()
  }
  
  private func configureContainerView() {
    containerView.backgroundColor = UIConstants.containerViewColor
    addBottomView(containerView)
  }
  
  private func configureCityView() {
    cityView.setFont(UIConstants.CityView.font)
    cityView.setNumberOfLines(UIConstants.CityView.numberOfLines)
    containerView.addSubview(cityView)
    cityView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }
  }
  
  private func configureOfficeView() {
    officeView.setFont(UIConstants.OfficeView.font)
    officeView.setNumberOfLines(UIConstants.OfficeView.numberOfLines)
    containerView.addSubview(officeView)
    officeView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.equalTo(cityView.snp.bottom).offset(UIConstants.OfficeView.top)
      make.bottom.equalToSuperview().inset(UIConstants.OfficeView.bottom)
    }
  }
	
	func addScheduleView() {
		containerView.addSubview(shopScheduleView)
		officeView.snp.remakeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.equalTo(cityView.snp.bottom).offset(UIConstants.OfficeView.top)
			make.bottom.equalTo(shopScheduleView.snp.top)
		}
		shopScheduleView.snp.makeConstraints { make in
			make.leading.equalToSuperview()
			make.bottom.equalToSuperview().inset(UIConstants.OfficeView.bottom)
			make.width.equalTo(UIConstants.ShopScheduleView.width)
		}
	}
	
	func removeScheduleView() {
		officeView.snp.remakeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.equalTo(cityView.snp.bottom).offset(UIConstants.OfficeView.top)
			make.bottom.equalToSuperview().inset(UIConstants.OfficeView.bottom)
		}
		shopScheduleView.removeFromSuperview()
	}
	
	func setShopSchedule(shop: NewShopsItem, delegate: ShopDeliveryScheduleViewDelegate?) {
		shopScheduleView.set(shop: shop, delegate: delegate)
	}
	  
  // MARK: - Interface
  func setCityTitle(_ title: String) {
    cityView.setTitle(title)
  }
  
  func setOfficeTitle(_ title: String) {
    officeView.setTitle(title)
  }
  
  func setCityTextColor(_ color: UIColor) {
    cityView.setTextColor(color)
  }
  
  func setOfficeTextColor(_ color: UIColor) {
    officeView.setTextColor(color)
  }
  
  func addCityTarget(_ target: Any, action: Selector) {
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(target, action: action)
    cityView.addGestureRecognizer(gesture)
  }
  
  func addOfficeTarget(_ target: Any, action: Selector) {
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(target, action: action)
    officeView.addGestureRecognizer(gesture)
  }
  
  func removeCityTarget() {
    cityView.gestureRecognizers?.forEach { cityView.removeGestureRecognizer($0) }
  }
  
  func removeOfficeTarget() {
    officeView.gestureRecognizers?.forEach { officeView.removeGestureRecognizer($0) }
  }
}


// MARK: - UIConstants
private enum UIConstants {
  static let containerViewColor = UIColor.clear
  
  enum CityView {
    static let font = UIFont.semiBoldAppFont(of: 16)
    static let numberOfLines = 0
  }
  
  enum OfficeView {
    static let font = UIFont.semiBoldAppFont(of: 16)
    static let numberOfLines = 0
    
    static let top: CGFloat = 10
    static let bottom: CGFloat = 8
  }
	
	enum ShopScheduleView {
		static let width: CGFloat = 185
	}
}
