//
//  GuestViewController.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 03.11.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol GuestViewControllerOutput: AnyObject {
  func didSelectLogin(from viewController: GuestViewController)
  func didTapOnClose(from viewController: GuestViewController)
}

class GuestViewController: LocalizableViewController, NavigationButtoned {

  // MARK: - Public variables
  var output: GuestViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = GuestView()
    
  // MARK: - Life cycle
  override func loadView() {
    view = selfView
  }
  
  // MARK: - Setup
  override func initConfigure() {
    setupView()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
    localizeLabels()
  }
  
  private func setupNavigationBar() {
    addNavigationButton(#selector(didTapOnClose),
                        button: ButtonsFactory.closeButtonForNavigationItem(),
                        side: .left)
  }
  
  private func setupSelfView() {
    selfView.addTargetOnLoginButton(self,
                                    action: #selector(login),
                                    for: .touchUpInside)
  }
  
  private func localizeLabels() {
    let title = Localizator.standard.localizedString("Вы не авторизированы")
    let subtitle = Localizator.standard.localizedString("Войдите или зарегистрируйтесь, чтобы быстро оформлять заказы и получать данные о Вашей персональной скидке")
    let loginButtonTitle = Localizator.standard.localizedString("Войти").uppercased()
    selfView.setImage(#imageLiteral(resourceName: "userType"))
    selfView.setTitle(title)
    selfView.setSubtitle(subtitle)
    selfView.setLoginButtonTitle(loginButtonTitle)
    selfView.setGuestButtonTitle(nil)
  }
  
  override func localize() {
    localizeLabels()
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnClose() {
    output?.didTapOnClose(from: self)
  }
  
  @objc
  private func login() {
    output?.didSelectLogin(from: self)
  }
}
