//
//  HashableTitle.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/13/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

protocol HashableTitle {
  associatedtype T: Hashable
  var id: T { get }
  var title: String { get }
}
