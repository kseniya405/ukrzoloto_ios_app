//
//  OrderView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/6/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class OrderView: RoundedContainerView {

  // MARK: - Private variables
  private let segmentedControl = BetterSegmentedControl()
  private let indicatorLineView = UIView()
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  private func configureSelf() {
    configureSegmentedControl()
  }
  
  private func configureSegmentedControl() {
    segmentedControl.setOptions([.panningDisabled(true)])
    addHeaderSubview(segmentedControl)
    segmentedControl.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(UIConstants.SegmentedControl.inset)
      make.height.equalTo(UIConstants.SegmentedControl.height)
      make.top.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  func setTabItems(_ viewModels: [ImageTitleViewModel], selectedViewModels: [ImageTitleViewModel]) {
    let segments = IconLabelSegment.segments(withViewModels: viewModels,
                                             selectedViewModels: selectedViewModels,
                                             normalBackgroundColor: Constants.AppColors.mainGreenColor,
                                             selectedBackgroundColor: Constants.AppColors.mainGreenColor,
                                             selectorColor: UIConstants.SegmentedControl.indicatorColor,
                                             iconSize: UIConstants.SegmentedControl.iconSize,
                                             textColor: UIConstants.SegmentedControl.textColor,
                                             selectedTextColor: UIConstants.SegmentedControl.selectedTextColor)
    segmentedControl.segments = segments
    segmentedControl.setOptions([.indicatorViewInset(0)])
  }
  
  func addPageView(_ view: UIView) {
    addSubview(view)
    view.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
  
  func setSelectedTabIndex(_ index: Int) {
    segmentedControl.setIndex(index, animated: true, shouldSendValueChangedEvent: true)
  }
  
  func getSegmentedControl() -> BetterSegmentedControl {
    return segmentedControl
  }
  
  func showGuestView() {
    
  }
  
  func hideGuestView() {
    
  }
  
  // MARK: - Private methods
  
}

private enum UIConstants {
  enum SegmentedControl {
    static let textColor = UIColor.color(r: 255, g: 255, b: 255, a: 0.25)
    
    static let selectedTextColor = UIColor.white
    
    static let iconSize = CGSize(width: 24, height: 24)
    
    static let inset: CGFloat = 24
    static let height: CGFloat = 57
    
    static let indicatorColor = UIColor.color(r: 255, g: 220, b: 136)
  }
}
