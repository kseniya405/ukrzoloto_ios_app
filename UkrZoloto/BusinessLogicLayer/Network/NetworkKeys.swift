//
//  NetworkKeys.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum NetworkResponseKey {
  static let data = "data"
  
  enum Error {
    static let error = "error"
    static let title = "title"
    static let detail = "detail"
    static let newToken = "new_token"
    static let code = "code"
  }
  
  enum Pagination {
    static let pagination = "pagination"
    static let count = "count"
    static let currentPage = "current_page"
    static let lastPage = "last_page"
    static let perPage = "per_page"
    static let total = "total"
  }
  
  enum Banner {
    static let banners = "banners"
    static let id = "id"
    static let title = "title"
    static let image = "image"
    static let categoryId = "categoryId"
    static let superprice = "superprice"
    static let categoryExternalId = "categoryExternalId"
  }

  enum Inusrence {
    static let price = "price"
    static let price_format = "price_format"
  }
  
  enum Product {
    static let goods = "goods"
    static let id = "id"
    static let name = "name"
    static let slug = "slug"
    static let sku = "sku"
    static let availability = "availability"
    static let isFavorite = "isFavorite"
    static let isCredit = "isCredit"
    static let images = "images"
    static let image = "mainImage"
    static let price = "price"
    static let quantity = "quantity"
    static let categories = "categories"
    static let description = "description"
    static let properties = "properties"
    static let variants = "variants"
    static let size = "size"
    static let freeDelivery = "freeDelivery"
    static let inCart = "inCart"
    static let stickers = "labels"
    
    static let novelties = "novelties"
    static let salesHits = "salesHits"
    static let discounts = "discounts"
    static let bestsellers = "bestsellers"
    static let compilation = "compilation"
    static let certificates = "certificates"
    static let credits = "credits"
    static let indicative = "indicative"
		static let creditList = "creditList"
  }
  
  enum Price {
    static let current = "current"
    static let old = "old"
    static let discountPercent = "discountPercent"
  }
  
  enum FreeDelivery {
    static let novaPoshta = "novaPoshta"
    static let courierKiev = "courierKiev"
  }
  
  enum Credits {
    static let abank = "credit_abank"
    static let otp = "otp_bank"
    static let monobank = "monobank"
    static let privatBank = "credit_privat_bank"
    static let privatBankInstantInstallment = "credit_privat_instant_installment"
    static let alphabank = "credit_alfabank"
    static let globusPlus = "credit_globus_plus"
    static let icon = "icon"
    static let month = "month"
    static let comission = "commission"
    static let description = "description"
    static let title = "title"
    static let code = "code"
    static let data = "data"
    static let creditList = "creditList"
		static let showAsIcon = "show_as_icon"
  }
  
  enum Category {
    static let id = "id"
    static let name = "name"
    static let slug = "slug"
    static let description = "description"
    static let image = "image"
    static let categories = "categories"
    static let children = "children"
    static let categoryExternalId = "categoryExternalId"
  }
  
  enum Property {
    static let code = "code"
    static let name = "name"
    static let title = "title"
  }

  enum Sticker {
    static let colorCode = "color"
    static let title = "title"
  }

  
  enum City {
    static let cities = "cities"
    static let id = "id"
    static let title = "title"
    static let shops = "shops"
  }
  
  enum Shop {
    static let id = "id"
    static let address = "address"
    static let schedule = "schedule"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let city = "city"
    static let status = "status"
  }
  
  enum Schedule {
    static let from = "from"
    static let to = "to"
  }
  
  enum Subcategory {
    static let categoryId = "categoryId"
    static let name = "name"
    static let image = "image"
    static let filters = "filters"
    static let categoryExternalId = "categoryExternalId"
  }
  
  enum Cart {
    static let cart = "cart"
    static let total = "total"
		static let amountExchange = "amountExchange"
  }
  
  enum CartItem {
    static let id = "id"
    static let name = "name"
    static let price = "price"
    static let image = "image"
    static let size = "size"
    static let parentProduct = "parent_product"
    static let sku = "sku"
    static let categoryExternalId = "categoryExternalId"
  }
  
  enum Delivery {
    static let id = "id"
    static let code = "code"
    static let title = "title"
    static let description = "description"
    static let type = "type"
    static let address = "address"
    static let location = "location"
    static let locations = "locations"
    static let subLocations = "subLocations"
    static let payments = "payments"
    static let minPriceActivated = "minPriceActivated"
    enum DeliveryCode {
      static let selfDelivery = "self"
      static let address = "address"
      static let novaPoshtaLocation = "novaposhta_warehouse"
      static let novaPoshtaAddress = "novaposhta_courier"
      static let novaPoshtaParcelLockers = "novaposhta_parcel_lockers"
    }
  }
  
  enum Payment {
    static let id = "id"
    static let code = "code"
    static let title = "title"
    static let description = "description"
    static let type = "type"
    static let credit = "credit"
    static let comission = "commission"
    static let month = "month"
  }
  
  enum Filter {
    static let filters = "filter"
    static let id = "id"
    static let type = "type"
    static let title = "title"
  }
  
  enum RangeFilter {
    static let type = "range"
    static let max = "max"
    static let min = "min"
    static let minPrice = "min-price"
    static let maxPrice = "max-price"
  }
  
  enum SelectFilter {
    static let type = "select"
    static let variants = "variants"
  }
  
  enum FilterVariant {
    static let id = "id"
    static let slug = "slug"
    static let value = "value"
    static let active = "active"
    static let status = "status"
    static let typeSelect = "type-select"
  }
  
  enum Order {
    static let id = "id"
    static let delivery = "delivery"
    static let goods = "goods"
    static let number = "number"
    static let total = "total"
    static let status = "status"
    static let payment = "payment"
  }
  
  enum DeliveryInfo {
    static let title = "title"
    static let type = "type"
  }
  
  enum PaymentInfo {
    static let title = "title"
    static let isPayed = "is_payed"
    static let type = "type"
    static let paymentUrl = "payment_url"
    static let redirectUrl = "redirect_url"
  }
  
  enum Auth {
    static let authToken = "authToken"
    static let userExist = "userExist"
    static let jwt = "jwt"
    static let userId = "user_id"
    static let showUserForm = "showUserForm"
    static let profile = "profile"
  }
  
  enum User {
    static let profile = "profile"
    static let id = "id"
    static let name = "name"
    static let surname = "surname"
    static let telephoneNumber = "telephoneNumber"
    static let email = "email"
    static let birthday = "birthday"
    static let discountCard = "discountCard"
    static let bonus = "bonus"
    static let marketingBonus = "marketing_bonus"
    static let gender = "gender"
  }
  
  enum Contacts {
    static let social = "social"
    static let messenger = "social_mobile.messenger"
    static let instagram = "social_mobile.instagram"
    static let viber = "social_mobile.viber"
    static let apple_chat = "social_mobile.apple_chat"
    static let telegram_bot = "social_mobile.telegram_bot"
    static let callCenter = "call_center"
    static let weekday = "main.weekdays_schedule"
    static let weekend = "main.weekend_schedule"
    static let phone = "main.phone"
  }
  
  enum DiscountCard {
    static let cardNumber = "cardNumber"
    static let discountGold = "discountGold"
    static let discountSilver = "discountSilver"
  }
  
  enum CategoryPush {
    static let categoryId = "categoryId"
    static let categoryName = "categoryName"
  }
  
  enum ProductPush {
    static let productId = "productId"
    static let productName = "productName"
  }
  
  enum CartPriceDetails {
    static let promocodHave = "promocodHave"
    static let statusBonus = "statusBonus"
    static let amountBonus = "amountBonus"
    static let error = "error"
    static let totals = "totals"
    static let goods = "goods"
    static let artikul = "artikul"
    static let amountFullPrice = "amountFullPrice"
    static let amountCatalogDiscount = "amountCatalogDiscount"
    static let amountOrder = "amountOrder"
    static let amountDiscont = "amountDiscont"
    static let amountPromo = "amountPromo"
    static let appliedBonus = "appliedBonus"
    static let appliedPromoBonus = "appliedPromoBonus"
    static let amountOrderWithDiscounts = "amountOrderWithDiscounts"
    static let pricePromo = "pricePromo"
    static let priceDiscont = "priceDiscont"
    static let amountOrderForCredits = "amountOrderForCredits"
    static let amountBirthdayDiscont = "amountBirthdayDiscont"
    static let promoBonus = "promoBonus"
    static let cashback = "cashback"
    static let amountMarketingDiscount = "amountMarketingDiscount"
    static let statusPromoBonus = "statusPromoBonus"
		static let amountExchange = "amountExchange"
		static let code = "code"
		static let options = "options"
		static let services = "services"
		static let price = "price"
		static let selected = "selected"
		static let defaultKey = "default"
  }
  
  enum PromotionalBonuses {
    static let amountBonus = "amountBonus"
  }

  enum DeeplinkPush {
    static let urlScheme = "urlScheme"
  }

  enum Favorites {
    static let favorites = "favorites"
  }
	
	enum NewShops {
		static let items = "items"
		static let filter = "filter"
		static let cities = "cities"
		static let coordinates = "coordinates"
	}
	
	enum NewFilter {
		static let filterOpen = "open"
		static let jeweler = "jeweler"
	}
	
	enum NewShopsItem {
		static let id = "id"
		static let title = "title"
		static let image = "image"
		static let cityName = "city_name"
		static let coordinates = "coordinates"
		static let jeweler = "jeweler"
		static let temporaryClose = "temporary_close"
		static let schedule = "schedule"
		static let openAt = "open_at"
		static let closedAt = "closed_at"
	}
	
	enum NewSchedule {
		static let monday = "monday"
		static let tuesday = "tuesday"
		static let wednesday = "wednesday"
		static let thursday = "thursday"
		static let friday = "friday"
		static let saturday = "saturday"
		static let sunday = "sunday"
	}
	
	enum Day {
		static let dayOpen = "open"
		static let closed = "closed"
		static let timeRange = "time_range"
		static let dayOff = "day_off"
	}
}

