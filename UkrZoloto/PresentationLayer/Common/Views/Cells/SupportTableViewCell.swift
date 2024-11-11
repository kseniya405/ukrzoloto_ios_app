//
//  SupportTableViewCell.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 23.09.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import UIKit

class SupportTableViewCell: UITableViewCell, Reusable {
  let supportView = SupportView()

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

    self.contentView.addSubview(supportView)

    supportView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
  }
}
