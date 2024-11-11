//
//  ContentScrollView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 04.05.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import SnapKit

class ContentScrollView: InitView {
  
  // MARK: - Private variables
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  
  // MARK: Init configure
  override open func initConfigure() {
    super.initConfigure()
    configureScrollView()
    configureContentView()
  }
  
  private func configureScrollView() {
    super.addSubview(scrollView)
    scrollView.showsVerticalScrollIndicator = false
    scrollView.keyboardDismissMode = .onDrag
    scrollView.backgroundColor = .clear
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func configureContentView() {
    scrollView.addSubview(contentView)
    contentView.backgroundColor = .clear
    
    contentView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  override func addSubview(_ view: UIView) {
    contentView.addSubview(view)
  }
  
  func setBottomOffset(_ offset: CGFloat) {
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: offset, right: 0)
  }
  
  func scrollToView(_ view: UIView) {
    
    let convertedToSuperview = view.convert(view.frame, to: view.superview)
    let frame = view.convert(convertedToSuperview, to: self)
    
    scrollView.scrollRectToVisible(frame, animated: true)
  }
}

