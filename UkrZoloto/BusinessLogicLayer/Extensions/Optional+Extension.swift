//
//  Optional+Extension.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let value):
            return value.isEmpty
        }
    }
    
    func nonEmptyString() -> String? {
        return self.isNilOrEmpty ? nil : self
    }
    
    public static func < (lhs: Optional, rhs: Optional) -> Bool {
        if let lhs = lhs {
            if let rhs = rhs {
                return lhs < rhs
            } else {
                return false
            }
        } else {
            return true
        }
    }
}

extension Optional where Wrapped == Int {
    public static func < (lhs: Optional, rhs: Optional) -> Bool {
        if let lhs = lhs {
            if let rhs = rhs {
                return lhs < rhs
            } else {
                return false
            }
        } else {
            return true
        }
    }
}
