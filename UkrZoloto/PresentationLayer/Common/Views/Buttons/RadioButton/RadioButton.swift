//
//  RadioButton.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 10.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum RadioState {
    case active
    case inactive
    case inactiveGreen
}

class RadioButton: UIButton {
    
    // MARK: - Public variables
    var buttonState: RadioState = .inactive {
        didSet {
            update()
        }
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Configure
    private func setupView() {
        titleLabel?.font = UIConstants.Label.font
        layer.cornerRadius = UIConstants.Button.cornerRadius
        update()
    }
    
    // MARK: - Public methods
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(nil, for: state)
        guard let title = title,
            !title.isEmpty else {
                setAttributedTitle(nil, for: state)
                return
        }
        let attributedString = NSMutableAttributedString(string: title)
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.kern: UIConstants.Label.letterSpacing,
            NSAttributedString.Key.foregroundColor: titleColor(for: state) ?? UIConstants.UnfilledButton.textColor,
            NSAttributedString.Key.font: titleLabel?.font ?? UIConstants.Label.font
        ]
        attributedString.addAttributes(attrs,
                                       range: NSRange(location: 0, length: attributedString.length))
        setAttributedTitle(attributedString, for: state)
    }
    
    // MARK: - Private methods
    private func update() {
        switch buttonState {
        case .active:
            backgroundColor = UIConstants.FilledButton.backgroundColor
            setTitleColor(UIConstants.FilledButton.textColor, for: .normal)
        case .inactive:
            backgroundColor = UIConstants.UnfilledButton.backgroundColor
            setTitleColor(UIConstants.UnfilledButton.textColor, for: .normal)
            layer.borderColor = UIConstants.UnfilledButton.borderColor
            layer.borderWidth = UIConstants.UnfilledButton.borderWidth
        case .inactiveGreen:
            backgroundColor = UIConstants.UnfilledGreenButton.backgroundColor
            setTitleColor(UIConstants.UnfilledGreenButton.textColor, for: .normal)
            layer.borderColor = UIConstants.UnfilledGreenButton.borderColor
            layer.borderWidth = UIConstants.UnfilledGreenButton.borderWidth
        }
        setTitle(attributedTitle(for: .normal)?.string, for: .normal)
    }
    
}

private enum UIConstants {
    enum Label {
        static let font = UIFont.regularAppFont(of: 14)
        static let letterSpacing: CGFloat = 0.2
    }

    enum Button {
        static let cornerRadius: CGFloat = 16
    }
    
    struct FilledButton {
        static let textColor = UIColor.white
        static let backgroundColor = UIColor(named: "darkGreen")!
    }
    
    struct UnfilledButton {
        static let textColor = UIColor.color(r: 62, g: 76, b: 75)
        static let borderColor = UIColor(named: "darkGreen")!.cgColor
        static let backgroundColor = UIColor.white
        static let borderWidth: CGFloat = 1
    }
  
    struct UnfilledGreenButton {
        static let textColor = UIColor.color(r: 0, g: 80, b: 47)
        static let borderColor = UIColor(named: "darkGreen")!.cgColor
        static let backgroundColor = UIColor.white
        static let borderWidth: CGFloat = 1
  }
}
