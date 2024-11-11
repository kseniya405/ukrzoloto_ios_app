//
//  DiscountViewController.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 02.11.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol DiscountViewControllerOutput: AnyObject {
  func showDiscountAgreement(from viewController: DiscountViewController)
}

class DiscountViewController: BlurAlertController {
  
  // MARK: - Public variables
  weak var output: DiscountViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView: DiscountView
  
  // MARK: - Life cycle
  convenience init() {
    let view = DiscountView()
    self.init(blurAlertView: BlurAlertView(contentView: view))
  }

  private override init(blurAlertView: BlurAlertView) {
    guard let contentView = blurAlertView.contentView as? DiscountView else {
      fatalError("Cannot initialize DiscountViewController")
    }
    selfView = contentView
    super.init(blurAlertView: blurAlertView)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initConfigure()
  }
  
  private func initConfigure() {
    configureSelfView()
    addObservers()
    updateView()
    logEvent()
  }
  
  private func configureSelfView() {
    selfView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.height)
    }
    selfView.addTargetOnButton(self,
                               action: #selector(didTapOnAgreement),
                               for: .touchUpInside)
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(userWasUpdated),
                                           name: .userWasUpdated,
                                           object: nil)
  }
  
  // MARK: - Private
  private func updateView() {
    guard let user = ProfileService.shared.user else { return }
    selfView.setButtonTitle(Localizator.standard.localizedString("Условия дисконтной программы"))
    if let cardNumber = user.discountCard?.cardNumber {
      selfView.setImage(Utils.shared.generateBarcode(from: cardNumber))
      guard user.hasDiscounts else {
        selfView.setTitle(Localizator.standard.localizedString("У Вас пока нет скидки. Предъявите код продавцу, чтобы сумма Вашей покупки была засчитана в накопления по карте"))
        return
      }
      selfView.setTitle(StringComposer.shared.getDiscountString(goldDiscount: user.goldDiscount))
    } else {
      selfView.setImage(nil)
      selfView.setTitle(Localizator.standard.localizedString("Дисконтная карта будет доступна только после первой покупки"))
    }
  }
    
  private func logEvent() {
    EventService.shared.logOpenDiscountCart()
  }
  
  @objc
  private func didTapOnAgreement() {
    output?.showDiscountAgreement(from: self)
  }
  
  @objc
  private func userWasUpdated() {
    updateView()
  }
}

// MARK: - UIConstants
private enum UIConstants {
  static let height = Constants.Screen.screenHeight * 0.88
}
