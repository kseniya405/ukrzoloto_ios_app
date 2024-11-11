//
//  DeliveryInfoView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 31.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

typealias DeliveryInfoPoint = (image: UIImage, text: NSAttributedString)
typealias DeliveryMainInfo = (title: String, points: [DeliveryInfoPoint], hint: String)
typealias BlockContent = (title: String, points: [String])
typealias HotLine = (title: String, number: String)

typealias DeliveryContent = (main: DeliveryMainInfo, blocks: [BlockContent], hotLine: HotLine, support: ImageTitleImagesViewModel)

class DeliveryInfoView: InitView {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  private let mainInfoView = MainInfoView()
  private let packBlockView = BlockView()
  private let hotLineView = HotLineView()
  private let supportView = SupportSocialView()
  
  private var bottomView = UIView()
  private var createdViews = [UIView]()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureMainInfoview()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    layer.cornerRadius = UIConstants.SelfView.radius
  }
  
  private func configureMainInfoview() {
    addSubview(mainInfoView)
    mainInfoView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.MainInfoView.top)
      make.leading.trailing.equalToSuperview()
    }
    
    bottomView = mainInfoView
  }
  
  // MARK: - Interface
  func setBlockContent(_ content: DeliveryContent) {
    createdViews.forEach { $0.removeFromSuperview() }
    bottomView = mainInfoView
    
    mainInfoView.setContent(content.main)
    for index in 0..<content.blocks.count {
      createBlockView(topOffset: index == 0 ?
        UIConstants.Block.topFromMain :
        UIConstants.Block.spaceBetween,
                      content: content.blocks[index])
    }
    
    configureHotLine(content: content.hotLine)
    configureSupportView(content: content.support)
  }
  
  func addHotLineTarget(_ target: Any?, action: Selector) {
    hotLineView.addHotLineTarget(target, action: action)
  }
  
  func addSupportSocialDelegate(_ delegate: SupportSocialViewDelegate) {
    supportView.delegate = delegate
  }
  
  // MARK: - Private methods
  private func createBlockView(topOffset: CGFloat, content: BlockContent) {
    let view = BlockView()
    addSubview(view)
    view.snp.makeConstraints { make in
      make.top.equalTo(bottomView.snp.bottom)
        .offset(topOffset)
      make.leading.trailing.equalTo(mainInfoView)
    }
    view.setContent(content)
    bottomView = view
    createdViews.append(view)
  }
  
  private func configureHotLine(content: HotLine) {
    addSubview(hotLineView)
    hotLineView.snp.makeConstraints { make in
      make.top.equalTo(bottomView.snp.bottom)
        .offset(UIConstants.HotLine.top)
      make.leading.trailing.equalTo(mainInfoView)
    }
    hotLineView.setContent(content)
  }
  
  private func configureSupportView(content: ImageTitleImagesViewModel) {
    addSubview(supportView)
    supportView.snp.makeConstraints { make in
      make.top.equalTo(hotLineView.snp.bottom)
      .offset(UIConstants.Support.top)
      make.leading.trailing.equalTo(mainInfoView)
      make.bottom.equalToSuperview()
        .inset(UIConstants.Support.bottom)
    }
    supportView.textColor = UIConstants.Support.textColor
    supportView.titleFont = UIConstants.Support.font
    
    supportView.configure(viewModel: content)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 246, g: 246, b: 246)
    static let radius: CGFloat = 16
  }
  
  enum MainInfoView {
    static let top: CGFloat = 32
  }
  
  enum Block {
    static let topFromMain: CGFloat = 34
    static let spaceBetween: CGFloat = 32
  }
  
  enum HotLine {
    static let top: CGFloat = 32
  }
  
  enum Support {
    static let textColor = UIColor.black.withAlphaComponent(0.7)
    static let font = UIFont.regularAppFont(of: 14)
    
    static let top: CGFloat = 24
    static let bottom: CGFloat = 40
  }
  
}
