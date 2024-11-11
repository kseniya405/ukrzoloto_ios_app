//
//  Social.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/5/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON

enum SocialType: String {
  case facebook
  case instagram
  case telegram
  case viber
  case businessChat
}

struct Social {
  
  let type: SocialType
  var image: UIImage
  var webUrl: String
}
