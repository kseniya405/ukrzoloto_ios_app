//
//  Coordinator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class Coordinator: NSObject {
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start(completion: (() -> Void)? = nil) {
    
  }
  
}