enum NetworkRequestKey {
  
  static let data = "data"
  static let acceptLanguage = "accept-language"
  static let authorization = "Authorization"
  static let accept = "Accept"
  static let contentType = "Content-Type"
  
  enum Cart {
    static let variantId = "product_variant_id"
    static let locationId = "locationId"
    static let options = "options"
		static let code = "code"
		static let exchange = "exchange"
  }
  
  enum Filter {
    static let subcategoryId = "subcategoryId"
    static let page = "page"
    static let sort = "sort"
    static let minPrice = "min-price"
    static let maxPrice = "max-price"
  }
  
  enum Search {
    static let searchText = "searchText"
    static let page = "page"
  }
  
  enum Order {
    enum Profile {
      static let profile = "profile"
      static let name = "name"
      static let surname = "surname"
      static let telephoneNumber = "telephoneNumber"
      static let email = "email"
      static let shippingMethod = "shipping_method"
      static let platform = "platform"
      static let appInstanceId = "app_instance_id"
			static let sessionId = "session_id"
    }
    
    enum Delivery {
      static let delivery = "delivery"
      static let type = "type"
      static let data = "data"
      static let city = "city"
      static let warehouse = "warehouse"
      static let deliveryAddress = "delivery_address"
    }
    
    enum Payment {
      static let payment = "payment"
      static let type = "type"
      static let data = "data"
      static let comment = "comment"
    }
    
    enum Bonuses {
      static let bonus = "bonus"
      static let sumToPayFromBonus = "sum_to_pay_from_bonus"
      static let marketingBonus = "marketing_bonus"
    }
    
    enum Price {
      static let coupon = "coupon"
      static let bonus = "bonus"
      static let marketingBonus = "marketing_bonus"
      static let payment = "payment"
    }
    
    static let doNotCallBack = "doNotCallBack"
    static let coupon = "coupon"
  }
  
  enum Auth {
    static let data = "data"
    static let telephoneNumber = "telephoneNumber"
    static let authToken = "authToken"
    static let code = "code"
  }
  
  enum User {
    static let name = "name"
    static let surname = "surname"
    static let email = "email"
    static let birthday = "birthday"
    static let profile = "profile"
    static let gender = "gender"
  }
  
  enum Gift {
    static let forName = "for_name"
    static let forEmail = "for_email"
    static let forPhone = "for_phone"
    static let fromName = "from_name"
    static let fromEmail = "from_email"
    static let fromPhone = "from_phone"
    static let image = "image"
    static let productId = "product_id"
  }

  enum Favorites {
    static let productId = "product_id"
  }
}

