//
//  LineHeightLabel.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class LineHeightLabel: UILabel {
	
	// MARK: - Private variables
	
	private var realLineHeight: CGFloat = 18
	
	// MARK: - Public variables
	
	var lineHeight: CGFloat {
		set { realLineHeight = newValue - UIConstants.lineHeightCorrectOffset }
		get { return realLineHeight + UIConstants.lineHeightCorrectOffset }
	}
	
	override var text: String? {
		didSet {
			setLineHeight(realLineHeight)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setLineHeight(realLineHeight)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI constants
	
	private struct UIConstants {
		static let defaultLineHeight: CGFloat = 18
		static let lineHeightCorrectOffset: CGFloat = 3
	}
}
