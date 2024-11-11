//
//  CategoriesCellController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/26/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol CategoriesCellControllerDelegate: AnyObject {
  func categoriesCellController(_ controller: CategoriesCellController, didSelectCategorytAt index: Int)
}

class CategoriesCellController: NSObject, AUIViewController {
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
  weak var delegate: CategoriesCellControllerDelegate?
  
  var categoriesView: CategoriesView? {
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
  
  private(set) var categoryViewModels = [ImageTitleImageViewModel]()
  
  // MARK: - Private variables
  private var selectedIndex: Int?
  private var _view: UIView?
  
  // MARK: - Configure
  func setupView() {
    let tableView = categoriesView?.getTableView()
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.register(CategoryTableViewCell.self)
    setTitle(title)
    setViewModels(categoryViewModels)
  }
  
  func unsetupView() {
  }
  
  func setup() {
  }
  
  // MARK: - Interface
  
  func setTitle(_ title: String?) {
    self.title = title
    categoriesView?.setTitle(title)
  }
  
  func setCategories(_ categories: [Category]) {
    let viewModels = categories.map { category -> ImageTitleImageViewModel in
      ImageTitleImageViewModel(leftImageViewModel: .url(category.imageURL, placeholder: #imageLiteral(resourceName: "placeholderCategory")),
                               title: category.name,
                               rightImageViewModel: .image(UIConstants.rightImage))
    }
    setViewModels(viewModels)
  }
  
  // MARK: - Actions
  
  private func setViewModels(_ viewModels: [ImageTitleImageViewModel]) {
    self.categoryViewModels = viewModels
    updateCategories()
  }
  
  private func updateCategories() {
    categoriesView?.getTableView().reloadData()
    categoriesView?.setNeedsUpdateConstraints()
  }
}

private enum UIConstants {
  static let rightImage = #imageLiteral(resourceName: "controlsArrow")
  enum ReuseIdentifiers {
    static let categoriesViewCell = "categoriesViewCell"
  }
}

// MARK: - UITableViewDataSource
extension CategoriesCellController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: CategoryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    let isLastCell = indexPath.row == categoryViewModels.count - 1
    cell.configure(viewModel: categoryViewModels[indexPath.row],
                   separatorPosition: isLastCell ? [] : .bottom)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CategoriesCellController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.categoriesCellController(self, didSelectCategorytAt: indexPath.row)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
