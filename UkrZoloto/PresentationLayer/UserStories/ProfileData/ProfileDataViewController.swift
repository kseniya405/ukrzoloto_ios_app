//
//  ProfileDataViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/11/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

enum ProfileItem {
  case field((ProfileData, type: ProfileDataType))
  case titleSubtitle(TitleSubtitleViewModel)
  case emptyButton(title: String)
  case event(EventData)
  case space(height: CGFloat)
  case centeredEmptyButton(title: String)
  case roundButton(title: String, fillColor: UIColor)
  case gender(Gender)
}

enum ProfileDataType {
  case name
  case surname
  case email
  case phone
  case birthday
  case city
}

typealias ProfileData = (vm: UnderlinePlaceholderViewModel, isDate: Bool)
typealias EventData = (event: UkrZolotoInternalEvent, image: UIImage)

protocol ProfileDataViewControllerOutput: AnyObject {
  func didTapOnBack(from vc: ProfileDataViewController)
  func didTapOnAddEvent(from vc: ProfileDataViewController)
}

class ProfileDataViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: ProfileDataViewControllerOutput?
  var events = [UkrZolotoInternalEvent]()
  
  // MARK: - Private variables
  private let selfView = ProfileDataView()
  
  private var dataSource = [ProfileItem]()
  
  var userBirthdayLocked = ProfileService.shared.user!.birthday != nil
  
  // MARK: - Life cycle
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addObservers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeObservers()
  }
  
  deinit {
    removeObservers()
  }
  
  // MARK: - Setup
  override func initConfigure() {
    super.initConfigure()
    setupNavBar()
    setupView()
    localizeLabels()
    setupDataSource()
  }
  
  private func setupNavBar() {
    setNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem())
    setNavigationButton(#selector(didTapOnSave),
                        button: ButtonsFactory.saveButtonForNavigationItem(),
                        side: .right)
  }
  
  private func setupView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil
    )
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func setupDataSource() {
    dataSource.removeAll()
    guard let user = ProfileService.shared.user else { return }
    let nameVM = ProfileData(
      vm: UnderlinePlaceholderViewModel(
        text: user.name,
        placeholder: Localizator.standard.localizedString("Имя")),
      isDate: false)
    dataSource.append(.space(height: 20))
    dataSource.append(.field((nameVM, type: .name)))
    
    let surnameVM = ProfileData(
      vm: UnderlinePlaceholderViewModel(
        text: user.surname,
        placeholder: Localizator.standard.localizedString("Фамилия")),
      isDate: false)
    dataSource.append(.space(height: 20))
    dataSource.append(.field((surnameVM, type: .surname)))
    let phoneVM = ProfileData(
      vm: UnderlinePlaceholderViewModel(
        text: PhoneNumberHelper.shared.getFormatedNumber(from: user.phone),
        placeholder: Localizator.standard.localizedString("Телефон")),
      isDate: false)
    dataSource.append(.space(height: 20))
    dataSource.append(.field((phoneVM, type: .phone)))
    let emailVM = ProfileData(
      vm: UnderlinePlaceholderViewModel(
        text: user.email,
        placeholder: Localizator.standard.localizedString("E-mail"),
        description: Localizator.standard.localizedString("Узнавайте первыми о скидках и акциях")),
      isDate: false)
    dataSource.append(.space(height: 20))
    dataSource.append(.field((emailVM, type: .email)))
    dataSource.append(.space(height: 20))
    dataSource.append(.field((getDateData(date: user.birthday), type: .birthday)))
    dataSource.append(.space(height: 30))
    dataSource.append(.gender(user.gender))

    selfView.getTableView().reloadData()
  }
  
  private func addEvents() {
    dataSource.append(.space(height: 14))
    events.forEach { event in
      dataSource.append(.event(EventData(event: event,
                                         image: #imageLiteral(resourceName: "controlsClearField"))))
      dataSource.append(.space(height: 20))
    }
    
    dataSource.append(.space(height: 20))
    dataSource.append(.emptyButton(
      title: Localizator.standard.localizedString("Добавить событие").uppercased()))
  }
  
  private func getDateData(date: Date? = nil) -> ProfileData {
    var stringDate: String?
    if let date = date {
      let formatter = DateFormattersFactory.dateOnlyFormatter()
      stringDate = formatter.string(from: date)
    }

    let viewModel = UnderlinePlaceholderViewModel(text: stringDate,
                                                  placeholder: Localizator.standard.localizedString("Дата рождения"),
                                                  description: nil,
                                                  image: ImageViewModel.image(#imageLiteral(resourceName: "controlsCalendar")))
    return ProfileData(vm: viewModel, isDate: true)
  }
  
  // MARK: - Interface
  func updateEvents() {
    setupDataSource()
  }
  
  // MARK: - Localization
  override func localize() {
    localizeLabels()
    setupDataSource()
  }
  
  private func localizeLabels() {
    navigationItem.title = Localizator.standard.localizedString("Мои данные")
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnSave() {
    var name: String?
    var surname: String?
    var email: String?
    var birthday: Date?
    var gender: Gender = .undefined
    
    for case let ProfileItem.field((data, type)) in dataSource {
      switch type {
      case .name:
        name = data.vm.text
      case .surname:
        surname = data.vm.text
      case .email:
        let text = data.vm.text
        email = Validator.isValidString(text, ofType: .email) ? text : nil
      case .birthday:
        let formatter = DateFormattersFactory.dateOnlyFormatter()
        birthday = formatter.date(from: data.vm.text ?? "")
      case .city,
           .phone:
        break
      }
    }
    
    for case let ProfileItem.gender(selectedGender) in dataSource {
      gender = selectedGender
    }
    
    HUD.showProgress()
    ProfileService.shared.updateUser(name: name,
                                     surname: surname,
                                     email: email,
                                     birthday: birthday,
                                     gender: gender) { [weak self] result in
                                      DispatchQueue.main.async {
                                        HUD.hide()
                                        guard let self = self else { return }
                                        switch result {
                                        case .success:
                                          self.output?.didTapOnBack(from: self)
                                        case .failure(let error):
                                          self.handleError(error)
                                        }
                                      }
                                      
    }
  }
  
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    guard let kbSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    guard let kbDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
    animateToBottomOffset(kbSizeValue.cgRectValue.height,
                          duration: kbDuration.doubleValue)
  }
  
  @objc
  private func keyboardWillHide(notification: NSNotification) {
    animateToBottomOffset(0, duration: 0)
  }
  
  private func animateToBottomOffset(_ offset: CGFloat, duration: Double) {
    selfView.updateBottomConstraint(offset: offset,
                                    duration: duration)
  }
  
}

// MARK: - UITableViewDataSource
extension ProfileDataViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .field((let profileData, _)):
      
      if profileData.isDate && userBirthdayLocked {
        let cell: LockedDateTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(profileData: profileData)
        return cell
      }
      
      let cell: UnderlineTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.configure(profileData: profileData)
      return cell
    case .titleSubtitle(let viewModel):
      let cell: TitleSubtitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(viewModel: viewModel)
      return cell
    case .space(let height):
      let cell: SpaceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(space: height)
      return cell
    case .emptyButton(let title):
      let cell: EmptyButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.configure(title: title)
      return cell
    case .event(let data):
      let cell: EventTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.configure(eventData: data)
      return cell
    case .gender(let gender):
      let cell: GenderPickerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.setGenderSelected(gender: gender)
      return cell
    default: fatalError()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch dataSource[indexPath.row] {
    case .field((let profileData, _)):
      
      if profileData.isDate && userBirthdayLocked {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? LockedDateTableViewCell else { return }
        
        cell.setIcon(highlighted: true)
        displayBirthDateToolTip(originCell: cell)
      }
      
    default: break
    }
  }
  
}

// MARK: - UnderlineTableViewCellDelegate
extension ProfileDataViewController: UnderlineTableViewCellDelegate {
  func shouldBeginEditingTextField(in cell: UnderlineTableViewCell) -> Bool {
    if let index = selfView.getTableView().indexPath(for: cell),
      case let ProfileItem.field(profileData) = dataSource[index.row] {
      switch profileData.type {
      case .phone:
        return false
      case .birthday:
        return !userBirthdayLocked
      case .name,
           .surname,
           .email,
           .city:
        return true
      }
    }
    return true
  }
  
  func shouldChangeCharactersIn(_ textField: UITextField,
                                range: NSRange,
                                replacementString string: String,
                                in cell: UnderlineTableViewCell) -> Bool {
    if let index = selfView.getTableView().indexPath(for: cell),
      case let ProfileItem.field(profileData) = dataSource[index.row] {
      let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
      switch profileData.type {
      case .email:
        if let newString = newString {
          let allowedSymbolsOnly = string.rangeOfCharacter(from: Validator.allowedCharacterSet(for: .email).inverted) == nil
          return newString.count <= Validator.maxSymbolsCount(for: .email) && allowedSymbolsOnly
        } else {
          return true
        }
      case .name:
        return Validator.shouldChangeText(newString, for: .name)
      case .surname:
        return Validator.shouldChangeText(newString, for: .surname)
      case .phone,
           .city,
           .birthday:
        return true
      }
    }
    return true
  }
  
  func textDidChanged(newText: String?, in cell: UITableViewCell) {
    if let index = selfView.getTableView().indexPath(for: cell),
      case let ProfileItem.field(profileData) = dataSource[index.row] {
      var updatedData = profileData
      updatedData.0.vm.text = newText
      dataSource[index.row] = .field((updatedData.0, type: updatedData.type))
    }
  }
  
  func displayBirthDateToolTip(originCell: LockedDateTableViewCell) {
    
    let pointRect = originCell.infoIconConvertedRect()
    guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }

    let tipView = ProfileBirthdateToolTipView(originRect: pointRect)
    
    tipView.display(in: window)
    
    tipView.onDismiss = { [weak originCell] in
      
      originCell?.setIcon(highlighted: false)
    }
    
    tipView.onPhoneNumberTap = { [weak self] in
      self?.handleSupportNumberTap()
    }
  }
    
  func handleSupportNumberTap() {
    
    if let url = URL(string: "tel://" + ContactsHelper().formattedPhone.withoutWhitespaces()), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
}
 
// MARK: - GenderPickerTableViewCellDelegate
extension ProfileDataViewController: GenderPickerTableViewCellDelegate {
  
  func genderPickerChangeSelection(to gender: Gender) {
    
    var indexItem = 0
        
    for (index, item) in dataSource.enumerated() {
      if case ProfileItem.gender(_) = item {
        indexItem = index
      } else {
        continue
      }
    }

    dataSource[indexItem] = ProfileItem.gender(gender)
  }
}

// MARK: - EmptyButtonTableViewCellDelegate
extension ProfileDataViewController: EmptyButtonTableViewCellDelegate {
  func didTapOnEmptyButton() {
    output?.didTapOnAddEvent(from: self)
  }
  
}

// MARK: - DatePickerBottomViewDelegate
extension ProfileDataViewController: DatePickerBottomViewDelegate {
  func didDateWasChanged(to date: Date) {
    var dateIndex = 0
    var data: ProfileData?
    for (index, item) in dataSource.enumerated() {
      if case let ProfileItem.field((profileData, _)) = item {
        guard profileData.isDate else { continue }
        dateIndex = index
        data = getDateData(date: date)
      }
    }
    
    guard let updatedData = data else { return }
    dataSource[dateIndex] = ProfileItem.field((updatedData, type: .birthday))
    let cell = selfView.getTableView().cellForRow(
      at: IndexPath(row: dateIndex, section: 0)) as? UnderlineTableViewCell
    cell?.configure(profileData: updatedData)
  }

}

// MARK: - UITableViewDelegate
extension ProfileDataViewController: UITableViewDelegate {
  
}

// MARK: - EventTableViewCellOutput
extension ProfileDataViewController: EventTableViewCellOutput {
  func didTapOnClean(from event: UkrZolotoInternalEvent) {
		guard let deletedIndex = events.firstIndex(of: event) else { return }
    events.remove(at: deletedIndex)
    let dataIndex = dataSource.firstIndex { profileItem -> Bool in
      if case let ProfileItem.event(eventData) = profileItem {
        return eventData.event == event
      }
      return false
    }
    guard let dataSourceIndex = dataIndex else { return }
    dataSource.removeSubrange(dataSourceIndex...dataSourceIndex + 1)
    selfView.getTableView().deleteRows(at: [IndexPath(row: dataSourceIndex, section: 0),
                                            IndexPath(row: dataSourceIndex + 1, section: 0)],
                                       with: .fade)
  }
  
}
