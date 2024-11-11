//
//  SubcategoriesCellController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/31/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol SubcategoriesCellControllerDelegate: AnyObject {
  func subcategoriesCellController(_ controller: SubcategoriesCellController, didSelectCategoryAt index: Int)
  func subcategoriesCellControllerDidChangedState(_ controller: SubcategoriesCellController)
}

class SubcategoriesCellController: NSObject, AUIViewController {
  enum State {
    case full
    case expanded
    case collapsed
  }
  
  var isUserInteractionEnabled = true {
    didSet {
      didSetIsUserInteractionEnabled(oldValue: oldValue)
    }
  }
  func didSetIsUserInteractionEnabled(oldValue: Bool) {
    view?.isUserInteractionEnabled = isUserInteractionEnabled
  }
  
  open var isFirstResponder: Bool {
    return view?.isFirstResponder ?? false
  }
  
  open func becomeFirstResponder() {
    view?.becomeFirstResponder()
  }
  
  open func resignFirstResponder() {
    view?.resignFirstResponder()
  }
  
  // MARK: - Public variables
  weak var delegate: SubcategoriesCellControllerDelegate?
  
  var subcategoriesView: CategoriesView? {
    get { return view as? CategoriesView }
    set { view = newValue }
  }
  
  var view: UIView? {
    get {
      return _view
    }
    set {
      if newValue !== _view {
        unsetupView()
        _view = newValue
        setupView()
      }
    }
  }
  
  private(set) var title: String?
  
  private(set) var subcategoryViewModels = [ImageTitleImageViewModel]()
  
  // MARK: - Private variables
  private var selectedIndex: Int?
  private var _view: UIView?
  
  private(set) var state: State
  private var maxCount: Int
  private var subcategories = [Subcategory]()
  
  init(maxCount: Int) {
    self.maxCount = maxCount
    state = .full
  }
  
  // MARK: - Configure
  func setupView() {
    let tableView = subcategoriesView?.getTableView()
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.register(CategoryTableViewCell.self)
    setTitle(title)
    setViewModels(subcategoryViewModels)
  }
  
  func unsetupView() {
  }
  
  func setup() {
  }
  
  // MARK: - Interface
  
  func setTitle(_ title: String?) {
    self.title = title
    subcategoriesView?.setTitle(title)
  }
  
  func setSubcategories(_ subcategories: [Subcategory]) {
    self.subcategories = subcategories
    
    var models = viewModels(from: Array(subcategories[0..<min(subcategories.count, maxCount)]))
    if subcategories.count > maxCount {
      models.append(ImageTitleImageViewModel(leftImageViewModel: .image(nil),
                                             title: Localizator.standard.localizedString("Смотреть еще"),
                                             rightImageViewModel: .image(UIConstants.bottomImage)))
      state = .collapsed
    } else {
      state = .full
    }
    setViewModels(models)
  }
  
  // MARK: - Actions
  
  private func setViewModels(_ viewModels: [ImageTitleImageViewModel]) {
    self.subcategoryViewModels = viewModels
    updateSubcategories()
  }
  
  private func updateSubcategories() {
    subcategoriesView?.getTableView().reloadData()
    subcategoriesView?.setNeedsUpdateConstraints()
  }
  
  private func viewModels(from subcategories: [Subcategory]) -> [ImageTitleImageViewModel] {
    let viewModels = subcategories.map { subcategory -> ImageTitleImageViewModel in
      ImageTitleImageViewModel(leftImageViewModel: .url(subcategory.imageURL, placeholder: #imageLiteral(resourceName: "placeholderCategory")),
                               title: subcategory.name,
                               rightImageViewModel: .image(UIConstants.rightImage))
    }
    return viewModels
  }
  
  private func toogleState() {
    switch state {
    case .collapsed:
      subcategoryViewModels = viewModels(from: subcategories)
      subcategoryViewModels.append(ImageTitleImageViewModel(leftImageViewModel: .image(nil),
                                                            title: Localizator.standard.localizedString("Скрыть"),
                                                            rightImageViewModel: .image(UIConstants.topImage)))
      state = .expanded
    case .expanded:
      subcategoryViewModels = viewModels(from: Array(subcategories[0..<maxCount]))
      subcategoryViewModels.append(ImageTitleImageViewModel(leftImageViewModel: .image(nil),
                                                            title: Localizator.standard.localizedString("Смотреть еще"),
                                                            rightImageViewModel: .image(UIConstants.bottomImage)))
      state = .collapsed
    case .full:
      break
    }
    delegate?.subcategoriesCellControllerDidChangedState(self)
  }
}

private enum UIConstants {
  static let rightImage = #imageLiteral(resourceName: "controlsArrow")
  static let topImage = #imageLiteral(resourceName: "UpArrow")
  static let bottomImage = #imageLiteral(resourceName: "bottomArrowSlim")
  enum ReuseIdentifiers {
    static let subcategoriesViewCell = "subcategoriesViewCell"
  }
}

// MARK: - UITableViewDataSource
extension SubcategoriesCellController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return subcategoryViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: CategoryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    let isLastCell = indexPath.row == subcategoryViewModels.count - 1
    cell.configure(viewModel: subcategoryViewModels[indexPath.row],
                   separatorPosition: isLastCell ? [] : .bottom)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension SubcategoriesCellController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch state {
    case .full:
      delegate?.subcategoriesCellController(self, didSelectCategoryAt: indexPath.row)
    case .collapsed:
      if indexPath.row < maxCount {
        delegate?.subcategoriesCellController(self, didSelectCategoryAt: indexPath.row)
      } else {
        toogleState()
      }
    case .expanded:
      if indexPath.row < subcategories.count {
        delegate?.subcategoriesCellController(self, didSelectCategoryAt: indexPath.row)
      } else {
        toogleState()
      }
    }
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
}
