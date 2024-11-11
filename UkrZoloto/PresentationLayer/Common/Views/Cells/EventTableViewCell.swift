//
//  EventTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol EventTableViewCellOutput: AnyObject {
  func didTapOnClean(from event: UkrZolotoInternalEvent)
}

class EventTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: EventTableViewCellOutput?
  
  // MARK: - Private variables
  private let textField = ImageTextField()
  private var eventData: EventData?
  
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
    configureTextField()
  }
  
  private func configureTextField() {
    contentView.addSubview(textField)
    textField.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.TextField.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.TextField.insets)
      make.height.equalTo(UIConstants.TextField.height)
      make.bottom.equalToSuperview()
    }
    textField.setUnderlineColor(UIConstants.TextField.underlineColor)
    textField.font = UIConstants.TextField.font
    textField.textColor = UIConstants.TextField.textColor
  }
  
  override func resignFirstResponder() -> Bool {
    return textField.resignFirstResponder()
  }
  
  // MARK: - Interface
  func configure(eventData: EventData) {
    self.eventData = eventData
    let dateFormatter = DateFormattersFactory.eventDateFormatter()
    textField.text = eventData.event.title
    textField.setHelper(dateFormatter.string(from: eventData.event.date))
    textField.setImage(eventData.image)
    
    textField.buttonAction = { [weak self] in
      guard let self = self else { return }
      self.delegate?.didTapOnClean(from: eventData.event)
    }
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum TextField {
    static let insets: CGFloat = 24
    static let top: CGFloat = 5
    static let height: CGFloat = 50
    
    static let underlineColor = UIColor.color(r: 230, g: 230, b: 230)
    static let font = UIFont.boldAppFont(of: 16)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
  }
}
