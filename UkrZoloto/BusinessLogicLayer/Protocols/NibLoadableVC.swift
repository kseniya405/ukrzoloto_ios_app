//
//  NibLoadableVC.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 11.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol NibLoadableVC: AnyObject {
    static func fromNib() -> Self
}

extension NibLoadableVC where Self: UIViewController {
    static func fromNib() -> Self {
        return self.init(nibName: String(describing: Self.self),
                         bundle: Bundle.main)
    }
}
