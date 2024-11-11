//
//  OrderResultViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/28/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum ResultType {
  case success(Order)
  case error
}

protocol OrderResultViewControllerOutput: AnyObject {
  func didTapOnClose(resultVC: OrderResultViewController)
  func showProducts(from viewController: OrderResultViewController)
  func showBirthday(from viewController: OrderResultViewController)
}

class OrderResultViewController: LocalizableViewController, NavigationButtoned {

  // MARK: - Public variables
  var output: OrderResultViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = OrderResultView()
  private let type: ResultType
  
  // MARK: - Life cycle
  init(type: ResultType,
       shouldDisplayOnFullScreen: Bool) {
    self.type = type
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    transitionCoordinator?.animate(alongsideTransition: { _ in
      self.updateNavigationBarColor()
    })
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    disableSwipeToBack()
    updateNavigationBarColor()
    requestReviewIfNeeded()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    enableSwipeToBack()
  }
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    setupView()
    localize()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
  }
  
  private func setupNavigationBar() {
    navigationItem.title = nil
    setNavigationButton(#selector(didTapOnClose),
                        button: ButtonsFactory.blackCloseButtonForNavigationItem(),
                        side: .left)
  }
  
  private func setupSelfView() {
    selfView.addTargetOnGift(self, action: #selector(didTapOnGetGift), for: .touchUpInside)
    selfView.addTargetOnButton(self, action: #selector(didTapOnShowProducts), for: .touchUpInside)
    selfView.addTargetOnContact(self, action: #selector(didTapOnPhone), for: .touchUpInside)
    switch type {
    case .error:
      selfView.setGiftState(.none)
    case .success:
      if ProfileService.shared.user?.birthday == nil {
        selfView.setGiftState(.request)
      } else {
        selfView.setGiftState(.none)
      }
    }
  }
  
  private func updateNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .white)
  }

  // MARK: - Localization
  override func localize() {
    let localizator = Localizator.standard
    switch type {
    case .success(let order):
      selfView.setImage(getLocalizebleSuccessImage())
      selfView.setTitle(localizator.localizedString("Спасибо,\nзаказ принят!", order.number))
      selfView.setOrderNumberText(localizator.localizedString("Номер заказа"))
      selfView.setOrderNumber("\(order.number)")
      selfView.setSubtitle(localizator.localizedString("В ближайшее время с Вами свяжется менеджер и уточнит детали"))
      selfView.setContactTitle(localizator.localizedString("Если возникнут вопросы,\nзвоните по номеру"))
      selfView.setContactSubtitle(localizator.localizedString("звонки бесплатные"))
      selfView.setContactPhone(ContactsHelper().formattedPhone)
      selfView.setRequestGiftTitle(localizator.localizedString("Получить скидку 5%% ко дню рождения"))
      selfView.setReceivedGiftTitle(localizator.localizedString("Спасибо! Мы сохранили Вашу дату рождения. Возвращайтесь к нам за покупками в эти дни."))
      selfView.setButtonTitle(localizator.localizedString("Вернуться на главную").uppercased())
    case .error:
      selfView.setImage(#imageLiteral(resourceName: "errorResult"))
      selfView.setTitle(localizator.localizedString("Что-то пошло не так"))
      selfView.setSubtitle(localizator.localizedString("Возникла непредвиденная ошибка и заказ не был отправлен на обработку, проверьте данные и попробуйте снова."))
      selfView.setContactTitle(nil)
      selfView.setContactSubtitle(nil)
      selfView.setContactPhone(nil)
      selfView.setButtonTitle(localizator.localizedString("Вернуться на главную").uppercased())
    }
  }

  private func getLocalizebleSuccessImage() -> UIImage {
    switch LocalizationService.shared.language.code {
    case AppLanguage.ISO639Alpha2.ukrainian:
      return #imageLiteral(resourceName: "successResultUA")
    case AppLanguage.ISO639Alpha2.russian:
      return #imageLiteral(resourceName: "successResultRU")
    default:
      return #imageLiteral(resourceName: "successResultRU")
    }
  }
  
  // MARK: - Interface
  func showGiftReceived() {
    selfView.setGiftState(.received)
  }
  
  // MARK: - Actions
  private func requestReviewIfNeeded() {
    switch type {
    case .success:
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        AppStoreReviewService.shared.requestReviewIfNeeded()
      }
    case .error:
      break
    }
  }
  
  @objc
  private func didTapOnClose() {
    output?.didTapOnClose(resultVC: self)
  }
  
  @objc
  private func didTapOnGetGift() {
    output?.showBirthday(from: self)
  }
  
  @objc
  private func didTapOnShowProducts() {
    output?.showProducts(from: self)
  }
  
  @objc
  private func didTapOnPhone() {
    if let url = URL(string: "tel://" + ContactsHelper().formattedPhone.withoutWhitespaces()), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
}
