//
//  AnimationViewInput.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol AnimationViewInput: AnyObject {
  var isElemetsHidden: Bool { get set }
  func hideElements()
  func showElements()
}
