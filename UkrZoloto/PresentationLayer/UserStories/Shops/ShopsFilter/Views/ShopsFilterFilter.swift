//
//  ShopsFilterFilter.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 23.06.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import UIKit

class ShopsFilterFilter: UIView {

	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet weak var applyButton: UIButton! {
		didSet {
			applyButton.layer.cornerRadius = 16
			applyButton.layer.masksToBounds = true
			applyButton.setTitle(Localizator.standard.localizedString("Применить").uppercased(), for: .normal)
			applyButton.titleLabel?.font =  UIFont(name: "OpenSans-Bold", size: 14)
		}
	}
	
}
