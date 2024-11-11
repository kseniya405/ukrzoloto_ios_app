//
//  PanableView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class PanableView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  private func initConfigure() {
    let lineView = UIView(frame: UIConstants.LineView.frame)
    lineView.backgroundColor = UIConstants.LineView.backgroundColor
    lineView.layer.cornerRadius = UIConstants.LineView.cornerRadius
    addSubview(lineView)
    
    lineView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfigure()
  }
}

private enum UIConstants {
  enum LineView {
    static let size = CGSize(width: 47,
                             height: 4)
    static let frame = CGRect(origin: .zero,
                              size: UIConstants.LineView.size)
    static let backgroundColor = UIColor.color(r: 196, g: 196, b: 196)
    static let cornerRadius: CGFloat = 4
  }
}
