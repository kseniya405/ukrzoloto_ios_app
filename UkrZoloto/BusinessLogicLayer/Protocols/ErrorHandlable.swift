//
//  ErrorHandlable.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 11/4/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol ErrorHandlable: AnyObject {
    func handleError(_ error: Error)
}
