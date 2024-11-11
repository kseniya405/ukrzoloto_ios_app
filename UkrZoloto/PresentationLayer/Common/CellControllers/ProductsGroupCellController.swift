//
//  ProductsGroupCellController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/17/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol ProductsGroupCellControllerDelegate: AnyObject {
	func productCellController(_ controller: ProductsGroupCellController, didSelectProductAt index: Int)
	func productCellController(_ controller: ProductsGroupCellController, didTapOnFavoriteAt index: Int)
	func productCellController(_ controller: ProductsGroupCellController, didTapOnDiscountHint index: Int)
	func didTapOnShowMore(at controller: ProductsGroupCellController)
}

class ProductsGroupCellController: AUIDefaultViewController {
	
	// MARK: - Public variables
	weak var delegate: ProductsGroupCellControllerDelegate?
	
	var productsView: ProductsGroupView? {
		set { view = newValue }
		get { return view as? ProductsGroupView }
	}
	
	private(set) var title: String?
	private(set) var showMoreTitle: String?
	
	private(set) var products = [ProductTileViewModel]()
	
	private var collectionViewController = AUICollectionViewController()
	private var productControllers: [AUIElementCollectionViewCellController] = []
	private var associatedImageViewModels: [ASTHashedReference: ProductTileViewModel] = [:]
	
	private var selectedIndex: Int?
	
	// MARK: - Configure
	override func setupView() {
		super.setupView()
		let collectionView = productsView?.getCollectionView()
		collectionView?.register(AUIReusableCollectionCell.self,
														 forCellWithReuseIdentifier: UIConstants.ReuseIdentifiers.productListViewCell)
		collectionViewController.collectionView = collectionView
		productsView?.getShowMoreButton().addTarget(self,
																								action: #selector(didTapOnShowMoreButton),
																								for: .touchUpInside)
		setTitle(title)
		setProducts(products)
		setShowMoreTitle(showMoreTitle)
	}
	
	override func unsetupView() {
		super.unsetupView()
		collectionViewController.collectionView = nil
		productsView?.getShowMoreButton().removeTarget(nil, action: nil, for: .touchUpInside)
	}
	
	override func setup() {
		super.setup()
	}
	
	// MARK: - Interface
	
	func setTitle(_ title: String?) {
		self.title = title
		productsView?.setTitle(title)
	}
	
	func setProducts(_ products: [ProductTileViewModel]) {
		self.products = products
		updateProducts()
	}
	
	func setShowMoreTitle(_ title: String?) {
		self.showMoreTitle = title
		productsView?.setShowMoreTitle(title)
		productsView?.setNeedsUpdateConstraints()
	}
	
	func createTileViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		let cell: AUIReusableCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.ReuseIdentifiers.productListViewCell, for: indexPath)
		cell.setCellCreateViewBlock { ProductTileView() }
		cell.setupUI()
		return cell
	}
	
	// MARK: - Actions
	private func updateProducts() {
		productControllers = []
		associatedImageViewModels = [:]
		products.forEach { productViewModel in
			let tileController = ProductTileViewController()
			tileController.delegate = self
			tileController.tileViewModel = productViewModel
			
			let productController = AUIElementCollectionViewCellController(controller: tileController,
																																		 cellCreateBlock: createTileViewCell)
			productController.didSelectDelegate = self
			productControllers.append(productController)
			associatedImageViewModels[ASTHashedReference(productController)] = productViewModel
		}
		
		collectionViewController.cellControllers = productControllers
		collectionViewController.reload()
		productsView?.setNeedsUpdateConstraints()
	}
	
	@objc
	private func didTapOnShowMoreButton() {
		delegate?.didTapOnShowMore(at: self)
	}
}

private enum UIConstants {
	enum ReuseIdentifiers {
		static let productListViewCell = "productListViewCell"
	}
}

// MARK: - AUICollectionViewCellControllerDelegate
extension ProductsGroupCellController: AUICollectionViewCellControllerDelegate {
	func didSelectCollectionViewCellController(_ cellController: AUICollectionViewCellController) {
		if let selectedViewModel = associatedImageViewModels[ASTHashedReference(cellController)],
			 let index = products.firstIndex(of: selectedViewModel) {
			delegate?.productCellController(self, didSelectProductAt: index)
		}
	}
}

// MARK: - ProductTileViewControllerDelegate {
extension ProductsGroupCellController: ProductTileViewControllerDelegate {
	func changeFavoriteState(for tileViewModel: ProductTileViewModel) {
		if let index = products.firstIndex(of: tileViewModel) {
			delegate?.productCellController(self, didTapOnFavoriteAt: index)
		}
	}
	
	func openDiscountHint(for tileViewModel: ProductTileViewModel) {
		if let index = products.firstIndex(of: tileViewModel) {
			delegate?.productCellController(self, didTapOnDiscountHint: index)
		}
	}
}
