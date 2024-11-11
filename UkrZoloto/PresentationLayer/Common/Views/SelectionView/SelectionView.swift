//
//  SelectionView.swift
//  UkrZoloto
//
//  Created by Andrew on 7/21/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit

enum SelectionViewStyle {
	case small
  case normal
  case big
	case selectedCity
}

struct SeparatorPosition: OptionSet {
  let rawValue: Int
  
  static let top = SeparatorPosition(rawValue: 1 << 0)
  static let bottom = SeparatorPosition(rawValue: 1 << 1)
}

class SelectionView: UIView {
  
  // MARK: - Private variables
  private let leftImageView = UIImageView()
  private let titleLabel = LineHeightLabel()
  private let rightImageView = UIImageView()
  private let topSeparatorView = UIView()
  private let bottomSeparatorView = UIView()
	private let leftSpaceView = UIView()
  
  private var labelLeadingConstraint: Constraint?
  private var hasLeftImage = false
  private let style: SelectionViewStyle
	private var withoutLeftSpace: Bool = false
  
  // MARK: - Life cycle
	init(style: SelectionViewStyle = .normal, frame: CGRect = .zero, withoutLeftSpace: Bool = false) {
    self.style = style
		self.withoutLeftSpace = withoutLeftSpace
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if hasLeftImage {
      labelLeadingConstraint?.deactivate()
    } else {
      labelLeadingConstraint?.activate()
    }
    super.updateConstraints()
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureLeftImageView()
    configureTitleLabel()
    configureRightImageView()
    configureTopSeparatorView()
    configureBottomSeparatorView()
    setSeparatorPosition(.bottom)
		configureLeftSpaceView()
  }
  
  private func configureLeftImageView() {
    leftImageView.contentMode = UIConstants.ImageView.contentMode
    leftImageView.backgroundColor = UIConstants.ImageView.backgroundColor
    addSubview(leftImageView)
    leftImageView.snp.makeConstraints { make in
			make.top.greaterThanOrEqualToSuperview().inset(getTopLeftImageView(style: style))
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview()
				.offset(getLeftImageLeading())
			let side = style == .big ? UIConstants.ImageView.bigSide : UIConstants.ImageView.side
			make.height.width.equalTo(side)
    }
  }
	
	private func getTopLeftImageView(style: SelectionViewStyle) -> CGFloat{
		switch style {
		case .small, .selectedCity:
			return UIConstants.ImageView.smallTop
		case .normal:
			return UIConstants.ImageView.top
		case .big:
			return UIConstants.ImageView.bigTop
		}
	}
	
	private func configureLeftSpaceView() {
		if style != .selectedCity { return }
		addSubview(leftSpaceView)
		leftSpaceView.snp.makeConstraints { make in
				make.top.greaterThanOrEqualToSuperview().inset(getTopLeftImageView(style: style))
				make.centerY.equalToSuperview()
				make.leading.equalToSuperview()
					.offset(getLeftImageLeading())
				make.height.width.equalTo(UIConstants.ImageView.side)
		}
	}
  
