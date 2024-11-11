//
//  ShopDeliveryScheduleView.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 27.06.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import UIKit

protocol ShopDeliveryScheduleViewDelegate: AnyObject {
	func needUIUpdate()
}

class ShopDeliveryScheduleView: UIView {

	@IBOutlet weak var shopStateIndicatorLabel: UILabel!
	@IBOutlet weak var shopStateDetailsLabel: UILabel!
	@IBOutlet weak var openScheduleTitleLabel: UILabel!
	@IBOutlet weak var scheduleContainerView: UIStackView!
	@IBOutlet weak var scheduleHeaderContainer: UIView!
	@IBOutlet weak var scheduleClockImageView: UIImageView!
	@IBOutlet weak var scheduleLabel: UILabel!
	@IBOutlet weak var scheduleArrowImageView: UIImageView!
	@IBOutlet weak var scheduleTableView: UITableView! {
		didSet {
			scheduleTableView.delegate = self
			scheduleTableView.dataSource = self
			scheduleTableView.register(UINib(nibName: "SceduleTableViewCell", bundle: nil), forCellReuseIdentifier: UIConstants.ReuseIdentifiers.scheduleDetailsCell)
		}
	}
	
	weak var delegate: ShopDeliveryScheduleViewDelegate?
	var scheduleDetailIsOpen: Bool = false
	
	private var shop: NewShopsItem?
	private var status: ShopStatus = .isOpened
	private var weekDays = [String]()
	
		
	func set(shop: NewShopsItem, delegate: ShopDeliveryScheduleViewDelegate?) {
		self.shop = shop
		self.delegate = delegate
		setShopStatus(shop)
		scheduleConfigure(shop)
		self.isUserInteractionEnabled = true
		self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scheduleDetailsTapGesture)))
	}
	
	func hideSchedule() {
		tapOutsideScheduleDetailsTapGesture()
	}
	
	private func setShopStatus(_ shop: NewShopsItem) {
		if shop.temporaryClose ?? false {
			status = .isTemporarilyСlosed
		} else if shop.closedAt.isNilOrEmpty {
			status = .isPickupPoint
		} else {
			status = .isOpened
		}
	}
	
	private func scheduleConfigure(_ shop: NewShopsItem) {
		
		shopUIConfigure()
		scheduleContainerView.backgroundColor = UIConstants.ScheduleStackView.backgroundColor
		scheduleContainerView.roundCorners(radius: UIConstants.ScheduleStackView.cornerRadius, borderWidth: UIConstants.ScheduleStackView.borderWidth, borderColor: UIConstants.ScheduleStackView.borderColor)
		scheduleTableView.reloadData()
	}
	
	fileprivate func shopUIConfigure() {
		scheduleClockImageView.image = UIImage(named: "icon_clock")
		scheduleLabel.text = Localizator.standard.localizedString("График работы")
		scheduleLabel.font = UIFont.regularAppFont(of: 14)
		
		scheduleContainerView.backgroundColor = UIConstants.ScheduleStackView.backgroundColor
		scheduleContainerView.roundCorners(radius: UIConstants.ScheduleStackView.cornerRadius, borderWidth: UIConstants.ScheduleStackView.borderWidth, borderColor: UIConstants.ScheduleStackView.borderColor)
	}
	
	@objc
	private func didTap() {
		scheduleTableView.isHidden.toggle()
		delegate?.needUIUpdate()
	}
	
	@objc func scheduleDetailsTapGesture() {
		scheduleTableView.isHidden.toggle()
		scheduleArrowImageView.image = scheduleTableView.isHidden ? UIConstants.ScheduleStackView.showList : UIConstants.ScheduleStackView.hiddenList
		delegate?.needUIUpdate()
	}
	
	func tapOutsideScheduleDetailsTapGesture() {
		guard scheduleTableView.isHidden == false else {
			return
		}
		scheduleTableView.isHidden = true
		scheduleArrowImageView.image = UIConstants.ScheduleStackView.showList
		delegate?.needUIUpdate()
	}
}

extension ShopDeliveryScheduleView: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 7
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.ReuseIdentifiers.scheduleDetailsCell, for: indexPath) as! SceduleTableViewCell
		if let shop = shop {
			var day: Day?
			var weekDay: WeekDay = .monday
			switch indexPath.row {
			case 0:
				day = shop.schedule?.monday
				weekDay = .monday
			case 1:
				day = shop.schedule?.tuesday
				weekDay = .tuesday
			case 2:
				day = shop.schedule?.wednesday
				weekDay = .wednesday
			case 3:
				day = shop.schedule?.thursday
				weekDay = .thursday
			case 4:
				day = shop.schedule?.friday
				weekDay = .friday
			case 5:
				day = shop.schedule?.saturday
				weekDay = .saturday
			case 6:
				day = shop.schedule?.sunday
				weekDay = .sunday
			default:
				break
			}
			if let day = day {
				cell.configureCell(day: day, weekDay: weekDay)
			}
		}
		return cell
	}
}

private enum UIConstants {
	enum ReuseIdentifiers {
		static let scheduleDetailsCell = "ScheduleTableViewCell"
	}
	
	enum AvailabilityLabel {
		static let top: CGFloat = 15
		static let height: CGFloat = 24
		static let cornerRadius: CGFloat = 8
		static let availableBackgroundColor = UIColor.color(r: 13, g: 104, b: 67)
		static let textColor = UIColor.white
		static let mainTextColor = UIColor(named: "textDarkGreen")
		static let unavailableBackgroundColor = UIColor.color(r: 255, g: 95, b: 95)
		static let font = UIFont.semiBoldAppFont(of: 14)
		static let lineHeight: CGFloat = 8
		static let numberOfLines = 0
	}
	
	enum ScheduleStackView{
		static let space: CGFloat = 10
		static let top: CGFloat = 15
		static let bottom: CGFloat = -25
		static let leading: CGFloat = 16
		static let width: CGFloat = 185
		static let cornerRadius: CGFloat = 17
		static let borderWidth: CGFloat = 1
		static let borderColor: CGColor = CGColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
		static let backgroundColor: UIColor = .white.withAlphaComponent(0.8)
		static let showList: UIImage? = UIImage(named: "arrow_down")
		static let hiddenList: UIImage? = UIImage(named: "arrow_up")
	}
}
