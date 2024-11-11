//
//  SearchNavBarView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 23.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class SearchNavBarView: InitView {
  
  // MARK: - Public variables
  weak var delegate: UISearchBarDelegate? {
    didSet {
      searchBar.delegate = delegate
    }
  }
  
  // MARK: - Private variables
  private let searchBar: UISearchBar = {
    let searchBar = BaseSearchBar()
    searchBar.placeholder = Localizator.standard.localizedString("Я хочу найти ...")
    searchBar.autocorrectionType = .no
    return searchBar
  }()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    setupView()
    setupSearch()
  }
  
  @discardableResult
  override func becomeFirstResponder() -> Bool {
    return searchBar.becomeFirstResponder()
  }
  
  // MARK: - Configure
  private func setupView() {
    backgroundColor = UIConstants.View.backgroundColor
    translatesAutoresizingMaskIntoConstraints = true
    autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  private func setupSearch() {
    addSubview(searchBar)
    searchBar.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Search.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.Search.leading)
      make.centerX.equalToSuperview()
      make.height.equalTo(UIConstants.Search.height)
      make.bottom.lessThanOrEqualTo(snp.bottom)
        .inset(UIConstants.Search.bottom)
    }
  }
  
  // MARK: - Interface
  func setPlaceholder(_ placeholder: String?) {
    searchBar.placeholder = placeholder
  }

  func setSearchText(_ text: String) {
    searchBar.text = text
  }
}

private enum UIConstants {
  enum View {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
  }
  
  enum Search {
    static let top: CGFloat = 16
    static let bottom: CGFloat = 24
    static let leading: CGFloat = 16
    static let height: CGFloat = 42
    
    static let cornerRadius: CGFloat = 21
  }
}
