//
//  ScrollableTableViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/17/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol ScrollableTableViewControllerDelegate: AnyObject {
  func tableViewDidScroll()
}

class ScrollableTableViewController: AUIDefaultTableViewController {

  // MARK: - Public variables
  weak var delegate: ScrollableTableViewControllerDelegate?
  
  // MARK: - ScrollView
  override func didScroll() {
    delegate?.tableViewDidScroll()
  }
  
  override func didEndDisplayingHeaderInSection(_ section: Int) {
    guard sectionControllers.indices.contains(section) else { return }
    sectionControllers[section].didEndDisplayingHeader()
  }
}
