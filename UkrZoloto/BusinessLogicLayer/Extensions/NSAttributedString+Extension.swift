//
//  NSAttributedString+Extension.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/17/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

extension NSAttributedString {
  
  class func strikedAttributedText(from string: String) -> NSAttributedString {
    let attributes = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
    let attrString = NSAttributedString(string: string,
                                        attributes: attributes)
    return attrString
  }
  
}
