//
//  Fonts.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 24.05.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import UIKit

enum Fonts {
	static let openSansLight = "OpenSans-Light"
	static let openSansRegular = "OpenSans-Regular"
	static let openSansSemiBold = "OpenSans-SemiBold"
	static let openSansBold = "OpenSans-Bold"
	static let openSansExtraBold = "OpenSans-ExtraBold"
	static let aliceRegular = "Alice-Regular"
}

// MARK: - Font extension

extension UIFont {
	
	static func lightAppFont(of size: CGFloat) -> UIFont {
		return UIFont(name: Fonts.openSansLight, size: size) ?? .systemFont(ofSize: size, weight: .light)
	}
	
	static func regularAppFont(of size: CGFloat) -> UIFont {
		return UIFont(name: Fonts.openSansRegular, size: size) ?? .systemFont(ofSize: size, weight: .regular)
	}
	
	static func semiBoldAppFont(of size: CGFloat) -> UIFont {
		return UIFont(name: Fonts.openSansSemiBold, size: size) ?? .systemFont(ofSize: size, weight: .semibold)
	}
	
	static func boldAppFont(of size: CGFloat) -> UIFont {
		return UIFont(name: Fonts.openSansBold, size: size) ?? .systemFont(ofSize: size, weight: .bold)
	}
	
	static func extraBoldAppFont(of size: CGFloat) -> UIFont {
		return UIFont(name: Fonts.openSansExtraBold, size: size) ?? .systemFont(ofSize: size, weight: .black)
	}
	
	static func aliceRegularFont(of size: CGFloat) -> UIFont {
		return UIFont(name: Fonts.aliceRegular, size: size) ?? .systemFont(ofSize: size, weight: .regular)
	}
}
