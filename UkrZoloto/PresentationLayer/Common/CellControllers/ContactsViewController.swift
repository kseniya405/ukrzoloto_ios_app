//
//  ContactsViewController.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 12.09.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import UIKit
import AUIKit

protocol ContactsCellControllerDelegate: AnyObject {
  func didTapOnImage(with index: Int)
}

class ContactsViewController: AUIDefaultViewController {
  // MARK: - Public variables
  weak var delegate: ContactsCellControllerDelegate?

  var supportView: SupportView? {
    set { view = newValue }
    get { return view as? SupportView }
  }

  private(set) var info: [Social] = []

  // MARK: - Configure
  override func setupView() {
    super.setupView()

    updateInfo()

    supportView?.delegate = self
    supportView?.addHotLineTarget(self, action: #selector(makeCall))
  }

  // MARK: - Interface
  func setInfo(_ info: [Social]) {
    self.info = info

    updateInfo()
  }

  // MARK: - Actions
  private func updateInfo() {
    supportView?.updateViewStateWith(info)
  }

  @objc
  private func makeCall() {
    if let url = URL(string: "tel://" + ContactsHelper().formattedPhone.withoutWhitespaces()), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
}

// MARK: - ContactsCellControllerDelegate
extension ContactsViewController: SupportSocialViewDelegate {
  func didTapOnImage(with index: Int) {
    delegate?.didTapOnImage(with: index)
  }
}
