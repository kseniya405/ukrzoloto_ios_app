//
//  ShopInfoView.swift
//  UkrZoloto
//
//  Created by user on 25.08.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import SnapKit

class ShopInfoView: InitView {
  // MARK: - Private variables
	
	private let shopPhotoImageView =
	UIImageView()
	
	private var jewelerLabel = SelectionView(style: .small)
  
  private let addressLabel =
    LabelFactory.shared.createLabel(
      color: UIConstants.Address.color,
      font: UIConstants.Address.font,
      height: UIConstants.Text.height,
      numbersOfLines: UIConstants.Address.numbersOfLines)
	
  private let availabilityLabel = UILabel()
	private let availabilityLabelContainer = UIView()
  private let availabilityDetailsLabel = UILabel()
	
	private let scheduleStackView: UIStackView = {
		let stackView = UIStackView()
		
		stackView.axis = .vertical
		stackView.spacing = UIConstants.ScheduleStackView.space
		stackView.backgroundColor = .clear
		stackView.isUserInteractionEnabled = true
		return stackView
	}()
	private let scheduleTitleButton = UIButton()
	private let scheduleTitle = SelectionView(style: .small)
	private let scheduleListStackView: UIStackView = {
		let stackView = UIStackView()
		
		stackView.axis = .vertical
		stackView.spacing = UIConstants.ScheduleStackView.space
		stackView.backgroundColor = .clear
		
		return stackView
	}()
	
	private let scheduleListTableView = UITableView()
	
	var shopList: [NewShopsItem] = []
	
