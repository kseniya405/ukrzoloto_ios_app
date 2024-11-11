//
//  Utils.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 02.11.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class Utils {

  // MARK: - Public variables
  static let shared = Utils()
  
  // MARK: - Life cycle
  private init() { }
  
  // MARK: - Interface
  func generateBarcode(from string: String) -> UIImage? {
      let data = string.data(using: String.Encoding.ascii)

      if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
          filter.setValue(data, forKey: "inputMessage")
          let transform = CGAffineTransform(scaleX: 3, y: 3)

          if let output = filter.outputImage?.transformed(by: transform) {
              return UIImage(ciImage: output)
          }
      }

      return nil
  }

}
