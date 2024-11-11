//
//  ClaspView.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 04.04.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import Foundation

class ClaspView: InitView {
  
  public func setupView() {
    // Setting width to fill (343px)
    let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 343)
    self.addConstraint(widthConstraint)
    
    // Setting padding (8px 16px 8px 16px)
    self.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    // Setting border radius (16px)
    self.layer.cornerRadius = 16
    
    self.backgroundColor = UIColor(hex: "#F6F6F6")
    
    // Create horizontal stack view
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    
    // Add image view
    let imageView = UIImageView(image: UIImage(named: "claspWarning"))
    imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    imageView.contentMode = .center
    imageView.tintColor = UIColor(hex: "616665")
    stackView.addArrangedSubview(imageView)
    
    // Add label
    let label = UILabel()
    label.text = Localizator.standard.localizedString("Производитель оставляет за собой право на\nизменение типа застежки")
    label.font = UIFont.regularAppFont(of: 12)
    label.textColor = UIColor(hex: "616665") // Change color as needed
    label.numberOfLines = 2 // Allow multiline
    stackView.addArrangedSubview(label)
    
    // Setting height to hug (48px)
    let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 54)
    self.addConstraint(heightConstraint)
    
    // Add stack view to custom view
    addSubview(stackView)
    
    // Layout constraints for stack view
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
    ])
  }
}
