//
//  RadioController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 10.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

class RadioController: NSObject {
    
    // MARK: - Public variables
    var buttons = [RadioButton]()
    
    // MARK: - Public methods
    func selectButton(_ button: RadioButton) {
        buttons.forEach { radioButton in
            guard radioButton != button else {
                radioButton.buttonState = .active
                return
            }
            radioButton.buttonState = .inactive
        }
    }
    
}
