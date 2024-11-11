//
//  ProductView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 24.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol ScrollableProductViewDelegate: AnyObject {
	func shouldScroll(to offset: CGFloat)
}

protocol ProductViewDelegate: ScrollableProductViewDelegate {
	func didTapOnAssociatedProduct(_ product: Product)
	func didTapOnBanner(_ banner: Banner)
	func didTapOnFavoriteAtAssociatedProduct(_ product: Product)
	func didTapOnDiscountHintFor(_ product: Product)
	func isFullScreen() -> Bool
}

class ProductView: InitView {
	
	// MARK: - Public variables
	weak var sizeCollectionViewController: (UICollectionViewDataSource & UICollectionViewDelegate)? {
		didSet {
			sizeView.collectionController = sizeCollectionViewController
		}
	}
	
	weak var delegate: ProductViewDelegate?
	
	var product: Product? {
		didSet {
      if product?.id != oldValue?.id &&
          product?.sku != oldValue?.sku {
        setDefaultCollapsionState()
      }
		}
	}
	var variant: Variant?
	
	var associatedProducts = [Product]() {
		didSet {
			setProductsGroup()
			updateBannerImageView()
		}
	}
	var banner: Banner? {
		didSet {
      if banner?.id != oldValue?.id {
        bannerImageView.setImage(url: banner?.url,
                                 placeholder: #imageLiteral(resourceName: "arrowBanners"))
      }
		}
	}
	
	// MARK: - Private variables
	private let bannersView = BannersView(isPageInside: true, cellAspect: 1)
	private let scrollView = HitTestScrollView()
	private let contentView = UIView()
	
	private let lineView = UIView()
	private let stickersView = StickersView()
	private let describeLabel: UILabel = {
		let label = LineHeightLabel()
		label.lineHeight = UIConstants.DescribeLabel.height
		label.config
			.font(UIConstants.DescribeLabel.font)
			.textColor(UIConstants.DescribeLabel.color)
			.numberOfLines(0)
		return label
	}()
	
	private let sizeView = SizeProductView()
	
	private let separatorView = UIView()
	private let featureView = FeatureView()
	private let claspView = ClaspView()
	private let productsGroupView = HorizontalProductsGroupView()
	private let productsGroupViewController = HorizontalProductsGroupCellController()
	private let bannerImageView = UIImageView()
	private let bottomButtonsView = BottomButtonsView()
	
	private let buyProductView = BuyProductView()
	private let newUserBannerView = NewUserBannerView()
	private let registeredUserView = RegisteredUserView()
	private let registeredUserBirthdayView = RegisteredUserBirthdayView()
	private let deliveryAndPaymentView = DeliveryAndPaymentView()
	private let descriptionView = DescriptionView()
	private let supportView = SupportView()
	
	private var hasClasp = false
  private var collapsedStates: [String: Bool] = [:]

	override func layoutSubviews() {
		super.layoutSubviews()
		setupShadow()
	}
  
  deinit {
      scrollView.delegate = nil
      sizeCollectionViewController = nil
      delegate = nil
  }

	private func configureSelfView() {
		backgroundColor = UIConstants.SelfView.backgroundColor
	}
	
	private func configureBanners() {
		addSubview(bannersView)
		bannersView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(UIConstants.ContentView.topSafeArea)
			make.leading.trailing.equalToSuperview()
		}
	}
	
	private func configureScrollView() {
		addSubview(scrollView)
		scrollView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		scrollView.contentInset.top = Constants.Screen.screenWidth + UIConstants.ContentView.topSafeArea
		scrollView.contentInsetAdjustmentBehavior = .never
		scrollView.delegate = self
	}
	
