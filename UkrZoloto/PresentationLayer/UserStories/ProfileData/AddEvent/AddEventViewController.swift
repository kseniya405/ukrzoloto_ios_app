//
//  AddEventViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

private enum EventItem {
  case field(ProfileData)
  case space(height: CGFloat)
}

protocol AddEventViewControllerOutput: AnyObject {
  func didTapOnBack(from vc: AddEventViewController)
  func didTapOnSave(event: UkrZolotoInternalEvent)
}

class AddEventViewController: LocalizableViewController, NavigationButtoned {
  
  // MARK: - Public variables
  var output: AddEventViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = AddEventView()
  private var dataSource = [EventItem]()
  
  private var date: Date? {
    didSet {
      updateButtonState()
    }
  }
  private var eventTitle: String? {
    didSet {
      updateButtonState()
    }
  }
  
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
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    setupNavBar()
    setupView()
    localize()
    setupDataSource()
    updateButtonState()
  }
  
  private func setupNavBar() {
    setNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem())
  }
  
  private func setupView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
    selfView.getMainButton().addTarget(self,
                                       action: #selector(didTapOnSaveButton),
                                       for: .touchUpInside)
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(notification:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func setupDataSource() {
    dataSource.removeAll()
    let viewModels: [ProfileData] = [
      ProfileData(vm: UnderlinePlaceholderViewModel(
        placeholder: Localizator.standard.localizedString("Название события")),
                  isDate: false),
      getDateData()]
    
    viewModels.forEach { viewModel in
      dataSource.append(.space(height: 20))
      dataSource.append(.field(viewModel))
    }
    
    selfView.getTableView().reloadData()
  }
  
  private func getDateData(date: Date? = Date()) -> ProfileData {
    var stringDate: String?
    if let date = date {
      let formatter = DateFormattersFactory.eventDateFormatter()
      stringDate = formatter.string(from: date)
    }
    return ProfileData(vm: UnderlinePlaceholderViewModel(
      text: stringDate,
      placeholder: Localizator.standard.localizedString("Дата события"),
      image: ImageViewModel.image(#imageLiteral(resourceName: "controlsCalendar"))),
                       isDate: true)
  }
  
  private func updateButtonState() {
    selfView.getMainButton().isEnabled = !eventTitle.isNilOrEmpty && date != nil
  }
  
  // MARK: - Localization
  override func localize() {
    navigationItem.title = Localizator.standard.localizedString("Добавить событие")
    selfView.setButtonTitle(Localizator.standard.localizedString("Сохранить").uppercased())
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func didTapOnSaveButton() {
    guard let eventTitle = eventTitle,
      let date = date else { return }
    let event = UkrZolotoInternalEvent(title: eventTitle, date: date)
    output?.didTapOnSave(event: event)
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
extension AddEventViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .field(let profileData):
      let cell: UnderlineTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.configure(profileData: profileData)
      return cell
    case .space(let height):
      let cell: SpaceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(space: height)
      return cell
    }
  }
  
}

// MARK: - UITableViewDelegate
extension AddEventViewController: UITableViewDelegate { }

// MARK: - DatePickerBottomViewDelegate
extension AddEventViewController: DatePickerBottomViewDelegate {
  func didDateWasChanged(to date: Date) {
    self.date = date
    var dateIndex = 0
    var data: ProfileData?
    for (index, item) in dataSource.enumerated() {
      if case let EventItem.field(profileData) = item {
        guard profileData.isDate else { continue }
        dateIndex = index
        data = getDateData(date: date)
      }
    }
  
    guard let updatedData = data else { return }
    dataSource[dateIndex] = EventItem.field(updatedData)
    let cell = selfView.getTableView().cellForRow(
      at: IndexPath(row: dateIndex, section: 0)) as? UnderlineTableViewCell
    cell?.configure(profileData: updatedData)
  }
  
}

// MARK: - UnderlineTableViewCellDelegate
extension AddEventViewController: UnderlineTableViewCellDelegate {
  func shouldBeginEditingTextField(in cell: UnderlineTableViewCell) -> Bool {
    return true
  }
  
  func shouldChangeCharactersIn(_ textField: UITextField,
                                range: NSRange,
                                replacementString string: String,
                                in cell: UnderlineTableViewCell) -> Bool {
    guard let textField = textField as? UnderlinedTextField else { return true }
    let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
    if let newString = newString {
      let allowedSymbolsOnly = string.rangeOfCharacter(from: Validator.allowedCharacterSet(for: .event).inverted) == nil
      if newString.count <= Validator.maxSymbolsCount(for: .event),
        allowedSymbolsOnly {
        textField.text = newString
        eventTitle = newString
      }
    }
    
    return false
  }
  
  func textDidChanged(newText: String?, in cell: UITableViewCell) {
    
  }
}
