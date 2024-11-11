//
//  AligmentLabelSegment.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 29.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class AligmentLabelSegment: BetterSegmentedControlSegment {
  public struct SelectorIndicator {
    let indicatorColor: UIColor
    let indicatorHeight: CGFloat
    let indicatorCornerRadius: CGFloat
  }
  
  // MARK: Constants
  private struct DefaultValues {
    static let normalBackgroundColor: UIColor = .clear
    static let normalTextColor: UIColor = .white
    static let selectedBackgroundColor: UIColor = .clear
    static let selectedTextColor: UIColor = .black
    static let font: UIFont = UILabel().font
  }
  
  // MARK: Properties
  public let text: String?
  
  public let normalFont: UIFont
  public let normalTextColor: UIColor
  public let normalSelectorIndicator: SelectorIndicator?
  
  public let selectedFont: UIFont
  public let selectedTextColor: UIColor
  public let selectedSelectorIndicator: SelectorIndicator?
  
  private let numberOfLines: Int
  private let accessibilityIdentifier: String?
  private let textAlignment: NSTextAlignment
  
  // MARK: Lifecycle
  public init(text: String? = nil,
              numberOfLines: Int = 1,
              normalSelectorIndicator: SelectorIndicator? = nil,
              normalFont: UIFont? = nil,
              normalTextColor: UIColor? = nil,
              selectedSelectorIndicator: SelectorIndicator? = nil,
              selectedFont: UIFont? = nil,
              selectedTextColor: UIColor? = nil,
              accessibilityIdentifier: String? = nil,
              textAlignment: NSTextAlignment,
              segmentSpace: CGFloat = 0,
              cornerRadius: CGFloat = 0,
              normalBorderColor: UIColor? = nil,
              selectedBorderColor: UIColor? = nil,
              borderWidth: CGFloat = 0) {
    self.text = text
    self.numberOfLines = numberOfLines
    self.normalSelectorIndicator = normalSelectorIndicator
    self.normalFont = normalFont ?? DefaultValues.font
    self.normalTextColor = normalTextColor ?? DefaultValues.normalTextColor
    self.selectedSelectorIndicator = selectedSelectorIndicator
    self.selectedFont = selectedFont ?? DefaultValues.font
    self.selectedTextColor = selectedTextColor ?? DefaultValues.selectedTextColor
    self.accessibilityIdentifier = accessibilityIdentifier
    self.textAlignment = textAlignment
    
    let normalLabel = label(withText: text,
                            selectorIndicator: normalSelectorIndicator,
                            font: self.normalFont,
                            textColor: self.normalTextColor,
                            accessibilityIdentifier: nil,
                            textAlignment: textAlignment)
    
    let selectedLabel = label(withText: text,
                              selectorIndicator: selectedSelectorIndicator,
                              font: self.selectedFont,
                              textColor: self.selectedTextColor,
                              accessibilityIdentifier: accessibilityIdentifier,
                              textAlignment: textAlignment)
    
    if segmentSpace == 0 {
      normalView = normalLabel
      selectedView = selectedLabel
    } else {
      normalView = labelViewWithSpace(withText: text,
                                      selectorIndicator: normalSelectorIndicator,
                                      font: self.normalFont,
                                      textColor: self.normalTextColor,
                                      accessibilityIdentifier: nil,
                                      textAlignment: textAlignment,
                                      segmentSpace: segmentSpace,
                                      cornerRadius: cornerRadius,
                                      borderColor: normalBorderColor,
                                      borderWidth: borderWidth)
      selectedView = labelViewWithSpace(withText: text,
                                        selectorIndicator: selectedSelectorIndicator,
                                        font: self.selectedFont,
                                        textColor: self.selectedTextColor,
                                        accessibilityIdentifier: accessibilityIdentifier,
                                        textAlignment: textAlignment,
                                        segmentSpace: segmentSpace,
                                        cornerRadius: cornerRadius,
                                        borderColor: selectedBorderColor,
                                        borderWidth: borderWidth)
    }
    
    func label(withText text: String?,
               selectorIndicator: SelectorIndicator?,
               font: UIFont,
               textColor: UIColor,
               accessibilityIdentifier: String?,
               textAlignment: NSTextAlignment) -> UILabel {
      let label = UILabel()
      label.text = text
      label.numberOfLines = numberOfLines
      label.backgroundColor = .clear
      label.font = font
      label.textColor = textColor
      label.lineBreakMode = .byTruncatingTail
      label.textAlignment = textAlignment
      label.accessibilityIdentifier = accessibilityIdentifier
      
      if let selectorIndicator = selectorIndicator {
        let indicatorLineView = UIView()
        
        indicatorLineView.backgroundColor = selectorIndicator.indicatorColor
        indicatorLineView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        indicatorLineView.layer.cornerRadius = selectorIndicator.indicatorCornerRadius
        label.addSubview(indicatorLineView)
        indicatorLineView.snp.makeConstraints { make in
          make.left.right.bottom.equalToSuperview()
          make.height.equalTo(selectorIndicator.indicatorHeight)
        }
      }
      
      return label
    }
    
    // MARK: - private func
    func labelViewWithSpace(withText text: String?,
                            selectorIndicator: SelectorIndicator?,
                            font: UIFont,
                            textColor: UIColor,
                            accessibilityIdentifier: String?,
                            textAlignment: NSTextAlignment,
                            segmentSpace: CGFloat = 0,
                            cornerRadius: CGFloat = 0,
                            borderColor: UIColor? = nil,
                            borderWidth: CGFloat = 0) -> UIView {
      let view = UIView()
      let label = label(withText: text,
                        selectorIndicator: selectorIndicator,
                        font: font,
                        textColor: textColor,
                        accessibilityIdentifier: accessibilityIdentifier,
                        textAlignment: textAlignment)
      view.addSubview(label)
      label.snp.makeConstraints { make in
        make.bottom.top.equalToSuperview()
        make.leading.equalToSuperview()
          .offset(segmentSpace)
        make.trailing.equalToSuperview()
          .offset(-segmentSpace)
      }
      label.layer.borderWidth = borderWidth
      label.layer.borderColor = borderColor?.cgColor
      label.layer.cornerRadius = cornerRadius
      label.layer.masksToBounds = true
      return view
    }
  }
  
  // MARK: BetterSegmentedControlSegment
  public lazy var intrinsicContentSize: CGSize? = {
    return nil
  }()
  
  public var normalView: UIView
  public var selectedView: UIView
  
  open func label(withText text: String?,
                  selectorIndicator: SelectorIndicator?,
                  font: UIFont,
                  textColor: UIColor,
                  accessibilityIdentifier: String?,
                  textAlignment: NSTextAlignment) -> UILabel {
    let label = UILabel()
    label.text = text
    label.numberOfLines = numberOfLines
    label.backgroundColor = .clear
    label.font = font
    label.textColor = textColor
    label.lineBreakMode = .byTruncatingTail
    label.textAlignment = textAlignment
    label.accessibilityIdentifier = accessibilityIdentifier
    
    if let selectorIndicator = selectorIndicator {
      let indicatorLineView = UIView()
      
      indicatorLineView.backgroundColor = selectorIndicator.indicatorColor
      indicatorLineView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      indicatorLineView.layer.cornerRadius = selectorIndicator.indicatorCornerRadius
      label.addSubview(indicatorLineView)
      indicatorLineView.snp.makeConstraints { make in
        make.left.right.bottom.equalToSuperview()
        make.height.equalTo(selectorIndicator.indicatorHeight)
      }
    }
    
    return label
  }
}

