//
//  UIColor+Extension.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

typealias ColorDiapason = UInt8

extension UIColor {
    
    class func color(r: ColorDiapason,
                     g: ColorDiapason,
                     b: ColorDiapason,
                     a: CGFloat = 1) -> UIColor {
        let convertedRed = CGFloat(r) / CGFloat(ColorDiapason.max)
        let convertedGreen = CGFloat(g) / CGFloat(ColorDiapason.max)
        let convertedBlue = CGFloat(b) / CGFloat(ColorDiapason.max)
        let convertedAlpha = a
        let color = UIColor(red: convertedRed,
                            green: convertedGreen,
                            blue: convertedBlue,
                            alpha: convertedAlpha)
        return color
    }
  
  convenience init(hex string: String) {
      var hex = string.hasPrefix("#")
          ? String(string.dropFirst())
          : string
      guard hex.count == 3 || hex.count == 6
          else {
              self.init(white: 1.0, alpha: 0.0)
              return
      }
      if hex.count == 3 {
          for (index, char) in hex.enumerated() {
              hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
          }
      }
      
      self.init(
          red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
          green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
          blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
  }
}
