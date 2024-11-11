//
//  ShopInfoViewXIB.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 22.06.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import UIKit

protocol ShopInfoViewXIBDelegate: AnyObject {
	func needUIUpdates()
}

class ShopInfoViewXIB: UIView {
	
	weak var delegate: ShopInfoViewXIBDelegate?
	
	var popupMode = true {
		didSet {
			closeButton.isHidden = !popupMode
			if popupMode {
				shadowView.isHidden = true
				shadowView.backgroundColor = .clear
				self.backgroundColor = .clear
			} else {
				shadowView.isHidden = false
				shadowView.backgroundColor = UIConstants.SelfView.shadowColor
			}
		}
	}
	
	var isShortView = false

	@IBOutlet private weak var mainBackgroundView: UIView! {
		didSet {
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOutsideScheduleDetailsTapGesture))
			tapGestureRecognizer.delegate = self
			mainBackgroundView.addGestureRecognizer(tapGestureRecognizer)
			mainBackgroundView.backgroundColor = .clear
		}
	}
	@IBOutlet private weak var shopDetailsBacgroundView: UIView! {
		didSet {
			shopDetailsBacgroundView.layer.cornerRadius = UIConstants.SelfView.cornerRadius
			shopDetailsBacgroundView.clipsToBounds = true
		}
	}
	@IBOutlet private weak var shadowView: UIView! {
		didSet {
			shadowView.backgroundColor = popupMode ? .clear : UIConstants.SelfView.shadowColor
		}
	}
	@IBOutlet private weak var shopImageView: UIImageView!
	@IBOutlet private weak var closeButton: UIButton!
	@IBOutlet private weak var jewellerIndicatorContainer: UIView!
	@IBOutlet private weak var jewellerImageView: UIImageView!
	@IBOutlet private weak var jewellerLabel: UILabel!
	@IBOutlet private weak var shopAdressLabel: UILabel!
	@IBOutlet private weak var shopStateContainerView: UIView!
	@IBOutlet private weak var shopStateLabel: UILabel!
	@IBOutlet private weak var shopStateDetailLabel: UILabel!
	@IBOutlet private weak var scheduleContainerView: UIStackView! {
		didSet {
			scheduleContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scheduleDetailsTapGesture)))
		}
	}
	@IBOutlet private weak var scheduleHeaderContainer: UIView!
	@IBOutlet private weak var scheduleClockImageView: UIImageView!
	@IBOutlet private weak var scheduleLabel: UILabel!
	@IBOutlet private weak var scheduleArrowImageView: UIImageView!
	@IBOutlet private weak var scheduleDetailsTableView: UITableView! {
		didSet {
			scheduleDetailsTableView.delegate = self
			scheduleDetailsTableView.dataSource = self
			scheduleDetailsTableView.register(UINib(nibName: "SceduleTableViewCell", bundle: nil), forCellReuseIdentifier: UIConstants.ReuseIdentifiers.scheduleDetailsCell)
		}
	}	
	@IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
	private var status: ShopStatus = .isOpened
	private var weekDays = [String]()
	private var shop: NewShopsItem?
	private var isFirstLayoutSubviews = true
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if isFirstLayoutSubviews {
			mainBackgroundView.addShadow(shadowColor: UIConstants.SelfView.shadowColor, offSet: CGSize(width: 0, height: 1), opacity: 1, shadowRadius: 1, cornerRadius: 16, corners: .allCorners, width: UIScreen.main.bounds.width)
			isFirstLayoutSubviews = false
		}
		
	}
	
	private func jewellerConfigure(_ shop: NewShopsItem) {
		jewellerIndicatorContainer.backgroundColor = UIConstants.JewelerTitle.backgroundColor
		jewellerIndicatorContainer.roundCorners(radius: UIConstants.JewelerTitle.cornerRadius)
		jewellerLabel.text = Localizator.standard.localizedString("Есть ювелир")
		jewellerIndicatorContainer.isHidden = !(shop.jeweler ?? false)
	}
		
	private func shopImageViewConfigure(_ shop: NewShopsItem) {
		if isShortView {
			imageViewHeightConstraint.constant = 0
		}
		shopImageView.contentMode = .scaleAspectFill
		let imageViewModel = ImageViewModel.url(URL(string: shop.image ?? ""), placeholder: #imageLiteral(resourceName: "shopPlaceholder"))
		shopImageView.setImage(from: imageViewModel)
		shopImageView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
	}
	
	private func scheduleConfigure(_ shop: NewShopsItem) {
		shopStateDetailLabel.text = StringComposer.shared.getScheduleString(shop: shop, status: status)
		switch status {
		case .isOpened:
			shopStateLabel.text = Localizator.standard.localizedString("Открыто")
			shopStateContainerView.backgroundColor = UIConstants.AvailabilityLabel.availableBackgroundColor
		case .isPickupPoint:
			shopStateLabel.text = Localizator.standard.localizedString("Закрыто")
			shopStateContainerView.backgroundColor = UIConstants.AvailabilityLabel.unavailableBackgroundColor
		case .isTemporarilyСlosed:
			shopStateLabel.text = Localizator.standard.localizedString("Временно закрыт")
			shopStateContainerView.backgroundColor = UIConstants.AvailabilityLabel.unavailableBackgroundColor
		}
		scheduleContainerView.isHidden = status == .isTemporarilyСlosed
		scheduleDetailsTableView.reloadData()
	}
	
	private func shopUIConfigure() {
		shopStateLabel.font = UIConstants.AvailabilityLabel.font
		shopStateLabel.textColor = UIConstants.AvailabilityLabel.textColor
		
		shopStateDetailLabel.font = UIConstants.Text.font
		shopStateDetailLabel.textColor = UIConstants.Text.color
		
		scheduleClockImageView.image = #imageLiteral(resourceName: "icon_clock")
		scheduleLabel.text = Localizator.standard.localizedString("График работы")
		scheduleLabel.font = UIFont.regularAppFont(of: 14)
		
		closeButton.layer.cornerRadius = closeButton.frame.height / 2
		closeButton.setImage(#imageLiteral(resourceName: "controlsCloseBlack"), for: .normal)
		
		shopStateContainerView.roundCorners(radius: UIConstants.AvailabilityLabel.cornerRadius)
		shopStateContainerView.backgroundColor = status == .isOpened ? UIConstants.AvailabilityLabel.availableBackgroundColor : UIConstants.AvailabilityLabel.unavailableBackgroundColor
		
		scheduleContainerView.backgroundColor = UIConstants.JewelerTitle.backgroundColor
		scheduleContainerView.roundCorners(radius: UIConstants.ScheduleStackView.cornerRadius, borderWidth: UIConstants.ScheduleStackView.borderWidth, borderColor: UIConstants.ScheduleStackView.borderColor)
	}
	
	private func shopAddressLabelConfigure(_ shop: NewShopsItem) {
		shopAdressLabel.text = shop.title
		shopAdressLabel.font = UIConstants.Text.font
	}
	
	func configureOutlets(shop: NewShopsItem) {
		
		shopImageViewConfigure(shop)
		jewellerConfigure(shop)
		shopAddressLabelConfigure(shop)
		shopUIConfigure()
		scheduleConfigure(shop)
	}

	func setData(shop: NewShopsItem, isShortView: Bool = false) {
		scheduleDetailsTableView.isHidden = true
		self.shop = shop
		self.isShortView = isShortView
		shopAdressLabel.text = shop.title ?? ""
		setShopStatus(shop)
		configureOutlets(shop: shop)
	}
  
  func getCloseButton() -> UIButton {
    return closeButton
  }
	
	@objc func scheduleDetailsTapGesture() {
		scheduleDetailsTableView.isHidden.toggle()
		scheduleArrowImageView.image = scheduleDetailsTableView.isHidden ? UIConstants.ScheduleStackView.showList : UIConstants.ScheduleStackView.hiddenList
		delegate?.needUIUpdates()
	}
	
	@objc func tapOutsideScheduleDetailsTapGesture() {
		guard scheduleDetailsTableView.isHidden == false else {
			return
		}
		scheduleDetailsTableView.isHidden = true
		scheduleArrowImageView.image = UIConstants.ScheduleStackView.showList
		delegate?.needUIUpdates()
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
}

extension ShopInfoViewXIB: UITableViewDelegate, UITableViewDataSource {
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

extension ShopInfoViewXIB: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
			!scheduleDetailsTableView.isHidden
	}
}

private enum UIConstants {
	enum ReuseIdentifiers {
		static let scheduleDetailsCell = "ScheduleTableViewCell"
	}
	enum ShopInfoView {
		static let height: CGFloat = 373
		static let expandedHeight: CGFloat = 373 + UIConstants.ShopInfoView.scheduleDetailsHeight
		static let scheduleDetailsHeight: CGFloat = 220
		static let bottom: CGFloat = 373 + Constants.Screen.topSafeAreaInset
	}
	enum SelfView {
		static let cornerRadius: CGFloat = 16
		static let backgroundColor = UIColor.white
		static let shadowRadius: CGFloat = 8
		static let shadowOffset = CGSize(width: 0, height: 4)
		static let shadowColor = UIColor.black.withAlphaComponent(0.13)
	}
	enum ShopPhoto {
		static let height: CGFloat = 172
	}
	enum JewelerTitle {
		static let backgroundColor: UIColor = .white.withAlphaComponent(0.8)
		static let cornerRadius: CGFloat = 20
		static let trailing: CGFloat = -24
		static let bottom: CGFloat = -16
		static let height: CGFloat = 34
	}
	enum Title {
		static let height: CGFloat = 18
		static let font = UIFont.regularAppFont(of: 12)
		static let color = UIColor.color(r: 62, g: 76, b: 75, a: 0.6)
	}
	enum Text {
		static let height: CGFloat = 20
		static let font = UIFont.boldAppFont(of: 14)
		static let color = UIColor(named: "textDarkGreen") ?? .systemGreen
	}
	enum AddressTitle {
		static let top: CGFloat = 20
		static let leading: CGFloat = 16
	}
	enum Address {
		static let top: CGFloat = 20
		static let leading: CGFloat = 16
		static let numbersOfLines: Int = 0
		static let font: UIFont = UIFont.boldAppFont(of: 18)
		static let color: UIColor = UIColor.color(r: 62, g: 76, b: 75)
		static let height: CGFloat = 20
	}
	enum AvailabilityLabel {
		static let top: CGFloat = 15
		static let height: CGFloat = 24
		static let cornerRadius: CGFloat = 8
		static let availableBackgroundColor = UIColor.color(r: 13, g: 104, b: 67)
		static let textColor = UIColor.white
		static let unavailableBackgroundColor = UIColor.color(r: 255, g: 95, b: 95)
		static let font = UIFont.boldAppFont(of: 14)
		static let lineHeight: CGFloat = 8
		static let numberOfLines = 0
	}
	enum ScheduleTitle {
		static let top: CGFloat = 10
	}
	enum ScheduleStackView {
		static let space: CGFloat = 10
		static let top: CGFloat = 15
		static let bottom: CGFloat = -25
		static let leading: CGFloat = 16
		static let width: CGFloat = 185
		static let cornerRadius: CGFloat = 17
		static let borderWidth: CGFloat = 1
		static let borderColor: CGColor = CGColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
		static let backgroundColor: UIColor = .white
		static let showList: UIImage? = #imageLiteral(resourceName: "arrow_down")
		static let hiddenList: UIImage? = #imageLiteral(resourceName: "arrow_up")
	}
	enum ScheduleDescription {
		static let trailing: CGFloat = 5
		static let height: CGFloat = 20
	}
	enum NoWeekend {
		static let bottom: CGFloat = 22
		static let height: CGFloat = 14
	}
}