private enum UIConstants {
  static let indicatorCornerRadius: CGFloat = 2
  static let indicatorHeight: CGFloat = 2
}

extension AligmentLabelSegment {
  class func segments(
    withTitles titles: [String],
    numberOfLines: Int = 1,
    normalSelectorIndicator: SelectorIndicator? = nil,
    normalFont: UIFont? = nil,
    normalTextColor: UIColor? = nil,
    selectedSelectorIndicator: SelectorIndicator? = nil,
    selectedFont: UIFont? = nil,
    selectedTextColor: UIColor? = nil,
    textAlignment: NSTextAlignment = .center,
    segmentSpace: CGFloat = 0,
    cornerRadius: CGFloat = 0,
    normalBorderColor: UIColor? = nil,
    selectedBorderColor: UIColor? = nil,
    borderWidth: CGFloat = 0) -> [BetterSegmentedControlSegment] {
      
      return titles.map {
        AligmentLabelSegment(
          text: $0,
          numberOfLines: numberOfLines,
          normalSelectorIndicator: normalSelectorIndicator,
          normalFont: normalFont,
          normalTextColor: normalTextColor,
          selectedSelectorIndicator: selectedSelectorIndicator,
          selectedFont: selectedFont,
          selectedTextColor: selectedTextColor,
          textAlignment: textAlignment,
          segmentSpace: segmentSpace,
          cornerRadius: cornerRadius,
          normalBorderColor: normalBorderColor,
          selectedBorderColor: selectedBorderColor,
          borderWidth: borderWidth)
      }
    }
  
  class func segments(
    withTitlesAndAccessibilityIdentifiers titlesAndAccessibilityIdentifiers: [(title: String, accessibilityIdentifier: String?)],
    numberOfLines: Int = 1,
    normalSelectorIndicator: SelectorIndicator? = nil,
    normalFont: UIFont? = nil,
    normalTextColor: UIColor? = nil,
    selectedSelectorIndicator: SelectorIndicator? = nil,
    selectedFont: UIFont? = nil,
    selectedTextColor: UIColor? = nil,
    selectorColor: UIColor? = nil,
    textAlignment: NSTextAlignment = .center) -> [BetterSegmentedControlSegment] {
      return titlesAndAccessibilityIdentifiers.map {
        AligmentLabelSegment(
          text: $0.title,
          numberOfLines: numberOfLines,
          normalSelectorIndicator: normalSelectorIndicator,
          normalFont: normalFont,
          normalTextColor: normalTextColor,
          selectedSelectorIndicator: selectedSelectorIndicator,
          selectedFont: selectedFont,
          selectedTextColor: selectedTextColor,
          accessibilityIdentifier: $0.accessibilityIdentifier,
          textAlignment: textAlignment)
      }
    }
}
