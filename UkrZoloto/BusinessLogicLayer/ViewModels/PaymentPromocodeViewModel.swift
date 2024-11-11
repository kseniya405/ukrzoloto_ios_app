//
//  PaymentPromocodeViewModel.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 20.11.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation

struct PromocodeInfo {
  var promocode: String
  let promocodeDiscount: String
  let statusBonusString: String?
}

struct PaymentPromocodeViewModel {
  let title: String
  let placeholder: String
  let writeOffButtonTitle: String
  let cancelButtonTitle: String
  let discountTitle: String
  var promocodeInfo: PromocodeInfo?
  let cancelDescription: String
  let isWriteOffVisible: Bool
  let appliedString: String?
  let isActive: Bool
}