	private func configureContentView() {
		scrollView.addSubview(contentView)
		contentView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.top.lessThanOrEqualTo(snp.top)
				.offset(UIConstants.ContentView.topOffset + UIConstants.ContentView.topSafeArea)
			make.centerX.equalTo(snp.centerX)
		}
		contentView.backgroundColor = UIConstants.ScrollView.backgroundColor
	}
	
	private func setupShadow() {
		contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		contentView.layer.cornerRadius = UIConstants.ContentView.cornerRadius
		contentView.layer.shadowOpacity = UIConstants.ContentView.shadowOpacity
		let shadowRadius = UIConstants.ContentView.shadowRadius
		let shadowRect = CGRect(origin: CGPoint(x: contentView.bounds.origin.x - shadowRadius / 2,
																						y: contentView.bounds.origin.y - shadowRadius),
														size: CGSize(width: contentView.bounds.width + shadowRadius,
																				 height: contentView.bounds.height))
		contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowRect,
																								cornerRadius: UIConstants.ContentView.cornerRadius).cgPath
		contentView.layer.shadowColor = UIConstants.ContentView.shadowColor.cgColor
		contentView.layer.shadowOffset = .zero
		contentView.layer.shadowRadius = shadowRadius / 2
	}
	
	private func configureLineView() {
		contentView.addSubview(lineView)
		lineView.snp.makeConstraints { make in
			make.top.equalToSuperview()
				.offset(UIConstants.LineView.top)
			make.centerX.equalToSuperview()
			make.height.equalTo(UIConstants.LineView.height)
			make.width.equalTo(UIConstants.LineView.width)
		}
		lineView.backgroundColor = UIConstants.LineView.backgroundColor
		lineView.layer.cornerRadius = UIConstants.LineView.radius
	}
	
	private func configureStickersView() {
		contentView.addSubview(stickersView)
		stickersView.snp.makeConstraints { make in
			make.top.equalTo(lineView.snp.bottom)
				.offset(UIConstants.StickersView.top)
			make.leading.trailing.equalToSuperview()
		}
	}
	
	private func configureDescribeLabel() {
		contentView.addSubview(describeLabel)
		describeLabel.snp.makeConstraints { make in
			make.top.equalTo(stickersView.snp.bottom).offset(UIConstants.DescribeLabel.top)
			make.leading.equalToSuperview().offset(UIConstants.DescribeLabel.leading)
			make.trailing.equalToSuperview().inset(UIConstants.DescribeLabel.trailing)
		}
	}
	
	private func configureSizeView() {
		contentView.addSubview(sizeView)
		sizeView.snp.makeConstraints { make in
			make.top.equalTo(describeLabel.snp.bottom).offset(UIConstants.SizeView.top)
			make.leading.trailing.equalToSuperview()
		}
	}
	
	private func configureBuyProductView() {
		contentView.addSubview(buyProductView)
		buyProductView.snp.makeConstraints { make in
			make.top.equalTo(sizeView.snp.bottom).offset(UIConstants.BuyProductView.top)
			make.left.equalToSuperview().offset(UIConstants.BuyProductView.leftRightPadding)
			make.right.equalToSuperview().offset(-UIConstants.BuyProductView.leftRightPadding)
		}
	}
	
	private func configureNewUserBannerView() {
		contentView.addSubview(newUserBannerView)
		newUserBannerView.snp.makeConstraints { make in
			make.top.equalTo(buyProductView.snp.bottom).offset(10)
			make.left.equalToSuperview().offset(UIConstants.BannerView.leftRightPadding)
			make.right.equalToSuperview().offset(-UIConstants.BannerView.leftRightPadding)
		}
	}
	
	private func configureRegisteredUserView() {
		contentView.addSubview(registeredUserView)
		registeredUserView.snp.makeConstraints { make in
			make.top.equalTo(buyProductView.snp.bottom).offset(10)
			make.left.equalToSuperview().offset(UIConstants.BannerView.leftRightPadding)
			make.right.equalToSuperview().offset(-UIConstants.BannerView.leftRightPadding)
		}
	}
	
	private func configureRegisteredUserBirthdayView() {
		contentView.addSubview(registeredUserBirthdayView)
		registeredUserBirthdayView.snp.makeConstraints { make in
			make.top.equalTo(buyProductView.snp.bottom).offset(10)
			make.left.equalToSuperview().offset(UIConstants.BannerView.leftRightPadding)
			make.right.equalToSuperview().offset(-UIConstants.BannerView.leftRightPadding)
		}
	}
	
	private func configureFeatureView() {
		contentView.addSubview(separatorView)
		separatorView.backgroundColor = UIConstants.SeparatorView.color
		
		separatorView.snp.makeConstraints { make in
			make.height.equalTo(UIConstants.SeparatorView.height)
			make.top.equalTo(buyProductView.snp.bottom).offset(UIConstants.FeatureView.verticalSpacing)
			make.leading.equalToSuperview().offset(UIConstants.FeatureView.horizontalSpacing)
			make.trailing.equalToSuperview().offset(-UIConstants.FeatureView.horizontalSpacing)
		}
		
		contentView.addSubview(featureView)
		featureView.snp.makeConstraints { make in
			make.top.equalTo(separatorView.snp.bottom)
				.offset(UIConstants.FeatureView.verticalSpacing)
			make.leading.trailing.equalToSuperview()
		}
		
		hasClasp = product?.categories.contains { $0.slug == "serezhky"
			|| $0.slug == "sergi"
			|| $0.slug == "earrings"
			|| $0.slug == "lantsiuzhky"
			|| $0.slug == "tsepochki"
			|| $0.slug == "chains"
			|| $0.slug == "braslety"
			|| $0.slug == "brasletu"
			|| $0.slug == "bracelets"} ?? false
		
		if hasClasp {
			contentView.addSubview(claspView)
			claspView.setupView()
			claspView.snp.makeConstraints { make in
				make.top.equalTo(featureView.snp.bottom).offset(UIConstants.FeatureView.verticalSpacing)
				make.leading.equalToSuperview().offset(UIConstants.FeatureView.horizontalSpacing)
				make.trailing.equalToSuperview().offset(-UIConstants.FeatureView.horizontalSpacing)
				make.height.equalTo(54)
			}
		}
	}
	
	private func configureDeliveryAndPaymentView() {
		contentView.addSubview(deliveryAndPaymentView)
		let bottom = hasClasp ? claspView.snp.bottom : featureView.snp.bottom
		deliveryAndPaymentView.snp.makeConstraints { make in
			make.top.equalTo(bottom).offset(UIConstants.DeliveryAndPaymentView.verticalSpacing)
			make.leading.equalToSuperview().offset(UIConstants.DeliveryAndPaymentView.inset)
			make.trailing.equalToSuperview().offset(-UIConstants.DeliveryAndPaymentView.inset)
		}
	}
	
	private func configureDescriptionView() {
		contentView.addSubview(descriptionView)
		descriptionView.snp.makeConstraints { make in
			make.top.equalTo(deliveryAndPaymentView.snp.bottom).offset(UIConstants.DescriptionView.top)
			make.leading.equalToSuperview().offset(UIConstants.DescriptionView.inset)
			make.trailing.equalToSuperview().offset(-UIConstants.DescriptionView.inset)
		}
	}
	
	private func configureSupportView() {
		contentView.addSubview(supportView)
		supportView.snp.makeConstraints { make in
			make.top.equalTo(deliveryAndPaymentView.snp.bottom).offset(UIConstants.SupportView.top)
			make.leading.equalToSuperview().offset(UIConstants.SupportView.inset)
			make.trailing.equalToSuperview().offset(-UIConstants.SupportView.inset)
		}
	}
	
	private func remakeSeparatorViewUnder(_ topElement: UIView) {
		contentView.addSubview(featureView)
		separatorView.snp.remakeConstraints { make in
			make.height.equalTo(UIConstants.SeparatorView.height)
			make.top.equalTo(topElement.snp.bottom).offset(UIConstants.FeatureView.verticalSpacing)
			make.leading.equalToSuperview().offset(UIConstants.FeatureView.horizontalSpacing)
			make.trailing.equalToSuperview().offset(-UIConstants.FeatureView.horizontalSpacing)
		}
	}
	
	private func configureProductsGroup() {
		productsGroupViewController.productsView = productsGroupView
		productsGroupViewController.setShowMoreTitle(nil)
		productsGroupViewController.delegate = self
		setProductsGroup()
		
		contentView.addSubview(productsGroupView)
		productsGroupView.snp.makeConstraints { make in
			make.top.equalTo(supportView.snp.bottom).offset(UIConstants.ProductsGroup.top)
			make.leading.trailing.equalToSuperview()
		}
	}
	
	private func setProductsGroup() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
		let productsViewModels = associatedProducts.compactMap { ProductTileViewModel(product: $0) }
		let title = !associatedProducts.isEmpty ? Localizator.standard.localizedString("Также покупают") : nil
		productsGroupViewController.setTitle(title)
		productsGroupViewController.setProducts(productsViewModels)
    CATransaction.commit()
	}
	
	private func updateBannerImageView() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
		let productsViewModels = associatedProducts.compactMap { ProductTileViewModel(product: $0) }
		
		var bottomInset = self.delegate?.isFullScreen() ?? false ?
		UIConstants.BottomButtonsView.withoutTabBarHeight :
		UIConstants.BottomButtonsView.withTabBarHeight
		
		bottomInset -= 30
		
		if productsViewModels.isEmpty {
			bannerImageView.snp.remakeConstraints { make in
				make.top.equalTo(supportView.snp.bottom).offset(UIConstants.BannerImageView.top)
				make.leading.trailing.equalTo(contentView).inset(UIConstants.BannerImageView.inset)
				make.height.equalTo(0)
				make.bottom.equalTo(contentView).inset(bottomInset)
			}
		} else {
			bannerImageView.snp.remakeConstraints { make in
				make.top.equalTo(productsGroupView.snp.bottom).offset(UIConstants.BannerImageView.top)
				make.leading.trailing.equalTo(contentView).inset(UIConstants.BannerImageView.inset)
				make.height.equalTo(0)
				make.bottom.equalTo(contentView).inset(bottomInset)
			}
		}
    CATransaction.commit()
	}
	
	private func configureBannerImageView() {
		bannerImageView.contentMode = .scaleAspectFit
		
		contentView.addSubview(bannerImageView)
		bannerImageView.snp.makeConstraints { make in
			make.top.equalTo(productsGroupView.snp.bottom).offset(UIConstants.BannerImageView.top)
			make.leading.trailing.equalToSuperview().inset(UIConstants.BannerImageView.inset)
			make.height.equalTo(0)
			make.bottom.equalToSuperview().inset(UIConstants.BannerImageView.bottom)
		}
		
		bannerImageView.isUserInteractionEnabled = true
		let gesture = UITapGestureRecognizer()
		gesture.addTarget(self, action: #selector(didTapOnBanner))
		bannerImageView.addGestureRecognizer(gesture)
		updateBannerImageViewHeight()
	}
	
	private func configureBottomButtons() {
		let height = self.delegate?.isFullScreen() ?? false ?
		UIConstants.BottomButtonsView.withoutTabBarHeight :
		UIConstants.BottomButtonsView.withTabBarHeight
		
		addSubview(bottomButtonsView)
		bottomButtonsView.snp.makeConstraints { make in
			make.top.equalTo(snp.bottom)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(height)
		}
	}
	
	// MARK: - Interface
	func loadView() {
		configureSelfView()
		configureBanners()
		configureScrollView()
		configureContentView()
		
		configureLineView()
		configureStickersView()
		configureDescribeLabel()
		configureSizeView()
		configureBuyProductView()
		configureNewUserBannerView()
		configureRegisteredUserView()
		configureRegisteredUserBirthdayView()
		configureFeatureView()
		configureDeliveryAndPaymentView()
		configureDescriptionView()
		configureSupportView()
		configureProductsGroup()
		configureBannerImageView()
		configureBottomButtons()
		
		configCollapsedState()
	}
	
	func getBannersView() -> BannersView {
		return bannersView
	}
	
	func getSizeCollectionView() -> UICollectionView {
		return sizeView.getSizeCollectionView()
	}
	
	func getKnowSizeButton() -> UIButton {
		return sizeView.getKnowSizeButton()
	}
	
	func getCurrentOffset() -> CGFloat {
		return scrollView.contentOffset.y - Constants.Screen.topSafeAreaInset
	}
	
	private func configCollapsedState() {
		addCollapseCharachteristicsButtonTarget()
		addCollapseDeliveryButtonTarget()
		addCollapseDescriptionButtonTarget()
	}
	
	func addCollapseCharachteristicsButtonTarget() {
		guard let productId = product?.id else {
			return
		}
		
		if isCollapsedView(productID: productId, collapsedItem: .charachteristics) {
			featureView.getCollapseButton().addTarget(self, action: #selector(uncollapseCharachteristics), for: .touchUpInside)
		} else {
			featureView.getCollapseButton().addTarget(self, action: #selector(collapseCharachteristics), for: .touchUpInside)
		}
	}
	
	@objc private func collapseCharachteristics() {
		featureView.setCollapsedState()
		
		featureView.getCollapseButton().addTarget(self, action: #selector(uncollapseCharachteristics), for: .touchUpInside)
	}
	
	@objc private func uncollapseCharachteristics() {
		featureView.setUncollapsedState()
		
		featureView.getCollapseButton().addTarget(self, action: #selector(collapseCharachteristics), for: .touchUpInside)
	}
	
	func addCollapseDescriptionButtonTarget() {
		guard let _ = product?.id else {
			return
		}
		
		collapseProductDescription()
	}
	
	@objc private func collapseProductDescription() {
		descriptionView.setCollapsedState()
		
		descriptionView.getCollapseButton().addTarget(self, action: #selector(uncollapseProductDescription), for: .touchUpInside)
	}
	
	@objc private func uncollapseProductDescription() {
		descriptionView.setUncollapsedState()
		
		descriptionView.getCollapseButton().addTarget(self, action: #selector(collapseProductDescription), for: .touchUpInside)
	}
	
	func addCollapseDeliveryButtonTarget() {
		guard let productId = product?.id else {
			return
		}
		
		if isCollapsedView(productID: productId, collapsedItem: .delivery) {
			deliveryAndPaymentView.getCollapseButton().addTarget(self, action: #selector(uncollapseDelivery), for: .touchUpInside)
		} else {
			deliveryAndPaymentView.getCollapseButton().addTarget(self, action: #selector(collapseDelivery), for: .touchUpInside)
		}
	}
	
	@objc private func collapseDelivery() {
		deliveryAndPaymentView.setCollapsedState()
		
		deliveryAndPaymentView.getCollapseButton().addTarget(self, action: #selector(uncollapseDelivery), for: .touchUpInside)
	}
	
	@objc private func uncollapseDelivery() {
		deliveryAndPaymentView.setUncollapsedState()
		
		deliveryAndPaymentView.getCollapseButton().addTarget(self, action: #selector(collapseDelivery), for: .touchUpInside)
	}
	
	func addHintViewTarget(_ target: Any, action: Selector) {
		//    hintView.addTarget(target, action: action)
	}
	
	func addCartTarget(_ target: Any, action: Selector) {
		buyProductView.getAddToCartButton.addTarget(target, action: action, for: .touchUpInside)
		bottomButtonsView.getBuyProductButton.addTarget(target, action: action, for: .touchUpInside)
	}
	
	func addCreditTarget(_ target: Any, action: Selector) {
		buyProductView.getBuyWithCreditButton.addTarget(target, action: action, for: .touchUpInside)
	}
	
	func addUserRegistrationTarget(_ target: Any, action: Selector) {
		newUserBannerView.getRegistrationButton().addTarget(target, action: action, for: .touchUpInside)
	}
	
	func addHotLineTarget(_ target: Any?, action: Selector) {
		supportView.addHotLineTarget(target, action: action)
	}
	
	func addSupportSocialDelegate(_ delegate: SupportSocialViewDelegate) {
		supportView.addSupportSocialDelegate(delegate)
	}
	
	private func isInCart(_ variant: Variant) -> Bool {
		let variantInCart = CartService.shared.cart?.cartItems.first(where: { $0.id == variant.id })
		
		return variantInCart != nil
	}
	
	// MARK: - UPDATE UI STATE
	func setupValues(for variant: Variant, socials: [Social]) {
		guard let product = product else { return }
		
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
		self.variant = variant
		updateStickersViewState()
		describeLabel.text = variant.name
		updateSizeViewState()
		buyProductView.updateViewStateWith(variant.price, credits: variant.creditList, isInCart: isInCart(variant))
		updateUserBannerViewStateWith(variant)
		updateFeaturesViewState()
		deliveryAndPaymentView.updateViewStateWith(product.freeDelivery.novaPoshta)
		updateProductDescriptionViewWith(product.description)
		supportView.updateViewStateWith(socials)
		productsGroupViewController.setTitle(Localizator.standard.localizedString("Также покупают"))
		bottomButtonsView.updateViewStateWith(variant.price, isInCart: isInCart(variant))
    
    CATransaction.commit()
	}
	
	private func updateProductDescriptionViewWith(_ descriptionText: String?) {
		if let descriptionText = descriptionText, !descriptionText.isEmpty {
			descriptionView.updateViewStateWith(descriptionText)
			
			supportView.snp.remakeConstraints { make in
				make.top.equalTo(descriptionView.snp.bottom).offset(UIConstants.SupportView.top)
				make.leading.equalToSuperview().offset(UIConstants.SupportView.inset)
				make.trailing.equalToSuperview().offset(-UIConstants.SupportView.inset)
			}
		} else {
			supportView.snp.remakeConstraints { make in
				make.top.equalTo(deliveryAndPaymentView.snp.bottom).offset(UIConstants.SupportView.top)
				make.leading.equalToSuperview().offset(UIConstants.SupportView.inset)
				make.trailing.equalToSuperview().offset(-UIConstants.SupportView.inset)
			}
		}
	}
	
	private func updateStickersViewState() {
		guard let product = product else { return }
		
		if !self.stickersView.getStickersStackView().arrangedSubviews.isEmpty {
			return
		}
		
		if product.price.discount > 0 {
			self.stickersView.getStickersStackView().addArrangedSubview(self.createStickerViewBy(
				.init(
					colorCode: "#FF5F5F",
					title: "-\(product.price.discount)%")))
		}
		
		product.stickers.forEach {
			self.stickersView.getStickersStackView().addArrangedSubview(self.createStickerViewBy($0))
		}
		
		func hideStickersView() {
			describeLabel.snp.remakeConstraints { make in
				make.top.equalTo(lineView.snp.bottom).offset(UIConstants.DescribeLabel.top)
				make.leading.equalToSuperview().offset(UIConstants.DescribeLabel.leading)
				make.trailing.equalToSuperview().inset(UIConstants.DescribeLabel.trailing)
			}
			
			stickersView.isHidden = true
		}
		
		if product.stickers.isEmpty && product.price.discount == 0 {
			hideStickersView()
		}
	}
	
	private func updateSizeViewState() {
		sizeView.updateViewStateWith(variant, product: product)
		
		func hideSizeView() {
			buyProductView.snp.remakeConstraints { make in
				make.left.equalToSuperview().offset(16)
				make.right.equalToSuperview().offset(-16)
				make.top.equalTo(describeLabel.snp.bottom).offset(25)
			}
			sizeView.isHidden = true
		}
		
		if isProductWithoutSizes() {
			if isProductWithoutWeight() {
				hideSizeView()
			} else {
				sizeView.showOnlyWieght(variant)
			}
		}
	}
	
	private func updateUserBannerViewStateWith(_ variant: Variant) {
		hideAllBanners()
		
		guard self.product?.indicative == false else {
			return
		}
		
		if ProfileService.shared.user != nil {
			if ProfileService.shared.isBirthdayPeriod() {
				showRegisteredUserBirthdayBanner(variant)
			} else {
				showRegisteredUserBanner(variant)
			}
		} else {
			showNewUserBanner(variant)
		}
	}
	
	private func hideAllBanners() {
		newUserBannerView.isHidden = true
		registeredUserView.isHidden = true
		registeredUserBirthdayView.isHidden = true
	}
	
	private func showNewUserBanner(_ variant: Variant) {
		newUserBannerView.update(variant.price)
		newUserBannerView.isHidden = false
		
		remakeSeparatorViewUnder(newUserBannerView)
	}
	
	private func showRegisteredUserBanner(_ variant: Variant) {
		registeredUserView.update(variant.price, discount: discountValue())
		registeredUserView.isHidden = false
		
		remakeSeparatorViewUnder(registeredUserView)
	}
	
	private func showRegisteredUserBirthdayBanner(_ variant: Variant) {
		registeredUserBirthdayView.update(variant.price, discount: discountValue())
		registeredUserBirthdayView.isHidden = false
		
		remakeSeparatorViewUnder(registeredUserBirthdayView)
	}
	
	private func discountValue() -> Int {
		if let goldenDiscount = ProfileService.shared.user?.goldDiscount, goldenDiscount != 0 {
			return goldenDiscount
		}
		
		return 3
	}
	
	// MARK: - Private methods
	
	private func isProductWithoutSizes() -> Bool {
		guard let product = product else { return false }
		
		return product.variants.filter { variant -> Bool in
			guard let size = variant.size else { return false }
			return !size.title.isEmpty
		}.isEmpty
	}
	
	private func isProductWithoutWeight() -> Bool {
		return variant?.properties.first(where: { $0.code == "weight_product" })?.title == nil
	}
	
	private func createStickerViewBy(_ sticker: Sticker) -> UIView {
		let stickerView = UIView()
		
		stickerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
		stickerView.layer.cornerRadius = UIConstants.StickersView.cornerRadius
		stickerView.backgroundColor = UIColor(hex: sticker.colorCode)
		
		let stickerLabel = UILabel()
		
		stickerView.addSubview(stickerLabel)
		
		stickerLabel.text = sticker.title
		stickerLabel.setContentHuggingPriority(.required, for: .horizontal)
		
		stickerLabel.config
			.font(sticker.title.contains("%") ? UIConstants.StickersView.fontDiscount : UIConstants.StickersView.font)
			.numberOfLines(UIConstants.StickersView.numberOfLines)
			.textColor(UIConstants.StickersView.textColor)
			.textAlignment(UIConstants.StickersView.textAlignment)
		
		stickerLabel.clipsToBounds = true
		
		stickerLabel.snp.makeConstraints { make in
			make.height.equalTo(UIConstants.StickersView.height)
			make.top.bottom.equalToSuperview()
			make.leading.equalToSuperview().offset(UIConstants.StickersView.leading)
			make.trailing.equalToSuperview().inset(UIConstants.StickersView.trailing)
		}
		
		stickerLabel.sizeToFit()
		
		return stickerView
	}
	
	private func updateFeaturesViewState() {
		guard let product = product,
					let variant = variant
		else { return }
		
		featureView.setCharacteristics(product: product, variant: variant)
		featureView.isHidden = false
		
		if product.properties.isEmpty && variant.properties.isEmpty {
			deliveryAndPaymentView.snp.remakeConstraints { make in
				make.top.equalTo(separatorView.snp.bottom).offset(UIConstants.DeliveryAndPaymentView.verticalSpacing)
				make.leading.equalToSuperview().offset(UIConstants.DeliveryAndPaymentView.inset)
				make.trailing.equalToSuperview().offset(-UIConstants.DeliveryAndPaymentView.inset)
			}
			
			featureView.isHidden = true
		} else {
			let bottom = hasClasp ? claspView.snp.bottom : featureView.snp.bottom
			deliveryAndPaymentView.snp.remakeConstraints { make in
				make.top.equalTo(bottom).offset(UIConstants.DeliveryAndPaymentView.verticalSpacing)
				make.leading.equalToSuperview().offset(UIConstants.DeliveryAndPaymentView.inset)
				make.trailing.equalToSuperview().offset(-UIConstants.DeliveryAndPaymentView.inset)
			}
			
			featureView.isHidden = false
		}
	}
	
	private func getDeliveryContent(product: Product, socials: [Social]) -> DeliveryContent {
		let mainPoints = [
			DeliveryInfoPoint(
				image: #imageLiteral(resourceName: "iconsDeliveryNovaPoshtaSymbol"),
				text: StringComposer.shared.getDeliveryPointEmphasiseString(
					text: Localizator.standard.localizedString("От %d грн в отделение Новой Почты.", product.freeDelivery.novaPoshta),
					emphasise: "\(product.freeDelivery.novaPoshta)")),
			DeliveryInfoPoint(
				image: #imageLiteral(resourceName: "iconsAddressDelivery"),
				text: StringComposer.shared.getDeliveryPointEmphasiseString(
					text: Localizator.standard.localizedString("От %d грн курьером по Киеву.", product.freeDelivery.courierKiev),
					emphasise: "\(product.freeDelivery.courierKiev)"))]
		let deliveryMainInfo =
		DeliveryMainInfo(
			title: Localizator.standard.localizedString("Бесплатная доставка"),
			points: mainPoints,
			
			hint: Localizator.standard.localizedString("* — Узнайте точную информацию при\nоформлении заказа."))
		let blocksContent = [
			BlockContent(
				title: Localizator.standard.localizedString("Упаковка в подарок"),
				points: [Localizator.standard.localizedString("— бесплатно при любой сумме заказа"),
								 Localizator.standard.localizedString("— для всех типов изделий"),
								 Localizator.standard.localizedString("— оригинальный фирменный стиль")] ),
			BlockContent(
				title: Localizator.standard.localizedString("Оплата"),
				points: [Localizator.standard.localizedString("— картой VISA/Mastercard;"),
								 Localizator.standard.localizedString("— наложенным платежом;"),
								 Localizator.standard.localizedString("— наличными при получении в магазине\nили курьеру.")] )]
		let hotLine =
		HotLine(
			title: Localizator.standard.localizedString("Горячая линия"),
			number: ContactsHelper().formattedPhone)
		
		return DeliveryContent(
			main: deliveryMainInfo,
			blocks: blocksContent,
			hotLine: hotLine,
			support: setSupportContent(socials: socials))
	}
	
	private func setSupportContent(socials: [Social]) -> ImageTitleImagesViewModel {
		let viewModel = ImageTitleImagesViewModel(
			title: Localizator.standard.localizedString("Поддержка в мессенджерах"),
			image: nil,
			images: socials.compactMap { ImageViewModel.image($0.image) })
		
		return viewModel
	}
	
	private func updateBottomButtonsView(inset: CGFloat) {
		let height = self.delegate?.isFullScreen() ?? false ?
		UIConstants.BottomButtonsView.withoutTabBarHeight :
		UIConstants.BottomButtonsView.withTabBarHeight
		
		bottomButtonsView.snp.remakeConstraints { make in
			make.top.equalTo(snp.bottom).offset(inset)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(height)
		}
	}
	
	private func updateBannerImageViewHeight() {
		let height = (Constants.Screen.screenWidth - 2 * UIConstants.BannerImageView.inset) * UIConstants.BannerImageView.cellAspect
		bannerImageView.snp.updateConstraints { $0.height.equalTo(banner != nil ? height : 0) }
	}
	
	@objc
	private func didTapOnBanner() {
		guard let banner = banner else { return }
		delegate?.didTapOnBanner(banner)
	}
	
}

// MARK: - UIScrollViewDelegate
extension ProductView: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		delegate?.shouldScroll(
			to: scrollView.contentOffset.y - Constants.Screen.topSafeAreaInset + UIConstants.ContentView.displacement)
		
		let offset = -scrollView.contentOffset.y
		
		let difference =
		scrollView.frame.origin.y -
		buyProductView.frame.origin.y -
		buyProductView.frame.height +
		UIConstants.HintView.top +
		UIConstants.ContentView.topSafeArea
		
		let changes = offset - difference
		
		let height = self.delegate?.isFullScreen() ?? false ?
		UIConstants.BottomButtonsView.withoutTabBarHeight :
		UIConstants.BottomButtonsView.withTabBarHeight
		
		if offset <= difference {
			updateBottomButtonsView(inset: -min(-changes, height))
		} else {
			updateBottomButtonsView(inset: -changes <= height ? 0 : changes)
		}
	}
}

// MARK: - ProductsGroupCellControllerDelegate
extension ProductView: HorizontalProductsGroupCellControllerDelegate {
	func productCellController(_ controller: HorizontalProductsGroupCellController, didSelectProductAt index: Int) {
		guard associatedProducts.indices.contains(index) else { return }
		delegate?.didTapOnAssociatedProduct(associatedProducts[index])
	}
	
	func productCellController(_ controller: HorizontalProductsGroupCellController, didTapOnFavoriteAt index: Int) {
		guard associatedProducts.indices.contains(index) else { return }
		delegate?.didTapOnFavoriteAtAssociatedProduct(associatedProducts[index])
	}
	
	func productCellController(_ controller: HorizontalProductsGroupCellController, didTapOnDiscountHint index: Int) {
		guard controller.products.indices.contains(index) else { return }
		delegate?.didTapOnDiscountHintFor(associatedProducts[index])
	}
	
	func didTapOnShowMore(at controller: HorizontalProductsGroupCellController) { }
}

extension ProductView {
	public enum CollapsedItem: String {
		case charachteristics
		case description
		case delivery
	}
	
	public func setDefaultCollapsionState() {
		guard let productId = self.product?.id else {
			return
		}
		
		saveCollapseValueToUserDefaults(productID: productId, collapsedItem: .charachteristics, value: false)
		saveCollapseValueToUserDefaults(productID: productId, collapsedItem: .description, value: true)
		saveCollapseValueToUserDefaults(productID: productId, collapsedItem: .delivery, value: false)
	}
	
	private func saveCollapseValueToUserDefaults(productID: Int, collapsedItem: CollapsedItem, value: Bool) {
		let key = keyForCollapsedItem(productID: productID, collapsedItem: collapsedItem)
		
		UserDefaults.standard.set(value, forKey: key)
	}
	
	// Чтение Bool значения из NSUserDefaults
	private func isCollapsedView(productID: Int, collapsedItem: CollapsedItem) -> Bool {
		let key = keyForCollapsedItem(productID: productID, collapsedItem: collapsedItem)
		
    if let cachedValue = collapsedStates[key] {
      return cachedValue
    }
    
    let value = UserDefaults.standard.bool(forKey: key)
    collapsedStates[key] = value
    return value
  }
	
	// Удаление Bool значения из NSUserDefaults
	private func removeValueFromUserDefaults(productID: Int, collapsedItem: CollapsedItem) {
		let key = keyForCollapsedItem(productID: productID, collapsedItem: collapsedItem)
		
		UserDefaults.standard.removeObject(forKey: key)
	}
	
	private func keyForCollapsedItem(
		productID: Int,
		collapsedItem: CollapsedItem) -> String {
			return "\(productID)\(collapsedItem.rawValue)"
		}
}

private enum UIConstants {
	enum SelfView {
		static let backgroundColor = UIColor.white
	}
	
	enum ScrollView {
		static let backgroundColor = UIColor.white
	}
	
	enum ContentView {
		static let cornerRadius: CGFloat = 16
		static let shadowRadius: CGFloat = 6.0
		static let shadowOpacity: Float = 0.2
		
		static let shadowColor = UIColor.color(r: 157, g: 164, b: 183)
		static let backgroundColor = UIColor.white
		static let topOffset: CGFloat = Constants.Screen.screenWidth - 1
		
		static let topSafeArea: CGFloat = Constants.Screen.topSafeAreaInset + displacement
		static let displacement: CGFloat = 30
		static let bottomSafeArea: CGFloat = Constants.Screen.bottomSafeAreaInset
	}
	
	enum Banners {
		static let side: CGFloat = 375
		static let defaultCellAspect: CGFloat = 1
	}
	
	enum LineView {
		static let top: CGFloat = 16
		static let radius: CGFloat = 2
		static let width: CGFloat = 48
		static let height: CGFloat = 4
		static let backgroundColor = UIColor.color(r: 196, g: 196, b: 196)
	}
	
	enum DescribeLabel {
		static let height: CGFloat = 21
		static let font: UIFont = UIFont.regularAppFont(of: 16)
		static let color = UIColor.color(r: 62, g: 76, b: 75)
		
		static let top: CGFloat = 16
		static let leading: CGFloat = 16
		static let trailing: CGFloat = 16
	}
	
	enum StickersView {
		static let height: CGFloat = 24
		static let width: CGFloat = 58
		static let cornerRadius: CGFloat = 12
		static let backgroundColor = UIColor.color(r: 255, g: 95, b: 95)
		static let textColor = UIColor.white
		static let fontDiscount = UIFont.aliceRegularFont(of: 18)
		static let font = UIFont.aliceRegularFont(of: 14)
		static let textAlignment = NSTextAlignment.center
		static let numberOfLines = 0
		
		static let leading: CGFloat = 8
		static let trailing: CGFloat = 8
		static let top: CGFloat = 14
	}
	
	enum PriceLabel {
		static let top: CGFloat = 14
	}
	
	enum OldPriceLabel {
		static let leading: CGFloat = 15
		static let bottom: CGFloat = 2
	}
	
	enum SizeView {
		static let top: CGFloat = 28
	}
	
	enum BuyProductView {
		static let height: CGFloat = 54
		static let top: CGFloat = 25
		static let leftRightPadding: CGFloat = 16.0
	}
	
	enum BannerView {
		static let top: CGFloat = 10
		static let leftRightPadding: CGFloat = 16.0
	}
	
	enum CreditButton {
		static let borderColor = UIColor(hex: "#15504A")
		
		static let top: CGFloat = 12
	}
	
	enum HintView {
		static let leading: CGFloat = 16
		static let top: CGFloat = 50
	}
	
	enum FeatureView {
		static let verticalSpacing: CGFloat = 25
		static let horizontalSpacing: CGFloat = 16
	}
	
	enum SeparatorView {
		static let height: CGFloat = 1
		static let color = UIColor(hex: "#E3E3E3")
	}
	
	enum DeliveryAndPaymentView {
		static let verticalSpacing: CGFloat = 25
		static let top: CGFloat = 50
		static let inset: CGFloat = 16
	}
	
	enum DescriptionView {
		static let top: CGFloat = 25
		static let inset: CGFloat = 16
	}
	
	enum SupportView {
		static let top: CGFloat = 25
		static let inset: CGFloat = 16
	}
	
	enum ProductsGroup {
		static let top: CGFloat = 40
	}
	
	enum BannerImageView {
		static let top: CGFloat = 51
		static let inset: CGFloat = 16
		static let bottom: CGFloat = 120
		static let cellAspect: CGFloat = 9.0 / 16.0
	}
	
	enum BottomButtonsView {
		static let withTabBarHeight: CGFloat = 155
		static let withoutTabBarHeight: CGFloat = 86
	}
}
