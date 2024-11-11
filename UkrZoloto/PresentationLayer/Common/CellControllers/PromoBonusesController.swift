//
//  PromoBonusesController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 25.11.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol PromoBonusesControllerDelegate: AnyObject {
  func didTapOnWriteOff(from controller: PromoBonusesController)
  func didTapOnCancelButton(from controller: PromoBonusesController)
}

class PromoBonusesController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: PromoBonusesControllerDelegate?
  
  var promoBonusesView: PromoBonusesView? {
    get { return view as? PromoBonusesView }
    set { view = newValue }
  }
  
  var promoBonusesViewModel: PromoBonusesViewModel? {
    didSet { didSetViewModel() }
  }

  // MARK: - Actions
  private func didSetViewModel() {
    guard let promoBonusesViewModel = promoBonusesViewModel,
      let promoBonusesView = promoBonusesView else { return }
    promoBonusesView.configureInitState(viewModel: promoBonusesViewModel)
    promoBonusesView.writeOffButton.addTarget(
      self, action: #selector(didTapOnWriteOff), for: .touchUpInside)
    promoBonusesView.cancelButton.addTarget(
      self, action: #selector(didTapOnCancelButton), for: .touchUpInside)
  }
  
  override func setupView() {
    super.setupView()
    didSetViewModel()
  }
  
  // MARK: - Private methods
  @objc
  private func didTapOnWriteOff() {
    delegate?.didTapOnWriteOff(from: self)
  }
  
  @objc
  private func didTapOnCancelButton() {
    delegate?.didTapOnCancelButton(from: self)
  }
}
