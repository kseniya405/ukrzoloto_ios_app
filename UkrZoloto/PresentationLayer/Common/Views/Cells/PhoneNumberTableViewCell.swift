//
//  PhoneNumberTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/4/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol PhoneNumberTableViewCellDelegate: AnyObject {
  func didTapOnPhone()
}

class PhoneNumberTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: PhoneNumberTableViewCellDelegate?
  
  // MARK: - Private variables
  private let phoneImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(UIConstants.Title.textColor,
                         for: .normal)
    button.titleLabel?.font = UIConstants.Title.font
    button.titleLabel?.numberOfLines = UIConstants.Title.numberOfLines
    button.titleLabel?.textAlignment = .left
    return button
  }()
  
  private let subtitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Subtitle.lineHeight
    label.config
      .font(UIConstants.Subtitle.font)
      .textColor(UIConstants.Subtitle.textColor)
      .numberOfLines(UIConstants.Subtitle.numberOfLines)
    return label
  }()
  
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
    configureImageView()
    configureTitleButton()
    configureSubtitleLabel()
  }
  
  private func configureImageView() {
    contentView.addSubview(phoneImageView)
    phoneImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
        .offset(UIConstants.ImageView.leading)
      make.width.height.equalTo(UIConstants.ImageView.side)
    }
  }
  
  private func configureTitleButton() {
    contentView.addSubview(titleButton)
    titleButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
      make.leading.equalTo(phoneImageView.snp.trailing)
        .offset(UIConstants.Title.leading)
      make.trailing.lessThanOrEqualToSuperview()
        .inset(UIConstants.Title.trailing)
      make.centerY.equalTo(phoneImageView)
    }
    titleButton.addTarget(self,
                          action: #selector(didTapOnPhone),
                          for: .touchUpInside)
  }
  
  private func configureSubtitleLabel() {
    contentView.addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleButton.snp.bottom)
      make.leading.trailing.equalTo(titleButton)
      make.bottom.equalToSuperview()
        .inset(UIConstants.Subtitle.bottom)
    }
  }
  
  // MARK: - Interface
  func configure(viewModel: ImageTitleSubtitleViewModel) {
    titleButton.setTitle(viewModel.title,
                         for: .normal)
    subtitleLabel.text = viewModel.subtitle
    
    guard let imageViewModel = viewModel.image else { return }
    phoneImageView.setImage(from: imageViewModel)
  }
  
  func updateTopOffset() {
    titleButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
    }
  }
  
  func updateBottomOffset() {
    subtitleLabel.snp.updateConstraints { make in
      make.bottom.equalToSuperview()
        .inset(UIConstants.Subtitle.bottom)
    }
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnPhone() {
    delegate?.didTapOnPhone()
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum ImageView {
    static let side: CGFloat = 24
    static let leading: CGFloat = 24
  }
  enum Title {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let numberOfLines = 0
    static let lineHeight: CGFloat = 28
    static let font = UIFont.boldAppFont(of: 24)
    
    static let leading: CGFloat = 24
    static let trailing: CGFloat = 24
    static let top: CGFloat = 34
  }
  enum Subtitle {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75).withAlphaComponent(0.6)
    static let numberOfLines = 0
    static let lineHeight: CGFloat = 18
    static let font = UIFont.regularAppFont(of: 13)
    static let bottom: CGFloat = 18
  }
}
