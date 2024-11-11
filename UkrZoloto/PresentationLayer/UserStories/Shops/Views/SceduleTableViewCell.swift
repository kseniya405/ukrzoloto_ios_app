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
		weekDayLabel.text = nil
		openHoursLabel.text = nil
		weekDayLabel.textColor = nil
		openHoursLabel.textColor =  nil
		availabilityImageView.image = nil
	}
	
	func configureCell(day: Day, weekDay: WeekDay) {
		weekDayLabel.text = Localizator.standard.localizedString(weekDay.rawValue)
		let isToday = (day.dayOpen ?? false) || (day.closed ?? false)
		
		if day.dayOff ?? false {
			openHoursLabel.text = Localizator.standard.localizedString("Выходной")
			weekDayLabel.textColor = UIConstraint.dayOffColor
			openHoursLabel.textColor = UIConstraint.dayOffColor
			availabilityImageView.image = isToday ? UIConstraint.todayDot?.withTintColor(UIConstraint.dayOffColor) : nil
			return
		}
		
		openHoursLabel.text = day.timeRange ?? ""
		weekDayLabel.textColor = isToday ? UIConstraint.todayTextColor :  UIConstraint.textColor
		openHoursLabel.textColor =  isToday ? UIConstraint.todayTextColor :  UIConstraint.textColor
		availabilityImageView.image = isToday ? UIConstraint.todayDot : nil
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}

private enum UIConstraint {
	static let dayOffColor = UIColor(named: "red")!
	static let todayDot = UIImage(named: "greenDot")
	static let todayTextColor = UIColor(named: "darkGreen")
	static let textColor = UIColor(named: "textDarkGreen")
	
	static let weekDayFont = UIFont.regularAppFont(of: 14)
	static let timeRangeFont = UIFont.boldAppFont(of: 14)
}


/// ТЗ
//График работы
//График работы везде скрыть по умолчанию. При нажатии на области раскрываем график работы При нажатии еще раз на строку “график работы” или в другой области или скрол - закрываем выпадающий список.
//В Графике работы текущий день выделяем
//- если открыт: зеленым цветом и точкой
//closed: false day_off: false open: true time_range: "10:00 - 21:30"
//- если закрыт, выделяем строку красным цветом c красной точкой.
//closed: true day_off: false open: false time_range: "10:00 - 12:30"
//- если выходной - также вся строка красным цветом
//closed: true day_off: true open: false time_range: []
//
//Все остальные дни - черным цветом
