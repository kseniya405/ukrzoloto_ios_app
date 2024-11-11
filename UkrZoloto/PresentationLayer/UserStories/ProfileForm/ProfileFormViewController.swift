//
//  ProfileFormViewController.swift
//  UkrZoloto
//
//  Created by Mykola on 05.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

extension ProfileFormViewController {
  
  class func createInstance() -> ProfileFormViewController {
    
    let vc = ProfileFormViewController(shouldDisplayOnFullScreen: true)
    vc.modalPresentationStyle = .overFullScreen
    
    return vc
  }
}

protocol ProfileFormViewControllerOutput: AnyObject {
  
  func profileFormTappedSkip(_ viewController: UIViewController)
  func profileFormTappedPolicy(_ viewController: UIViewController)
  func profileFormTappedSave(_ viewConroller: ProfileFormViewController, formDTO: ProfileFormDTO)
  
}

class ProfileFormViewController: LocalizableViewController, ErrorAlertDisplayable {
  
  weak var output: ProfileFormViewControllerOutput?
  
  private let selfView = ProfileFormView()
  
  private var dataSource = [ProfileItem]()
  private var birthDateLocked = ProfileService.shared.user!.birthday != nil

  // MARK: - Overrides methods
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func loadView() {
    self.view = selfView
  }
  
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
    configureDataSource()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    addObservers()
  }
  
  override func localize() {
    localizeLabels()
  }
  
  // MARK: - Private methods
  
  private func configureSelf() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
  }

  private func configureDataSource() {
    
    dataSource.removeAll()
    guard let user = ProfileService.shared.user else { return }
    let nameVM = ProfileData(
      vm: UnderlinePlaceholderViewModel(
        text: user.name,
        placeholder: Localizator.standard.localizedString("Имя"),
        error: Localizator.standard.localizedString("Поле Имя должно быть заполнено")),
      isDate: false)
    dataSource.append(.space(height: 20))
    dataSource.append(.field((nameVM, type: .name)))
    
    let surnameVM = ProfileData(
      vm: UnderlinePlaceholderViewModel(
        text: user.surname,
        placeholder: Localizator.standard.localizedString("Фамилия"),
        error: Localizator.standard.localizedString("Поле Фамилия должно быть заполнено")),
      isDate: false)
    dataSource.append(.space(height: 20))
    dataSource.append(.field((surnameVM, type: .surname)))
    
    let emailVM = ProfileData(
      vm: UnderlinePlaceholderViewModel(
        text: user.email,
        placeholder: Localizator.standard.localizedString("E-mail"),
        error: Localizator.standard.localizedString("Введен некорректный e-mail.")),
      isDate: false)
    dataSource.append(.space(height: 20))
    dataSource.append(.field((emailVM, type: .email)))

    dataSource.append(.space(height: 20))
    dataSource.append(.field((getDateData(date: user.birthday), type: .birthday)))

    dataSource.append(.space(height: 28.0))
    dataSource.append(.gender(user.gender))

    dataSource.append(.space(height: 20.0))
    dataSource.append(.roundButton(title: Localizator.standard.localizedString("Сохранить"),
                                   fillColor: UIColor(named: "darkGreen")!))

    dataSource.append(.space(height: 16.0))
    dataSource.append(.centeredEmptyButton(title: Localizator.standard.localizedString("Политика конфиденциальности")))
    
    dataSource.append(.space(height: 96.0))
    dataSource.append(.centeredEmptyButton(title: Localizator.standard.localizedString("Пропустить")))
    dataSource.append(.space(height: 20.0))

    selfView.getTableView().reloadData()
  }
  
  private func localizeLabels() {
    selfView.localize()
  }
  
  private func getDateData(date: Date?) -> ProfileData {
    var stringDate: String?
    if let date = date {
      let formatter = DateFormattersFactory.dateOnlyFormatter()
      stringDate = formatter.string(from: date)
    }
    
    let image: ImageViewModel = {
      
      if birthDateLocked {
        return ImageViewModel.image(#imageLiteral(resourceName: "info_icon"))
      }
      return ImageViewModel.image(#imageLiteral(resourceName: "controlsCalendar"))
    }()
    
    let viewModel = UnderlinePlaceholderViewModel(text: stringDate,
                                                  placeholder: Localizator.standard.localizedString("Дата рождения"),
                                                  description: nil,
                                                  image: image,
                                                  error: Localizator.standard.localizedString("Необходимо указать дату рождения"))
    return ProfileData(vm: viewModel, isDate: true)
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil
    )
  }
  
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    
    selfView.scrollToTop()
  }
}

extension ProfileFormViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch dataSource[indexPath.row] {
    case .field((let profileData, _)):
      
