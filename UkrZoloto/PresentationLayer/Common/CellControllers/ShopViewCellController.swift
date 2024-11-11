//
//  ShopViewCellController.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 24.06.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import UIKit
import AUIKit

class ShopViewCellController: AUIDefaultViewController {
	
	// MARK: - Public variables
	var selectionView: ShopInfoViewXIB? {
		set { view = newValue }
		get { return view as? ShopInfoViewXIB }
	}
	
	var titleViewModel: TitleViewModel?
	
	var shop: NewShopsItem? {
		didSet {
			didSetViewModel()
		}
	}
	
	var isShorView = false
	
	// MARK: - Actions
	private func didSetViewModel() {
		selectionView?.popupMode = false
		guard let shop = shop else {
			return
		}
		selectionView?.setData(shop: shop, isShortView: isShorView)
	}
	
	override func setupView() {
		super.setupView()
		didSetViewModel()
	}
}

