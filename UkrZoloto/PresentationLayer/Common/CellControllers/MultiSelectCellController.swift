//
//  SelectCellController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 08.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol MultiSelectCellControllerDelegate: AnyObject {
  func multiSelectCellController(_ controller: MultiSelectCellController, didSelectValueAt index: Int)
}

class MultiSelectCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: MultiSelectCellControllerDelegate?
  
  var multiSelectView: MultiSelectView? {
    get { return view as? MultiSelectView }
    set { view = newValue }
  }
  
  private(set) var filter: SelectFilter {
    didSet { didSetFilter() }
  }
  private var collectionViewController = AUICollectionViewController()
  private var valueControllers: [AUIElementCollectionViewCellController] = []
  private var associatedFilterVariants: [ASTHashedReference: FilterVariant] = [:]
  
  // MARK: - Life cycle
  init(filter: SelectFilter) {
    self.filter = filter
    super.init()
  }
  
  // MARK: - Configuration
  override func setupView() {
    super.setupView()
    let collectionView = multiSelectView?.getCollectionView()
    collectionView?.register(AUIReusableCollectionCell.self,
                             forCellWithReuseIdentifier: UIConstants.ReuseIdentifiers.selectValueCell)
    collectionViewController.collectionView = collectionView
    setSelectFilters(filter)
  }
  
  override func unsetupView() {
    super.unsetupView()
    collectionViewController.collectionView = nil
  }
  
  // MARK: - Interface
  func setSelectFilters(_ filter: SelectFilter) {
    self.filter = filter
  }
  
  func createFilterValueViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    let cell: AUIReusableCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.selectValueCell,
                                                                             for: indexPath)
    cell.setCellCreateViewBlock { FilterSelectValueView() }
    cell.setupUI()
    return cell
  }
  
  // MARK: - Private methods
  private func didSetFilter() {
    valueControllers = []
    associatedFilterVariants = [:]
    multiSelectView?.setTitle(filter.title)
    filter.variants.forEach { variant in
      let selectValueController = FilterSelectValueCellController(variant: variant)
      let valueController = AUIElementCollectionViewCellController(controller: selectValueController,
                                                                   cellCreateBlock: createFilterValueViewCell)
      valueController.didSelectDelegate = self
      valueControllers.append(valueController)
      associatedFilterVariants[ASTHashedReference(valueController)] = variant
    }
    
    collectionViewController.cellControllers = valueControllers
    collectionViewController.reload()
    multiSelectView?.setNeedsUpdateConstraints()
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum ReuseIdentifiers {
    static let selectValueCell = "selectValueCell"
  }
}

// MARK: - AUICollectionViewCellControllerDelegate
extension MultiSelectCellController: AUICollectionViewCellControllerDelegate {
  func didSelectCollectionViewCellController(_ cellController: AUICollectionViewCellController) {
    if let selectedValue = associatedFilterVariants[ASTHashedReference(cellController)],
			 let index = filter.variants.firstIndex(of: selectedValue),
      selectedValue.active {
      delegate?.multiSelectCellController(self, didSelectValueAt: index)
    }
  }
  
}
