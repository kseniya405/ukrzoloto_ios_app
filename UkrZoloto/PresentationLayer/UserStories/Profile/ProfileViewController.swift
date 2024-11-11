//
//  ProfileViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/3/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

private enum ProfileInfoItem {
  case mainInfoWithDiscount(discountVMs: [DiscountViewModel], bonusesVMs: [BonusesViewModel], buttonTitle: String)
  case mainInfo(bonusesVMs: [BonusesViewModel], buttonTitle: String)
  case mainGuest(textValues: GuestViewTextValues)
  case profileInfo(viewModel: ImageTitleImageViewModel)
  case favoritesProducts(viewModel: ImageTitleImageViewModel)
  case info(ImageTitleImageViewModel, type: InfoType)
  case phone(ImageTitleSubtitleViewModel)
  case time(ImageTitleSubtitleViewModel)
//  case support(ImageTitleImagesViewModel)
  case space(height: CGFloat, backgroundColor: UIColor)
  case language(title: String, viewModels: [TitleViewModel], selectedVMs: TitleViewModel)
  case deleteAccount(ImageTitleImageViewModel)
  case support
}

private enum InfoType {
  case refund
  case delivery
  case agreement
  case deleteAccountAgreement
  case offer
  case discount
}

protocol ProfileViewControllerOutput: AnyObject {
  func didTapOnBack(from: ProfileViewController)
  func didTapOnSignIn(from vc: ProfileViewController)
  func didTapOnShowProfileData(from: ProfileViewController)
  func didTapOnShowFavorites(from vc: ProfileViewController)
  func showDiscountAgreement(from viewController: ProfileViewController)
  func showSite(from viewController: ProfileViewController)
  func showAgreement(from vc: ProfileViewController)
  func showDeleteAccountAgreement(from vc: ProfileViewController)
  func showDeliveryInfo(from vc: ProfileViewController)
  func showOffer(from vc: ProfileViewController)
  func showRefundInfo(from vc: ProfileViewController)
  func showDiscountCard()
}

class ProfileViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: ProfileViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = ProfileView()
  
  private var socials = ContactsHelper().socials
  private var dataSource = [ProfileInfoItem]()
  
  // MARK: - Life cycle
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
    updateNavigationBarColor()
  }
  
  // MARK: - Setup
  override func initConfigure() {
    super.initConfigure()
    setupView()
    setupBusinessChatButton()
    addObservers()
    updateWithUser()
  }
  
  private func setupView() {
    edgesForExtendedLayout = [.top, .bottom]
    setupSelfView()
  }
  
  private func setupSelfView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
    selfView.getTableView().contentInsetAdjustmentBehavior = .never
    
    selfView.getRefreshControl().addTarget(
      self, action: #selector(refresh), for: .valueChanged)
  }

  private func setupBusinessChatButton() {
      let appleChat = ContactsHelper().getSocialModel(socialType: .businessChat)
      socials.insert(appleChat, at: socials.startIndex)
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(userWasUpdated),
      name: .userWasUpdated, object: nil)
    NotificationCenter.default.addObserver(
      self, selector: #selector(logOutProfile),
      name: .logOutProfile, object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(updateContacts),
                                           name: Notification.Name.contactsUpdated,
                                           object: nil)
  }
  
  private func updateNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
  // MARK: - Private methods
  private func setupDataSource() {
    setLanguageInfo()
    if ProfileService.shared.user != nil {
      let profileViewModel = ImageTitleImageViewModel(
        leftImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "profile")),
        title: Localizator.standard.localizedString("Мои данные"),
        rightImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "controlsArrow")))
      dataSource.append(.profileInfo(viewModel: profileViewModel))
    }
    setInfoDataSource()
    
    dataSource.append(.space(height: 90, backgroundColor: UIConstants.spaceBackgroundColor))
    
    selfView.getTableView().reloadData()
  }
  
  private func setInfoDataSource() {
    if ProfileService.shared.user != nil {
      let favoritesVM = ImageTitleImageViewModel(
        leftImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "iconsFavoriteBlack")),
        title: Localizator.standard.localizedString("Избранное"),
        rightImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "controlsArrow")))
      dataSource.append(.favoritesProducts(viewModel: favoritesVM))
    }

    let refundVM = ImageTitleImageViewModel(
      leftImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "returnProfile")),
      title: Localizator.standard.localizedString("Возврат и обмен"),
      rightImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "controlsArrow")))
    dataSource.append(.info(refundVM, type: .refund))
    
    let deliveryVM = ImageTitleImageViewModel(
      leftImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "deliveryProfile")),
      title: Localizator.standard.localizedString("Доставка и оплата"),
      rightImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "controlsArrow")))
    dataSource.append(.info(deliveryVM, type: .delivery))
    
    let agreementVM = ImageTitleImageViewModel(
      leftImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "documentationProfile")),
      title: Localizator.standard.localizedString("Пользовательское соглашение"),
      rightImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "controlsArrow")))
    dataSource.append(.info(agreementVM, type: .agreement))
    
    let offerVM = ImageTitleImageViewModel(
      leftImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "publicOfferProfile")),
      title: Localizator.standard.localizedString("Публичная оферта"),
      rightImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "controlsArrow")))
    dataSource.append(.info(offerVM, type: .offer))
    
    let discountVM = ImageTitleImageViewModel(
      leftImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "discountProfile")),
      title: Localizator.standard.localizedString("Дисконтная программа"),
      rightImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "controlsArrow")))
    dataSource.append(.info(discountVM, type: .discount))

    let deleteAccountAgreementVM = ImageTitleImageViewModel(
      leftImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "documentationProfile")),
      title: Localizator.standard.localizedString("Политика удаления аккаунта"),
      rightImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "controlsArrow")))
    dataSource.append(.info(deleteAccountAgreementVM, type: .deleteAccountAgreement))
    
    dataSource.append(.space(height: 32, backgroundColor: UIConstants.spaceBackgroundColor))

    if ProfileService.shared.user != nil {
      let deleteAccountVM = ImageTitleImageViewModel(
        leftImageViewModel: nil,
        title: Localizator.standard.localizedString("Удалить аккаунт"),
        rightImageViewModel: ImageViewModel.image(#imageLiteral(resourceName: "controlsArrow")))
      dataSource.append(.deleteAccount(deleteAccountVM))

      dataSource.append(.space(height: 32, backgroundColor: UIConstants.spaceBackgroundColor))
    }
//    
//    let phoneVM = ImageTitleSubtitleViewModel(
//      title: ContactsHelper().formattedPhone,
//      subtitle: Localizator.standard.localizedString("бесплатно по Украине"),
//      image: ImageViewModel.image(#imageLiteral(resourceName: "iconsInfo")))
//    dataSource.append(.phone(phoneVM))
//    dataSource.append(.space(height: 28, backgroundColor: UIConstants.spaceBackgroundColor))
//    
//    let workDaysVM =
//      ImageTitleSubtitleViewModel(
//        title: Localizator.standard.localizedString("Пн-Пт"),
//        subtitle: Localizator.standard.localizedString(ContactsHelper().workdayHrs),
//        image: ImageViewModel.image(#imageLiteral(resourceName: "iconsWorkingTime")))
//    dataSource.append(.time(workDaysVM))
//    dataSource.append(.space(height: 10, backgroundColor: UIConstants.spaceBackgroundColor))
//    
//    let weekendVM = ImageTitleSubtitleViewModel(
//      title: Localizator.standard.localizedString("Сб-Вс"),
//      subtitle: Localizator.standard.localizedString(ContactsHelper().weekendHrs),
//      image: nil)
//    dataSource.append(.time(weekendVM))

    dataSource.append(.support)
    dataSource.append(.space(height: 28, backgroundColor: UIConstants.spaceBackgroundColor))
//    dataSource.append(.support(setSupportContent()))
  }
  
//  private func setSupportContent() -> ImageTitleImagesViewModel {
//    let viewModel = ImageTitleImagesViewModel(
//      title: Localizator.standard.localizedString("Поддержка"),
//      image: ImageViewModel.image(#imageLiteral(resourceName: "iconsSupport")),
//      images: socials.compactMap { ImageViewModel.image($0.image) })
//
//    return viewModel
//  }
  
  private func updateProfile() {
    guard ProfileService.shared.user != nil else {
      self.selfView.getRefreshControl().endRefreshing()
      return
    }
    
    ProfileService.shared.getProfile { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        self.selfView.getRefreshControl().endRefreshing()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success:
          self.updateWithUser()
        }
      }
    }
  }
  
  @objc private func updateContacts() {
    socials = ContactsHelper().socials
    setupBusinessChatButton()
    
    updateWithUser()
  }
  
  private func updateWithUser() {
    dataSource.removeAll()
    if let user = ProfileService.shared.user {
      navigationItem.title = Localizator.standard.localizedString("Профиль клиента")
      setNavigationButton(#selector(didTapOnLogout),
                          button: ButtonsFactory.logoutButtonForNavItem(),
                          side: .right)
      setNavigationButton(#selector(didTapOnDiscountCard),
                          button: ButtonsFactory.discountCardButtonForNavItem(),
                          side: .left)
      var bonusesViewModels = [
        BonusesViewModel(bonuses: "\(user.bonuses)",
                         title: Localizator.standard.localizedString("грн"),
                         color: UIConstants.goldColor,
                         bonusesTitle: Localizator.standard.localizedString("Персональные Бонусы"))]
      let promoBonusVM = BonusesViewModel(bonuses: "\(user.marketingBonus)",
                                          title: Localizator.standard.localizedString("грн"),
                                          color: UIConstants.goldColor,
                                          bonusesTitle: Localizator.standard.localizedString("Акционные Бонусы"))
      bonusesViewModels.append(promoBonusVM)
      if user.hasDiscounts {
        var viewModels = [DiscountViewModel]()
        if user.goldDiscount != 0 {
          let viewModel = DiscountViewModel(discount: "\(user.goldDiscount)",
                                            title: Localizator.standard.localizedString("Персональная скидка"),
                                            color: UIConstants.goldColor)
          viewModels.append(viewModel)
        }
        dataSource.append(.mainInfoWithDiscount(
                            discountVMs: viewModels,
                            bonusesVMs: bonusesViewModels,
                            buttonTitle:  Localizator.standard.localizedString("Читать условия")))
        
      } else {
        dataSource.append(.mainInfo(
                            bonusesVMs: bonusesViewModels,
                            buttonTitle:  Localizator.standard.localizedString("Читать условия")))
      }
    } else {
      navigationItem.title = nil
      navigationItem.rightBarButtonItem = nil
      let textValues = GuestViewTextValues(title: Localizator.standard.localizedString("Сохраните Ваши личные данные"),
                                           subtitle: Localizator.standard.localizedString("Они будут доступны в профиле и подтянутся при оформлении заказа"),
                                           clickedTitle: nil,
                                           buttonTitle: Localizator.standard.localizedString("войти / регистрироваться").uppercased())
      dataSource.append(.mainGuest(
                          textValues: textValues))
    }
    setupDataSource()
  }
  
  // MARK: - Localization
  override func localize() {
    updateWithUser()
  }
  
  private func setLanguageInfo()  {
    let languageVMs = AppLanguage.list.map { TitleViewModel(id: $0.code,
                                                            title: $0.nativeName) }
    guard let selectedVM = languageVMs.first(where: { $0.id == LocalizationService.shared.language.code }) else { return }
    dataSource.append(.language(title: Localizator.standard.localizedString("Язык"),
                                viewModels: languageVMs,
                                selectedVMs: selectedVM))
  }
  
  // MARK: - Actions
  private func didTapOnDeleteAccount() {
    let okAlert = AlertAction(style: .unfilledGreen,
                              title: Localizator.standard.localizedString("Удалить"),
                              isEmphasized: true) { [weak self] in
      self?.dismiss(animated: true)

      self?.deleteAccount()
    }
    let cancelAlert = AlertAction(style: .filled,
                                  title: Localizator.standard.localizedString("Отменить"),
                                  isEmphasized: false) { [weak self] in
      self?.dismiss(animated: true)
    }
    showAlert(title: Localizator.standard.localizedString("Удаление аккаунта"),
              subtitle: Localizator.standard.localizedString("Вы подтверждаете удаление аккаунта? Будет удалена история заказов, сертификаты и бонусы"),
              actions: [okAlert, cancelAlert])
  }

  private func deleteAccount() {
    HUD.showProgress()

    ProfileService.shared.deleteAccount { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }

        HUD.hide()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success:
          self.accountDeleteConfirmation()
        }
      }
    }
  }

  private func accountDeleteConfirmation() {
    let okAlert = AlertAction(style: .unfilledGreen,
                              title: Localizator.standard.localizedString("Закрыть"),
                              isEmphasized: true) { [weak self] in
      self?.dismiss(animated: true)
    }
    showAlert(title: Localizator.standard.localizedString("Заявка принята"),
              subtitle: Localizator.standard.localizedString("Заявка на удаление аккаунта принята, аккаунт будет удален в ближайшее время"),
              actions: [okAlert])
  }

  private func logout() {
    HUD.showProgress()
    ProfileService.shared.logout { [weak self] _ in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        self.dismiss(animated: true)
      }
    }
  }

  @objc
  private func didTapOnDiscountCard() {
    output?.showDiscountCard()
  }
  
  @objc
  private func didTapOnLogout() {
    let okAlert = AlertAction(style: .filled,
                              title: Localizator.standard.localizedString("Выйти"),
                              isEmphasized: false) { [weak self] in
      self?.logout()
    }
    let cancelAlert = AlertAction(style: .filled,
                                  title: Localizator.standard.localizedString("Отменить"),
                                  isEmphasized: false) { [weak self] in
      self?.dismiss(animated: true)
    }
    showAlert(title: Localizator.standard.localizedString("Вы действительно хотите выйти из аккаунта?"),
              subtitle: nil,
              actions: [okAlert, cancelAlert])
  }
  
  @objc
  private func userWasUpdated() {
    updateWithUser()
  }
  
  @objc
  private func logOutProfile() {
    updateWithUser()
  }
  
  @objc
  private func refresh() {
    updateProfile()
  }
  
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .mainInfoWithDiscount(let discountVMs, let bonusesVMs, let buttonTitle):
      let cell: ProfileMainInfoDiscountTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.configure(discountVMs: discountVMs,
                     bonusesVMs: bonusesVMs,
                     buttonTitle: buttonTitle)
      return cell
    case .mainInfo(let bonusesVMs, let buttonTitle):
      let cell: ProfileMainInfoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.configure(bonusesVMs: bonusesVMs,
                     buttonTitle: buttonTitle)
      return cell
    case .mainGuest(let textValues):
      let cell: ProfileMainGuestTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.configure(textValues: textValues)
      return cell
    case .profileInfo(let viewModel):
      let cell: ProfileInfoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(viewModel: viewModel,
                     separatorPosition: .bottom)
      return cell
    case .favoritesProducts(let viewModel):
      let cell: ProfileInfoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(viewModel: viewModel,
                     separatorPosition: .bottom)
      return cell
    case .info(let viewModel, _):
      let cell: ProfileInfoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(viewModel: viewModel,
                     separatorPosition: .bottom)
      return cell
    case .phone(let viewModel):
      let cell: PhoneNumberTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.configure(viewModel: viewModel)
      return cell
    case .time(let viewModel):
      let cell: TimeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(viewModel: viewModel)
      return cell
    case .support:
      let cell: SupportTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      
      var socials = ContactsHelper().socials
      let appleChat = ContactsHelper().getSocialModel(socialType: .businessChat)
      socials.insert(appleChat, at: socials.startIndex)

      cell.supportView.updateViewStateWith(socials)
      cell.supportView.addSupportSocialDelegate(self)
      cell.supportView.addHotLineTarget(self, action: #selector(makeCall))

      return cell
    case .deleteAccount(let viewModel):
      let cell: DeleteAccountTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(viewModel: viewModel,
                     separatorPosition: .bottom)
      return cell
    case .space(let height, let backgroundColor):
      let cell: SpaceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(space: height, backgroundColor: backgroundColor)
      return cell
    case .language(let title, let viewModels, let selectedVM):
      let cell: LanguageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(title: title,
                     viewModels: viewModels,
                     selectedViewModel: selectedVM)
      cell.delegate = self
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) as? LanguageTableViewCell {
      cell.delegate = nil
    }
  }

  @objc
  private func makeCall() {
    if let url = URL(string: "tel://" + ContactsHelper().formattedPhone.withoutWhitespaces()), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch dataSource[indexPath.row] {
    case .deleteAccount:
      self.didTapOnDeleteAccount()
    case .profileInfo:
      output?.didTapOnShowProfileData(from: self)
    case .favoritesProducts:
      output?.didTapOnShowFavorites(from: self)
    case .info(_, let type):
      switch type {
      case .agreement:
        output?.showAgreement(from: self)
      case .deleteAccountAgreement:
        output?.showDeleteAccountAgreement(from: self)
      case .delivery:
        output?.showDeliveryInfo(from: self)
      case .offer:
        output?.showOffer(from: self)
      case .refund:
        output?.showRefundInfo(from: self)
      case .discount:
        output?.showDiscountAgreement(from: self)
      }
    default: break
    }
  }
}

