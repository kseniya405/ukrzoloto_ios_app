//
//  MainNavBarView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 11.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class MainNavBarView: InitView {
  
  // MARK: - Public variables
  var isElemetsHidden: Bool = false
  
  // MARK: - Private variables
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIConstants.Image.image
    return imageView
  }()
  
  private let searchBar: BaseSearchBar = {
    let searchBar = BaseSearchBar()
    searchBar.placeholder = "Я хочу найти ...".localized()
    return searchBar
  }()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    setupView()
    setupImageView()
    setupSearch()
  }
  
  // MARK: - Configure
  private func setupView() {
    backgroundColor = UIConstants.View.backgroundColor
    translatesAutoresizingMaskIntoConstraints = true
    autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  private func setupImageView() {
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Image.top)
      make.height.equalTo(UIConstants.Image.height)
      make.width.equalTo(UIConstants.Image.width)
      make.centerX.equalToSuperview()
    }
  }
  
  private func setupSearch() {
    addSubview(searchBar)
    searchBar.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom)
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
  func addSearchBarDelegate(_ delegate: UISearchBarDelegate) {
    searchBar.delegate = delegate
  }
  
}

// MARK: - AnimationViewInput
extension MainNavBarView: AnimationViewInput {
  func hideElements() {
    isElemetsHidden = true
    
    imageView.isHidden = true
    searchBar.isHidden = true
  }
  
  func showElements() {
    isElemetsHidden = false
    
    imageView.isHidden = false
    searchBar.isHidden = false
  }
  
}

private enum UIConstants {
  enum View {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
  }
  
  enum Image {
    static let image = #imageLiteral(resourceName: "component3")
    static private let windowHeight: CGFloat = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?
      .windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    static let top: CGFloat = height + 9
    static let width: CGFloat = 153
    static let height: CGFloat = 63
  }
  
  enum Search {
    static let top: CGFloat = 17
    static let bottom: CGFloat = 27
    static let leading: CGFloat = 16
    static let height: CGFloat = 42
    static let cornerRadius: CGFloat = 21
  }
}
