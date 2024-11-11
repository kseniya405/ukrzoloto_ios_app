//
//  ListingVCWrapper.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 10/2/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ListingVCWrapper: NSObject {
  // MARK: - Public variables
  weak var listingVC: ListingViewController?
  
  // MARK: - Life cycle
  init(listingVC: ListingViewController?) {
    self.listingVC = listingVC
  }
  
}
