//
//  LanguageTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/4/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import BetterSegmentedControl

protocol LanguageTableViewCellDelegate: AnyObject {
  func didChangeLanguage(with index: Int)
}

class LanguageTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: LanguageTableViewCellDelegate?
  
  // MARK: - Private variables
  private let languageLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.LanguageLabel.lineHeight
    label.config
      .font(UIConstants.LanguageLabel.font)
      .textColor(UIConstants.LanguageLabel.textColor)
    return label
  }()
  
  private let segmentedControl = BetterSegmentedControl()
  private let indicatorLineView = UIView()
  
  private var isConfiguring: Bool = false
  
  // MARK: - Life Cycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfigure()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initConfigure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initConfigure()
  }
  
  private func initConfigure() {
    selectionStyle = .none
    setupView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    clipsToBounds = true
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    layer.cornerRadius = UIConstants.cornerRadius
  }
  
  private func setupView() {
    configureLanguageLabel()
    configureSegmentedLabel()
  }
  
  private func configureLanguageLabel() {
    contentView.addSubview(languageLabel)
    languageLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.LanguageLabel.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.LanguageLabel.leading)
    }
  }
  
  private func configureSegmentedLabel() {
    segmentedControl.setOptions([.panningDisabled(true)])
    contentView.addSubview(segmentedControl)
    segmentedControl.snp.makeConstraints { make in
      make.centerY.equalTo(languageLabel)
      make.leading.equalTo(languageLabel.snp.trailing)
        .offset(UIConstants.SegmentedControl.leading)
      make.width.equalTo(UIConstants.SegmentedControl.width)
      make.height.equalTo(UIConstants.SegmentedControl.height)
      make.bottom.equalToSuperview()
    }
    configureIndicatorLineView()
    segmentedControl.addTarget(self,
                               action: #selector(didChangeLanguage),
                               for: .valueChanged)
  }
  
  private func configureIndicatorLineView() {
    indicatorLineView.backgroundColor = UIConstants.SegmentedControl.indicatorColor
    indicatorLineView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    indicatorLineView.layer.cornerRadius = UIConstants.SegmentedControl.indicatorCornerRadius
    segmentedControl.indicatorView.addSubview(indicatorLineView)
    indicatorLineView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(UIConstants.SegmentedControl.indicatorHeight)
    }
  }
  
  // MARK: - Interface
  func configure(title: String,
                 viewModels: [TitleViewModel],
                 selectedViewModel: TitleViewModel) {
    isConfiguring = true
    languageLabel.text = title
    let segments = LabelSegment.segments(
      withTitles: viewModels.compactMap { $0.title },
      numberOfLines: 1,
      normalBackgroundColor: UIColor.white,
      normalFont: UIConstants.SegmentedControl.font,
      normalTextColor: UIConstants.SegmentedControl.textColor,
      selectedBackgroundColor: UIColor.clear,
      selectedFont: UIConstants.SegmentedControl.font,
      selectedTextColor: UIConstants.SegmentedControl.selectedTextColor)
    segmentedControl.segments = segments
    segmentedControl.setOptions([.indicatorViewInset(0)])
    segmentedControl.setIndex(
      viewModels.firstIndex(where:
        { $0.title == selectedViewModel.title }) ?? 0)
    isConfiguring = false
  }
  
  // MARK: - Actions
  @objc
  private func didChangeLanguage() {
    guard !isConfiguring else { return }
    delegate?.didChangeLanguage(with: segmentedControl.index)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  static let cornerRadius: CGFloat = 16
  
  enum LanguageLabel {
    static let font = UIFont.regularAppFont(of: 15)
    static let lineHeight: CGFloat = 18
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    
    static let leading: CGFloat = 24
    static let top: CGFloat = 30 * Constants.Screen.heightCoefficient
  }
  
  enum SegmentedControl {
    static let leading: CGFloat = 30
    static let trailing: CGFloat = 65
    static let height: CGFloat = 30
    static let width: CGFloat = 90
    
    static let indicatorColor = UIColor.color(r: 0, g: 80, b: 47)
    static let indicatorHeight: CGFloat = 4
    static let indicatorCornerRadius: CGFloat = 0
    
    static let iconSize: CGSize = CGSize(width: 0, height: 0)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75).withAlphaComponent(0.45)
    static let selectedTextColor = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.boldAppFont(of: 14)
    static let labelHeight: CGFloat = 24
  }
}
