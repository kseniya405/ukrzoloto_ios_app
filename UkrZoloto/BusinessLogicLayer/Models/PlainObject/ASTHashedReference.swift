//
//  ASTHashedReference.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/15/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

struct ASTHashedReference: Hashable {
  
  // MARK: Reference
  
  var reference: AnyObject
  
  // MARK: Initializer
  
  init(_ reference: AnyObject) {
    self.reference = reference
  }
  
  // Hashable
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(reference))
  }
  
  static func == (lhs: ASTHashedReference, rhs: ASTHashedReference) -> Bool {
    return lhs.reference === rhs.reference
  }
  
}
