//
//  DefaultTableViewHeaderFooterController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

class DefaultTableViewHeaderFooterController: AUIElementTableViewHeaderFooterController {

  override var height: CGFloat {
    return controller.view?.bounds.height ?? UITableView.automaticDimension
  }

}