	private var scheduleListIsHidden = true
	
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
		configureShopPhoto()
		configureJewelerLabel()
    configureAddress()
		configureAvailabilityLabelContainer()
		configureAvailabilityLabel()
		configureAvailabilityDetailLabel()
		configureScheduleStackView()
		scheduleListTableView.delegate = self
		scheduleListTableView.dataSource = self
		scheduleListTableView.register(UINib(nibName: "SceduleTableViewCell", bundle: nil), forCellReuseIdentifier: "SceduleTableViewCell")
		setSheduleTapRecognize()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    layer.cornerRadius = UIConstants.SelfView.cornerRadius
    layer.shadowColor = UIConstants.SelfView.shadowColor.cgColor
    layer.shadowOffset = UIConstants.SelfView.shadowOffset
    layer.shadowRadius = UIConstants.SelfView.shadowRadius
  }
  
	private func configureShopPhoto() {
		addSubview(shopPhotoImageView)
		shopPhotoImageView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(UIConstants.ShopPhoto.height)
		}
	}
	
	private func configureJewelerLabel() {
		addSubview(jewelerLabel)
		jewelerLabel.snp.makeConstraints { make in
			make.trailing.equalTo(shopPhotoImageView.snp.trailing)
				.offset(UIConstants.JewelerTitle.trailing)
			make.bottom.equalTo(shopPhotoImageView.snp.bottom)
				.offset(UIConstants.JewelerTitle.bottom)
			make.height.equalTo(UIConstants.JewelerTitle.height)
		}
		jewelerLabel.setLeftImage(ImageViewModel.image(#imageLiteral(resourceName: "jeweler")))
		jewelerLabel.setRightImage(nil)
		jewelerLabel.setSeparatorPosition()
		jewelerLabel.setTitle(Localizator.standard.localizedString("Есть ювелир"))
		jewelerLabel.setSeparatorPosition(nil)
		jewelerLabel.backgroundColor = UIConstants.JewelerTitle.backgroundColor
		jewelerLabel.roundCorners(radius: UIConstants.JewelerTitle.cornerRadius)
	}
  
  private func configureAddress() {
    addSubview(addressLabel)
    addressLabel.snp.makeConstraints { make in
			make.top.equalTo(shopPhotoImageView.snp.bottom)
				.offset(UIConstants.AddressTitle.top)
			make.leading.equalToSuperview()
				.offset(UIConstants.AddressTitle.leading)
			make.trailing.equalToSuperview()
				.offset(-UIConstants.AddressTitle.leading)
    }
		addressLabel.contentMode = .scaleToFill
  }
	
	private func configureAvailabilityLabelContainer() {
		addSubview(availabilityLabelContainer)
		availabilityLabelContainer.snp.makeConstraints { make in
			make.top.equalTo(addressLabel.snp.bottom)
				.offset(UIConstants.AvailabilityLabel.top)
			make.leading.equalToSuperview()
				.offset(UIConstants.AddressTitle.leading)
			make.height.equalTo(UIConstants.AvailabilityLabel.height)
		}
		availabilityLabelContainer.roundCorners(radius: UIConstants.AvailabilityLabel.cornerRadius)
		availabilityLabelContainer.backgroundColor = UIConstants.AvailabilityLabel.availableBackgroundColor
	}
  
  private func configureAvailabilityLabel() {
		availabilityLabelContainer.addSubview(availabilityLabel)
		availabilityLabel.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.leading.equalToSuperview()
				.offset(8)
			make.height.equalToSuperview()
			make.trailing.equalToSuperview()
				.offset(-8)
		}
		availabilityLabel.font = UIConstants.AvailabilityLabel.font
		availabilityLabel.textColor = UIConstants.AvailabilityLabel.textColor
  }
	
	private func configureAvailabilityDetailLabel() {
		addSubview(availabilityDetailsLabel)
		availabilityDetailsLabel.snp.makeConstraints { make in
			make.top.equalTo(availabilityLabel.snp.top)
			make.leading.equalTo(availabilityLabelContainer.snp.trailing)
				.offset(UIConstants.ScheduleDescription.trailing)
			make.height.equalTo(UIConstants.AvailabilityLabel.height)
		}
		availabilityDetailsLabel.font = UIConstants.Text.font
		availabilityDetailsLabel.textColor = UIConstants.Text.color
	}
	
	private func configureScheduleStackView() {
		addSubview(scheduleStackView)
		scheduleStackView.snp.makeConstraints { make in
			make.top.equalTo(availabilityLabel.snp.bottom)
				.offset(UIConstants.ScheduleStackView.top)
			make.leading.equalToSuperview()
				.offset(UIConstants.ScheduleStackView.leading)
			make.width.equalTo(UIConstants.ScheduleStackView.width).priority(.medium)
			make.bottom.equalToSuperview()
				.offset(UIConstants.ScheduleStackView.bottom)
				.priority(.high)
		}
		scheduleStackView.addArrangedSubview(scheduleTitle)
		configureScheduleTitle()
		setSheduleTapRecognize()
	}
	
	private func configureScheduleListStackView() {
		addSubview(scheduleListStackView)
		scheduleStackView.addArrangedSubview(scheduleListStackView)
		scheduleStackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
				.offset(UIConstants.ScheduleStackView.bottom)
		}
	}
	
	private func setSheduleTapRecognize() {
		self.isUserInteractionEnabled = true
		let gesture = UITapGestureRecognizer(target: self,
																				 action: #selector(scheduleTitleDidTap))
		self.addGestureRecognizer(gesture)
	}
	
	@objc func scheduleTitleDidTap() {
		scheduleListIsHidden.toggle()
		scheduleListStackView.isHidden = scheduleListIsHidden
		scheduleTitle.setRightImage(ImageViewModel.image(
			scheduleListIsHidden ? UIConstants.ScheduleStackView.showList : UIConstants.ScheduleStackView.showList
		))
		scheduleStackView.updateConstraintsIfNeeded()
	}
	
	private func configureScheduleTitle() {
		scheduleTitle.snp.makeConstraints { make in
			make.leading.equalToSuperview()
			make.height.equalTo(UIConstants.JewelerTitle.height)
		}
		scheduleTitle.setLeftImage(ImageViewModel.image(#imageLiteral(resourceName: "icon_clock")))
		scheduleTitle.setRightImage(ImageViewModel.image(UIConstants.ScheduleStackView.showList))
		scheduleTitle.setSeparatorPosition()
		scheduleTitle.setTitle(Localizator.standard.localizedString("График работы"))
		scheduleTitle.setSeparatorPosition(nil)
		scheduleTitle.backgroundColor = UIConstants.JewelerTitle.backgroundColor
		scheduleTitle.roundCorners(radius: UIConstants.ScheduleStackView.cornerRadius, borderWidth: UIConstants.ScheduleStackView.borderWidth, borderColor: UIConstants.ScheduleStackView.borderColor)
	}
	
  // MARK: - Interface
  func localize() {
//    scheduleTitleLabel.text = "График работы".localized()
  }
  
	func configureSelectedShopInfoView(shop: Shop, imageViewModel: ImageViewModel) {
		shopPhotoImageView.setImage(from: imageViewModel)
    addressLabel.text = shop.address
//		availabilityDetailsLabel.text = StringComposer.shared.getScheduleString(schedule: shop.schedule)
    switch shop.status {
    case .isOpened:
      availabilityLabel.text = Localizator.standard.localizedString("Открыто")
			availabilityLabel.backgroundColor = UIConstants.AvailabilityLabel.availableBackgroundColor
    case .isPickupPoint:
      availabilityLabel.text = Localizator.standard.localizedString("Закрыто")
      availabilityLabel.backgroundColor = UIConstants.AvailabilityLabel.unavailableBackgroundColor
    case .isTemporarilyСlosed:
      availabilityLabel.text = Localizator.standard.localizedString("Временно закрыт")
      availabilityLabel.backgroundColor = UIConstants.AvailabilityLabel.unavailableBackgroundColor
    }
  }
}

extension ShopInfoView: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 7
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SceduleTableViewCell", for: indexPath) as! SceduleTableViewCell
		return cell
	}
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let cornerRadius: CGFloat = 22
    static let backgroundColor = UIColor.white
    static let shadowRadius: CGFloat = 8
    static let shadowOffset = CGSize(width: 0, height: 4)
    static let shadowColor = UIColor.black.withAlphaComponent(0.1)
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
    static let color = UIColor.color(r: 62, g: 76, b: 75)
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