  private func configureTitleLabel() {
    titleLabel.config
      .font(UIConstants.TitleLabel.font)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
      .textColor(UIConstants.TitleLabel.textColor)
      .textAlignment(UIConstants.TitleLabel.textAlignment)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      
			switch style {
			case .small:
				make.top.greaterThanOrEqualToSuperview()
				make.bottom.lessThanOrEqualToSuperview()
				make.trailing.equalToSuperview()
					.offset(-10)
				make.leading.equalTo(leftImageView.snp.trailing)
					.offset(5)
			case .normal, .big:
				make.top.greaterThanOrEqualToSuperview()
				if withoutLeftSpace {
					make.leading.equalToSuperview()
				} else {
					make.leading.equalTo(leftImageView.snp.trailing)
						.offset(UIConstants.TitleLabel.left).priority(999)
				}
			case .selectedCity:
				make.top.greaterThanOrEqualToSuperview()
				make.bottom.lessThanOrEqualToSuperview()
				make.leading.equalToSuperview()
					.offset(24)
			}
			make.centerY.equalToSuperview()
				.offset(UIConstants.TitleLabel.centerYOffset)
    }
//    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
//    titleLabel.setContentHuggingPriority(.required, for: .vertical)
  }
  
  private func configureRightImageView() {
		if rightImageView.isHidden {
			return
		}
    rightImageView.contentMode = UIConstants.ImageView.contentMode
    rightImageView.backgroundColor = UIConstants.ImageView.backgroundColor
    rightImageView.image = UIConstants.ImageView.image
    addSubview(rightImageView)
    rightImageView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
				.offset(style == .small ?
								0 : UIConstants.RightImageView.centerYOffset)
      make.leading.equalTo(titleLabel.snp.trailing)
			make.trailing.equalToSuperview().offset(getRightImageTrailing())
      make.height.equalTo(UIConstants.ImageView.side)
      make.width.equalTo(UIConstants.ImageView.side)
    }
  }
	
	private func getRightImageTrailing() -> CGFloat {
		switch style {
		case .small, .normal:
			return 0
		case .big:
			return UIConstants.RightImageView.bigRightOffset
		case .selectedCity:
			return -24
		}
	}
  
	private func getLeftImageLeading() -> CGFloat {
		switch style {
		case .small:
			return 10
		case .big, .normal:
			return 0
		case .selectedCity:
			return 24
		}
	}
	
  private func configureTopSeparatorView() {
    topSeparatorView.backgroundColor = UIConstants.UnderlineView.color
    addSubview(topSeparatorView)
    topSeparatorView.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel)
      make.trailing.equalToSuperview()
				.offset(style == .selectedCity ? -24 : 0)
      make.height.equalTo(UIConstants.UnderlineView.height)
      make.top.equalToSuperview()
    }
  }
  
  private func configureBottomSeparatorView() {
    bottomSeparatorView.backgroundColor = UIConstants.UnderlineView.color
    addSubview(bottomSeparatorView)
    bottomSeparatorView.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel)
			make.trailing.equalToSuperview()
				.offset(style == .selectedCity ? -24 : 0)
			make.height.equalTo(UIConstants.UnderlineView.height)
      make.bottom.equalToSuperview()
    }
  }
  
  private func showLeftImage(imageViewModel: ImageViewModel) {
    leftImageView.setImage(from: imageViewModel)
		leftImageView.contentMode = .scaleAspectFill
    hasLeftImage = true
    setNeedsUpdateConstraints()
  }
  
  private func hideLeftImage() {
    leftImageView.image = nil
    hasLeftImage = false
    setNeedsUpdateConstraints()
  }
  
  // MARK: - Interface
  func setLeftImage(_ imageViewModel: ImageViewModel?) {
		if style == .selectedCity {
			leftImageView.image = UIImage()
			return
		}
    guard let imageViewModel = imageViewModel else {
      hideLeftImage()
      return
    }
    if case .image(let image) = imageViewModel,
       image == nil {
      hideLeftImage()
    } else {
      showLeftImage(imageViewModel: imageViewModel)
    }
  }
  
  func setRightImage(_ imageViewModel: ImageViewModel?) {
    if let imageViewModel = imageViewModel {
      rightImageView.setImage(from: imageViewModel)
			rightImageView.isHidden = false
    } else {
      rightImageView.image = nil
			rightImageView.isHidden = true
    }
		configureRightImageView()
		setNeedsUpdateConstraints()
  }
  
  func setTitle(_ title: String?) {
    titleLabel.text = title
//		configureTitleLabel()
  }
  
  func setFont(_ font: UIFont) {
    titleLabel.font = font
  }
  
  func setNumberOfLines(_ numberOfLines: Int) {
    titleLabel.config.numberOfLines(numberOfLines)
  }
  
  func setTextColor(_ textColor: UIColor) {
    titleLabel.textColor = textColor
  }
  
  func setLineHeight(_ lineHeight: CGFloat) {
    titleLabel.lineHeight = lineHeight
  }
  
  func setSeparatorPosition(_ separatorPosition: SeparatorPosition? = .bottom) {
		topSeparatorView.isHidden = !(separatorPosition?.contains(.top) ?? false)
    bottomSeparatorView.isHidden = !(separatorPosition?.contains(.bottom) ?? false)
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum ImageView {
    static let contentMode = UIView.ContentMode.scaleAspectFit
    static let backgroundColor = UIColor.clear
    static let side: CGFloat = 24
    static let bigSide: CGFloat = 60
    static let top: CGFloat = 18
		static let smallTop: CGFloat = 0
    static let bigTop: CGFloat = 4
    static let image = #imageLiteral(resourceName: "controlsArrow")
  }
  
  enum RightImageView {
    static let centerYOffset: CGFloat = 1
    static let bigRightOffset: CGFloat = 16
  }
  
  enum TitleLabel {
    static let left: CGFloat = 16
    static let centerYOffset: CGFloat = -2
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 14)
    static let lineHeight: CGFloat = 24
    static let textAlignment = NSTextAlignment.left
    static let numberOfLines = 1
  }
  
  enum UnderlineView {
    static let color = UIColor.color(r: 230, g: 230, b: 230)
    static let height: CGFloat = 1
  }
}