      if profileData.isDate && birthDateLocked {
        
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

    case .centeredEmptyButton(let title):
      let cell: CenteredEmptyButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.setTitle(title)
      return cell
      
    case .roundButton(let title, let color):
      let cell: RoundedButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.set(title: title, fillColor: color)
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
      
      if profileData.isDate && birthDateLocked {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? LockedDateTableViewCell else { return }
        
        cell.setIcon(highlighted: true)
        displayBirthDateToolTip(originCell: cell) 
      }
      
    default: break
    }
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    selfView.scrollViewDidScroll(scrollView)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    selfView.scrollViewDidEndDragging(scrollView)
  }
}

// MARK: - Validation
private extension ProfileFormViewController {
  
  func validate(formData: ProfileFormDTO) -> Bool {

    var formValid = true
    
    if !Validator.isValidString(formData.name, ofType: .name) {
      
      let cell = getNameCell()
      cell.setError()
      formValid = false
    }
    
    if !Validator.isValidString(formData.surname, ofType: .surname) {
      
      let cell = getSurnameCell()
      cell.setError()
      formValid = false
    }

    if !Validator.isValidString(formData.email, ofType: .email) {
      
      let cell = getEmailCell()
      cell.setError()
      formValid = false
    }
    
    if !birthDateLocked && formData.birthday == nil {
      let cell = getBirthdayCell()
      cell.setError()
      formValid = false
    }
    
    if formData.gender == .undefined {
      
      let cell = getGenderCell()
      cell.setError()
      formValid = false
    }
    
    return formValid
  }
  
  func extractFormData() -> ProfileFormDTO {
    
    var name: String?
    var surname: String?
    var email: String?
    var birthday: Date?
    var genderType: Gender = .undefined
    
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
    
    for case let ProfileItem.gender(gender) in dataSource {
      genderType = gender
    }
    
    return ProfileFormDTO(name: name,
                          surname: surname,
                          email: email,
                          birthday: birthday,
                          gender: genderType)
  }
  
  func resetErrors() {
    
    var cells: [UnderlineTableViewCell] = [getNameCell(),
                                           getSurnameCell(),
                                           getEmailCell()]
    
    if !birthDateLocked {
      cells.append(getBirthdayCell())
    }
    
    cells.forEach { cell in
      cell.hideError()
    }
    
    getGenderCell().resetError()
  }
  
  func getNameCell() -> UnderlineTableViewCell {
    
    guard let cell = selfView.getTableView().cellForRow(at: IndexPath(row: 1, section: 0)) as? UnderlineTableViewCell else {
      fatalError()
    }
    
    return cell
  }
  
  func getSurnameCell() -> UnderlineTableViewCell {
    
    guard let cell = selfView.getTableView().cellForRow(at: IndexPath(row: 3, section: 0)) as? UnderlineTableViewCell else {
      fatalError()
    }
    
    return cell
  }
  
  func getEmailCell() -> UnderlineTableViewCell {
    
    guard let cell = selfView.getTableView().cellForRow(at: IndexPath(row: 5, section: 0)) as? UnderlineTableViewCell else {
      fatalError()
    }
    
    return cell
  }
  
  func getBirthdayCell() -> UnderlineTableViewCell {
    
    guard let cell = selfView.getTableView().cellForRow(at: IndexPath(row: 7, section: 0)) as? UnderlineTableViewCell else {
      fatalError()
    }
    
    return cell
  }
  
  func getGenderCell() -> GenderPickerTableViewCell {
    
    guard let cell = selfView.getTableView().cellForRow(at: IndexPath(row: 9, section: 0)) as? GenderPickerTableViewCell else {
      fatalError()
    }
    
    return cell
  }
}

// MARK: - UnderlineTableViewCellDelegate
extension ProfileFormViewController: UnderlineTableViewCellDelegate {

  func shouldBeginEditingTextField(in cell: UnderlineTableViewCell) -> Bool {
    if let index = selfView.getTableView().indexPath(for: cell),
      case let ProfileItem.field(profileData) = dataSource[index.row] {
      switch profileData.type {
      case .phone:
        return false
      case .birthday:
        return !birthDateLocked
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
}

// MARK: - DatePickerBottomViewDelegate
extension ProfileFormViewController: DatePickerBottomViewDelegate {
  
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

extension ProfileFormViewController: CenteredEmptyButtonTableViewCellDelegate, RoundedButtonTableViewCellDelegate, ProfileFormSavedViewControllerDelegate {
  
  func profileFormSavedViewControllerTappedClose() {
    dismiss(animated: true, completion: nil)
  }
  
  func profileFormSavedViewControllerTappedProceed() {
    dismiss(animated: true, completion: nil)
  }
  
  func roundedButtonTapped() {
  
    resetErrors()
    
    let formData = extractFormData()
    
    if validate(formData: formData) {
     
      output?.profileFormTappedSave(self, formDTO: formData)
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
  
  func didTapOnEmptyButton(title: String) {
   
    switch title {
    case Localizator.standard.localizedString("Политика конфиденциальности"):
      
      output?.profileFormTappedPolicy(self)

    case Localizator.standard.localizedString("Пропустить"):
      
      output?.profileFormTappedSkip(self)
    default: break
    }
  }
}

extension ProfileFormViewController: GenderPickerTableViewCellDelegate {
  
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
