//
//  String+Extension.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 05.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

extension String {
  func cyrillic() -> String {
    return self.addingPercentEncoding(
      withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
  }
  
  func trim() -> String {
    return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
  }
  
  func withoutWhitespaces() -> String {
    return components(separatedBy: " ").joined(separator: "")
  }
  
  func digitsOnly() -> String {
    return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
  }
  
  func escapingCyrillic() -> String {
    return self.addingPercentEncoding(
      withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
  }
  
  var removeBackslashes: String {
    return self.replacingOccurrences(of: "/", with: "")
  }
  
  var removeUZPrefix: String {
    return self.replacingOccurrences(of: "UZ", with: "")
  }
  
  var containsOnlyNumbers: Bool {
    
    let regex = NSRegularExpression(Constants.Regex.numbersOnly)
    return regex.matches(self)
  }
  
  func stringByAddingPercentEncodingForRFC3986() -> String? {
    let unreserved = "-._~/?"
    let allowed = NSMutableCharacterSet.alphanumeric()
    allowed.addCharacters(in: unreserved)
    return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
  }
  
  func stringByAddingPercentEncodingForFormData(plusForSpace: Bool = false) -> String? {
    let unreserved = "*-._"
    let allowed = NSMutableCharacterSet.alphanumeric()
    allowed.addCharacters(in: unreserved)

    if plusForSpace {
      allowed.addCharacters(in: " ")
    }

    var encoded = addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    if plusForSpace {
      encoded = encoded?.replacingOccurrences(of: " ", with: "+")
    }
    return encoded
  }
	
	func toCLLocationCoordinate2D() -> CLLocationCoordinate2D? {
		let coordinatesStringArray = self.components(separatedBy: ", ")
		let lat = Double(coordinatesStringArray.first ?? "")
		let long = Double(coordinatesStringArray.last ?? "")
		if let lat = lat, let long = long {
			return CLLocationCoordinate2D(latitude: lat, longitude: long)
		}
		return nil
	}
}
