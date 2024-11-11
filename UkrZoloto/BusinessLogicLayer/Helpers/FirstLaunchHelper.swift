//
//  FirstLaunchHelper.swift
//  UkrZoloto
//
//  Created by Mykola on 04.08.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class FirstLaunchHelper {
  
  private let key = "kFirstLaunchFlag"
  
  func trackFirstLaunchIfNeeded() {
   
    if !UserDefaults.standard.bool(forKey: key) {
        
      EventService.shared.logFirstLaunch()
      UserDefaults.standard.setValue(true, forKey: key)
    }
  }
}
