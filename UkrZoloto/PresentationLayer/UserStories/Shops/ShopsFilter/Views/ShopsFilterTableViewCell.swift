//
//  ShopsFilterTableViewCell.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 23.06.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import UIKit

class ShopsFilterTableViewCell: UITableViewCell {
	
	@IBOutlet weak var checkmarkImageView: UIImageView!
	
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var separatorView: UIView!
	

	func setup(isSelected: Bool, title: String, showSeparator: Bool) {
		checkmarkImageView.isHidden = !isSelected
		titleLabel.text = title
		separatorView.isHidden = !showSeparator
	}
    
}
