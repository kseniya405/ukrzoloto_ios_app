//
//  SceduleTableViewCell.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 21.06.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import UIKit

enum WeekDay: String {
	case monday = "Пн"
	case tuesday = "Вт"
	case wednesday = "Ср"
	case thursday = "Чт"
	case friday = "Пт"
	case saturday = "Сб"
	case sunday = "Вс"
}

class SceduleTableViewCell: UITableViewCell {
	
	@IBOutlet weak var weekDayLabel: UILabel!
	@IBOutlet weak var openHoursLabel: UILabel!
	@IBOutlet weak var availabilityView: UIView!
	@IBOutlet weak var availabilityImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		weekDayLabel.font = UIConstraint.weekDayFont
		openHoursLabel.font = UIConstraint.timeRangeFont
	}
	
	override func prepareForReuse() {
    super.prepareForReuse()
		weekDayLabel.text = nil
		openHoursLabel.text = nil
		weekDayLabel.textColor = nil
		openHoursLabel.textColor = nil
		availabilityImageView.image = nil
	}
	
	func configureCell(day: Day, weekDay: WeekDay) {
		weekDayLabel.text = Localizator.standard.localizedString(weekDay.rawValue)
		let isToday = (day.dayOpen ?? false) || (day.closed ?? false)
		
		if day.dayOff ?? false {
			openHoursLabel.text = Localizator.standard.localizedString("Выходной")
			weekDayLabel.textColor = UIConstraint.dayOffColor
			openHoursLabel.textColor = UIConstraint.dayOffColor
      availabilityImageView.image = isToday ? UIConstraint.todayDot.withTintColor(UIConstraint.dayOffColor) : nil
			return
		}
		
		openHoursLabel.text = day.timeRange ?? ""
		weekDayLabel.textColor = isToday ? UIConstraint.todayTextColor : UIConstraint.textColor
		openHoursLabel.textColor = isToday ? UIConstraint.todayTextColor : UIConstraint.textColor
		availabilityImageView.image = isToday ? UIConstraint.todayDot : nil
	}
}

private enum UIConstraint {
  static let dayOffColor = UIColor(named: "red") ?? .red
	static let todayDot = #imageLiteral(resourceName: "greenDot")
	static let todayTextColor = UIColor(named: "darkGreen")
	static let textColor = UIColor(named: "textDarkGreen")
	
	static let weekDayFont = UIFont.regularAppFont(of: 14)
	static let timeRangeFont = UIFont.boldAppFont(of: 14)
}
