//
//  Bundle+Extension.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 15.07.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

extension Bundle {
  var releaseVersionNumber: String {
    return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
  }
  
  var buildVersionNumber: String {
      return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
  }

  var bundleId: String {
    return (infoDictionary?[kCFBundleIdentifierKey as String] as? String) ??
      (ProcessInfo.processInfo.arguments.first?.split(separator: "/").last.map(String.init)) ?? "Unknown"
  }
}
