//
//  CardImageView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/15/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class CardImageView: UIView {
  
  // MARK: - Public variables
  var hasShadow = true
  
  // MARK: - Private variables
  private let imageView = UIImageView()
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateLayers(with: bounds)
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureImageView()
  }
  
  private func configureImageView() {
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = UIConstants.ImageView.backgroundColor
    imageView.layer.cornerRadius = UIConstants.ImageView.cornerRadius
    imageView.clipsToBounds = true
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func updateLayers(with rect: CGRect) {
    layer.cornerRadius = UIConstants.SelfView.cornerRadius
    setupShadow()
  }
  
  func setupShadow() {
    guard hasShadow else {
      layer.shadowPath = nil
      return
    }
    layer.shadowOpacity = UIConstants.SelfView.shadowOpacity
    let shadowRadius = UIConstants.SelfView.shadowRadius
    let shadowRect = CGRect(origin: CGPoint(x: bounds.origin.x - shadowRadius / 2,
                                            y: bounds.origin.y + shadowRadius),
                            size: CGSize(width: bounds.width + shadowRadius,
                                         height: bounds.height))
    layer.shadowPath = UIBezierPath(roundedRect: shadowRect,
                                    cornerRadius: UIConstants.SelfView.cornerRadius).cgPath
    layer.shadowColor = UIConstants.SelfView.shadowColor.cgColor
    layer.shadowOffset = .zero
    layer.shadowRadius = shadowRadius / 2
  }
  
  // MARK: - Interface
  func setImage(_ imageViewModel: ImageViewModel?) {
    if let imageViewModel = imageViewModel {
      imageView.setImage(from: imageViewModel)
    } else {
      imageView.image = nil
    }
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
    static let cornerRadius: CGFloat = 16
    static let shadowRadius: CGFloat = 10.0
    static let shadowOpacity: Float = 0.2
    
    static let shadowColor = UIColor.color(r: 157, g: 164, b: 183)
  }
  enum ImageView {
    static let backgroundColor = UIColor.clear
    static let cornerRadius: CGFloat = 16
  }
}
