//
//  LabelConfigurator.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class LabelConfigurator {
    
    // MARK: - Private variables
    
    private let label: UILabel
    
    // MARK: - Life cycle
    
    init(label: UILabel) {
        self.label = label
    }
    
    // MARK: - Public
    
    @discardableResult
    func font(_ font: UIFont) -> LabelConfigurator {
        label.font = font
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor) -> LabelConfigurator {
        label.textColor = color
        return self
    }
    
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> LabelConfigurator {
        label.textAlignment = alignment
        return self
    }
    
    @discardableResult
    func numberOfLines(_ lines: Int) -> LabelConfigurator {
        label.numberOfLines = lines
        return self
    }
}

extension UILabel {
    var config: LabelConfigurator {
        return LabelConfigurator(label: self)
    }
}
