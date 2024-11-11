//
//  IconLabelSegment.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/6/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class IconLabelSegment: BetterSegmentedControlSegment {
  
  // MARK: Constants
  private struct DefaultValues {
    static let normalBackgroundColor: UIColor = .clear
    static let selectedBackgroundColor: UIColor = .clear
  }
  
  // MARK: Properties
  var viewModel: ImageTitleViewModel
  var selectedViewModel: ImageTitleViewModel
  var iconSize: CGSize
  var textColor: UIColor
  var selectedTextColor: UIColor
  var font: UIFont
  var labelHeight: CGFloat
  private let normalBackgroundColor: UIColor
  private let selectedBackgroundColor: UIColor
  private let selectorColor: UIColor
  
  // MARK: Lifecycle
  init(viewModel: ImageTitleViewModel,
       selectedViewModel: ImageTitleViewModel,
       normalBackgroundColor: UIColor,
       selectedBackgroundColor: UIColor,
       selectorColor: UIColor,
       iconSize: CGSize,
       textColor: UIColor,
       selectedTextColor: UIColor,
       font: UIFont = UIFont.regularAppFont(of: 12),
       labelHeight: CGFloat = 18) {
    self.viewModel = viewModel
    self.selectedViewModel = selectedViewModel
    self.normalBackgroundColor = normalBackgroundColor
    self.selectedBackgroundColor = selectedBackgroundColor
    self.selectorColor = selectorColor
    self.iconSize = iconSize
    self.textColor = textColor
    self.selectedTextColor = selectedTextColor
    self.font = font
    self.labelHeight = labelHeight
  }

  lazy var intrinsicContentSize: CGSize? = {
    return nil
  }()
  
  lazy var normalView: UIView = {
    return view(with: viewModel,
                iconSize: iconSize,
                textColor: textColor,
                font: font,
                labelHeight: labelHeight,
                backgroundColor: normalBackgroundColor)
  }()
  
  lazy var selectedView: UIView = {
    return view(with: selectedViewModel,
                iconSize: iconSize,
                textColor: selectedTextColor,
                font: font,
                labelHeight: labelHeight,
                backgroundColor: selectedBackgroundColor,
                selectorColor: selectorColor)
  }()
  
  private func view(with imageViewModel: ImageTitleViewModel,
                    iconSize: CGSize,
                    textColor: UIColor,
                    font: UIFont,
                    labelHeight: CGFloat,
                    backgroundColor: UIColor,
                    selectorColor: UIColor? = nil) -> UIView {
    let view = UIView()
    view.backgroundColor = backgroundColor
    let imageView = UIImageView()
    imageView.setImage(from: imageViewModel.image)
    imageView.frame = CGRect(x: 0,
                             y: 0,
                             width: iconSize.width,
                             height: iconSize.height)
    imageView.contentMode = .scaleAspectFit
    imageView.autoresizingMask = [.flexibleLeftMargin,
                                  .flexibleRightMargin]
    view.addSubview(imageView)
    let label = UILabel()
    label.config
      .font(font)
      .textColor(textColor)
      .textAlignment(.center)
    label.text = imageViewModel.title
    label.sizeToFit()
    label.frame = CGRect(x: 0,
                         y: iconSize.height + 4,
                         width: label.frame.width,
                         height: labelHeight)
    label.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
    view.addSubview(label)

    if let selectorColor = selectorColor {
      let indicatorLineView = UIView()

      indicatorLineView.backgroundColor = selectorColor
      indicatorLineView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      indicatorLineView.layer.cornerRadius = UIConstants.indicatorCornerRadius
      view.addSubview(indicatorLineView)
      indicatorLineView.snp.makeConstraints { make in
        make.left.right.bottom.equalToSuperview()
        make.height.equalTo(UIConstants.indicatorHeight)
      }
    }
    
    return view
  }
}

private enum UIConstants {
  static let indicatorCornerRadius: CGFloat = 4
  static let indicatorHeight: CGFloat = 4
}

extension IconLabelSegment {
  class func segments(withViewModels viewModels: [ImageTitleViewModel],
                      selectedViewModels: [ImageTitleViewModel],
                      normalBackgroundColor: UIColor = .clear,
                      selectedBackgroundColor: UIColor = .clear,
                      selectorColor: UIColor = .clear,
                      iconSize: CGSize,
                      textColor: UIColor,
                      selectedTextColor: UIColor,
                      font: UIFont = UIFont.regularAppFont(of: 12),
                      labelHeight: CGFloat = 18) -> [BetterSegmentedControlSegment] {
    let size = min(viewModels.count, selectedViewModels.count)
    return (0 ..< size).map { IconLabelSegment(viewModel: viewModels[$0],
                                               selectedViewModel: selectedViewModels[$0],
                                               normalBackgroundColor: normalBackgroundColor,
                                               selectedBackgroundColor: selectedBackgroundColor,
                                               selectorColor: selectorColor,
                                               iconSize: iconSize,
                                               textColor: textColor,
                                               selectedTextColor: selectedTextColor,
                                               font: font,
                                               labelHeight: labelHeight)
    }
  }
}
