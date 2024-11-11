//
//  CreditOption.swift
//  UkrZoloto
//
//  Created by Mykola on 29.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreditOption {
  
  private(set) var title: String!
  private(set) var descriptionString: String!
  private(set) var comission: Double!
  private(set) var month: [Int]!
	private(set) var code: String!
	private(set) var icon: String
	private(set) var showAsIcon: Bool
  
  init?(json: JSON) {
    
    guard let title = json[NetworkResponseKey.Credits.title].string,
          let description = json[NetworkResponseKey.Credits.description].string,
          let code = json[NetworkResponseKey.Credits.code].string,
          let comission = json[NetworkResponseKey.Credits.comission].double,
					let icon = json[NetworkResponseKey.Credits.icon].string else {
            return nil
          }
        
    self.title = title.replacingOccurrences(of: "&nbsp;", with: "\u{00A0}")
    self.descriptionString = description.replacingOccurrences(of: "&nbsp;", with: "\u{00A0}")
    self.comission = comission
    self.code = code
		self.icon = icon
    
    if let month = json[NetworkResponseKey.Credits.month].int {
      self.month = [month]
    } else if let array = json[NetworkResponseKey.Credits.month].array {
      let ints: [Int] = array.map({$0.intValue})
      self.month = ints
    }
		self.showAsIcon = json[NetworkResponseKey.Credits.showAsIcon].boolValue
  }
	
	init(title: String, descriptionString: String, comission: Double, month: [Int],
 code: String,
 icon: String,
 showAsIcon: Bool) {
		self.title = title
		self.descriptionString = descriptionString
		self.comission = comission
		self.month = month
		self.code = code
		self.icon = icon
		self.showAsIcon = showAsIcon
	}
}
