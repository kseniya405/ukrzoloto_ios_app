//
//  SearchViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 23.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: LocalizableViewController {
  
  // MARK: - Public variables
  weak var searchBarDelegate: UISearchBarDelegate? {
    didSet {
      subview.delegate = searchBarDelegate
    }
  }
  
  // MARK: - Private variables
  private let subview = SearchNavBarView()

  init(searchText: String = "", shouldDisplayOnFullScreen: Bool) {
    subview.setSearchText(searchText)
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureSubview()
  }
  
  override func viewFirstAppear(_ animated: Bool) {
    super.viewFirstAppear(animated)
    subview.becomeFirstResponder()
  }

  // MARK: - Configuration
  private func configureSubview() {
    guard !view.subviews.contains(subview) else { return }
    view.addSubview(subview)
    subview.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(UIConstants.Subview.defaultHeight)
    }
  }
  
  // MARK: - Interface
  func setSearchPlaceholder(_ placeholder: String?) {
    subview.setPlaceholder(placeholder)
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum Subview {
    static let defaultHeight: CGFloat = 82
  }
}
