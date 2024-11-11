//
//  RetenoAnalyticsService.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 30.01.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import Foundation
import Reteno

class RetenoAnalyticsService {
  
  class func logViewItem(_ product: Product) {
    let product = Ecommerce.Product(
      productId: product.sku,
      price: Float(truncating: product.price.current as NSNumber),
      isInStock: product.isAvailable)

    Reteno.ecommerce().logEvent(type: .productViewed(product: product, currencyCode: nil))
  }

  class func logViewCategory(_ categoryId: String) {
    let productCategory = Ecommerce.ProductCategory(productCategoryId: categoryId)

    Reteno.ecommerce().logEvent(type: .productCategoryViewed(category: productCategory))
  }

  class func logItemAddedToWishlist(_ productSku: String, price: Decimal) {
    let product = Ecommerce.Product(
      productId: productSku,
      price: Float(truncating: price as NSNumber),
      isInStock: true)

    Reteno.ecommerce().logEvent(type: .productAddedToWishlist(product: product, currencyCode: nil))
  }

  class func logEditCart(_ cart: Cart) {
    let products = cart.cartItems.map {
      Ecommerce.ProductInCart(
        productId: $0.sku,
        price: Float(truncating: $0.price.current as NSNumber),
        quantity: 1)
    }

    Reteno.ecommerce().logEvent(
      type: .cartUpdated(
        cartId: getCartId(),
        products: products,
        currencyCode: nil))
  }

  class func logSuccessOrder(successOrder: Order) {
    let user = ProfileService.shared.user

    let order = Ecommerce.Order(
      externalOrderId: String(successOrder.number),
      totalCost: Float(truncating: successOrder.totalPrice as NSNumber),
      status: .INITIALIZED,
      date: Date(),
      cartId: self.getCartId(),
      email: user?.email,
      phone: user?.phone,
      firstName: user?.name,
      lastName: user?.surname,
      items: self.orderItemsFrom(successOrder))

    self.clearCartId()

    Reteno.ecommerce().logEvent(type: .orderCreated(order: order, currencyCode: nil))
  }

  private class func orderItemsFrom(_ successOrder: Order) -> [Ecommerce.Order.Item] {
    successOrder.products.map {
      Ecommerce.Order.Item(
        externalItemId: $0.sku,
        name: $0.name,
        category: $0.categoryExternalId ?? "",
        quantity: 1,
        cost: Float(truncating: $0.price.current as NSNumber),
        url: "https://ukrzoloto.ua/uk/",
        imageUrl: nil,
        description: nil)
    }
  }

  class func logSearch(_ search: String, isFound: Bool) {
    Reteno.ecommerce().logEvent(type: .searchRequest(query: search, isFound: isFound))
  }

  class func clearCartId() {
    let userDefaults = UserDefaults.standard

    userDefaults.removeObject(forKey: "cartId")
  }

  private class func getCartId() -> String {
    let userDefaults = UserDefaults.standard

    if let existingCartId = userDefaults.string(forKey: "cartId") {
      return existingCartId
    } else {
      let newCartId = UUID().uuidString

      userDefaults.set(newCartId, forKey: "cartId")

      return newCartId
    }
  }
  
  class func logUniversalLinkEvent(params: [String: String]) {
    let parameters = params.map({ Event.Parameter(name: $0.key, value: $0.value) })
    Reteno.logEvent(
        eventTypeKey: "univers_link_event",
        date: Date(),
        parameters: parameters,
        forcePush: false
    )
  }
}
