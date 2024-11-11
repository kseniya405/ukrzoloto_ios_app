//
//  InitView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class InitView: BaseContentView {
    
    // MARK: - Life cycle
    
    init() {
        super.init(frame: .zero)
        initConfigure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfigure()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initConfigure()
    }
    
    // MARK: - Init configure
    
    func initConfigure() {
        backgroundColor = .white
    }
}
