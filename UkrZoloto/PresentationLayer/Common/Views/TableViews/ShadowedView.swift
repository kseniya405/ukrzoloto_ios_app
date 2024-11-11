//
//  ShadowedView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/29/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ShadowedView<T: UIView>: UIView {
  
  var view: T
  
  // MARK: - Life cycle
  init(_ view: T, cornerRadius: CGFloat = UIConstants.SelfView.cornerRadius) {
    self.view = view
    super.init(frame: .zero)
    initConfigure(cornerRadius: cornerRadius)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupShadow()
  }
  
  // MARK: - Init configure
  private func initConfigure(cornerRadius: CGFloat) {
    view.layer.cornerRadius = cornerRadius
    layer.cornerRadius = cornerRadius
    backgroundColor = UIConstants.SelfView.backgroundColor
    addSubview(view)
    view.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
  
  func setupShadow() {
    layer.shadowOpacity = UIConstants.SelfView.shadowOpacity
    let shadowRadius = UIConstants.SelfView.shadowRadius
    let shadowRect = CGRect(origin: CGPoint(x: bounds.origin.x - shadowRadius / 2,
                                            y: bounds.origin.y + shadowRadius),
                            size: CGSize(width: bounds.width + shadowRadius,
                                         height: bounds.height))
    layer.shadowPath = UIBezierPath(roundedRect: shadowRect,
                                    cornerRadius: UIConstants.SelfView.cornerRadius).cgPath
    layer.shadowColor = UIConstants.SelfView.shadowColor.cgColor
    layer.shadowOffset = .zero
    layer.shadowRadius = shadowRadius / 2
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
    static let cornerRadius: CGFloat = 16
    static let shadowRadius: CGFloat = 12.0
    static let shadowOpacity: Float = 0.2
    
    static let shadowColor = UIColor.color(r: 157, g: 164, b: 183)
  }
}
