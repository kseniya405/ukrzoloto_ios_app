//
//  ShopTableViewCell.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 17.04.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

	@IBOutlet weak var mainStackView: UIStackView!
	@IBOutlet weak var shopImageView: UIImageView!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var shopStatusLabel: UILabel!
	@IBOutlet weak var openTimeLabel: UILabel!
	@IBOutlet weak var jewelerLabel: UILabel!
	
	override func prepareForReuse() {
    super.prepareForReuse()
		shopImageView.image = nil
		addressLabel.text = ""
		shopStatusLabel.text = ""
		openTimeLabel.text = ""
		jewelerLabel.text = ""
		openTimeLabel.isHidden = true
		jewelerLabel.isHidden = true
	}
	
	func setupLayout() {
		mainStackView.spacing = 15
	}
    
}
