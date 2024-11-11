//
//  LockedDateTableViewCell.swift
//  UkrZoloto
//
//  Created by Mykola on 11.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

class LockedDateTableViewCell: UITableViewCell, Reusable {
  
  private let titleLabel: UILabel = {
    
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
    label.text = Localizator.standard.localizedString("Дата рождения")
    
    return label
  }()
  
  private let dateLabel: UILabel = {
     
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Date.font)
      .textColor(UIConstants.Date.textColor)
        
    return label
  }()
  
  private let line: UIView = {
    
    let view = UIView()
    view.backgroundColor = UIConstants.Line.color
    return view
  }()
  
  private let infoIcon: UIImageView = {
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIConstants.infoIcon
    
    return imageView
  }()
  
  // MARK: - Life cycle
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
    
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.contentPadding)
      make.top.equalToSuperview()
    }
    
    contentView.addSubview(dateLabel)
    dateLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.contentPadding)
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.Date.topOffset)
    }
    
    contentView.addSubview(line)
    line.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.contentPadding)
      make.trailing.equalToSuperview().offset(-UIConstants.contentPadding)
      make.height.equalTo(UIConstants.Line.height)
      make.top.equalTo(dateLabel.snp.bottom).offset(UIConstants.Line.topOffset)
    }
    
    contentView.addSubview(infoIcon)
    infoIcon.snp.makeConstraints { make in
      make.width.height.equalTo(24.0)
      make.trailing.equalToSuperview().offset(-UIConstants.contentPadding)
      make.bottom.equalTo(line.snp.top).offset(-10.0)
    }
  }
  
  // MARK: - Interface
  func configure(profileData: ProfileData) {
    dateLabel.text = profileData.vm.text
  }
  
  func setIcon(highlighted: Bool) {
    infoIcon.image = highlighted ? UIConstants.infoIconHighlighted : UIConstants.infoIcon
  }
  
  func infoIconConvertedRect() -> CGRect {
    return self.convert(infoIcon.frame, to: UIApplication.shared.windows.filter {$0.isKeyWindow}.first)
  }
}

fileprivate enum UIConstants {
  
  enum Title {
    static let font = UIFont.semiBoldAppFont(of: 13)
    static let textColor = UIColor.black.withAlphaComponent(0.45)
    static let lineHeight: CGFloat = 18.0
  }
  
  enum Date {
    static let font = UIFont.boldAppFont(of: 16.0)
    static let lineHeight: CGFloat = 24.0
    static let textColor = UIColor(named: "textDarkGreen")!.withAlphaComponent(0.4)
    static let topOffset: CGFloat = 2.0
  }
  
  enum Line {
    static let color = UIColor(named: "card")!
    static let height: CGFloat = 1.0
    static let topOffset: CGFloat = 8.0
  }
  
  static let infoIcon = UIImage(named: "info_icon")
  static let infoIconHighlighted = UIImage(named: "info_icon_highlighted")
  static let contentPadding: CGFloat = 24.0
}