// MARK: - ProfileMainInfoDiscountTableViewCellDelegate
extension ProfileViewController: ProfileMainInfoDiscountTableViewCellDelegate {
  internal func didTapOnDiscountAgreement() {
    output?.showDiscountAgreement(from: self)
  }
}

// MARK: - ProfileMainInfoDiscountTableViewCellDelegate
extension ProfileViewController: ProfileMainInfoTableViewCellDelegate { }

// MARK: - GuestHeaderViewDelegate
extension ProfileViewController: GuestHeaderViewDelegate {
  func subtitleTextWasClicked(from: GuestHeaderView) {
    output?.showSite(from: self)
  }
  
  func buttonWasClicked(from: GuestHeaderView) {
    output?.didTapOnSignIn(from: self)
  }
}

// MARK: - LanguageTableViewCellDelegate
extension ProfileViewController: LanguageTableViewCellDelegate {
  func didChangeLanguage(with index: Int) {
    for case let (dataSourceIndex, ProfileInfoItem.language(title, viewModels, _)) in dataSource.enumerated() {
      guard let language = AppLanguage.list.first(where: { $0.code == viewModels[index].id }) else { return }
      dataSource[dataSourceIndex] = .language(title: title, viewModels: viewModels, selectedVMs: viewModels[index])
      LocalizationService.shared.language = language
    }
  }
}

// MARK: - PhoneNumberTableViewCellDelegate
extension ProfileViewController: PhoneNumberTableViewCellDelegate {
  func didTapOnPhone() {
    if let url = URL(string: "tel://\(ContactsHelper().phone)"), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
}

// MARK: - ImageTitleImagesTableViewCellDelegate
extension ProfileViewController: ImageTitleImagesTableViewCellDelegate, SupportSocialViewDelegate {
  func didTapOnImage(with index: Int) {
    guard socials.count > index else { return }
    let selectedSocial = socials[index]
    openSocial(selectedSocial)
  }
  
  private func openSocial(_ social: Social) {
    guard let socialWebURL = URL(string: social.webUrl),
          UIApplication.shared.canOpenURL(socialWebURL) else { return }
    UIApplication.shared.open(socialWebURL, options: [:], completionHandler: nil)
  }
}

private enum UIConstants {
  static let goldColor = UIColor.color(r: 255, g: 220, b: 136)
  static let silverColor = UIColor.white
  static let spaceBackgroundColor = UIColor.white
}
