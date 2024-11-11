//
//  FullPaymentViewModel.swift
//  UkrZoloto
//
//  Created by Andrew on 8/26/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class FullPaymentViewModel {
  
  // MARK: - Public variables
  let id: Int
  let title: String
  let hasAdditionalInfo: Bool
  
  var isSelected: Bool
  
  init(payment: PaymentMethod,
       isSelected: Bool) {
    id = payment.id
    title = payment.title
    hasAdditionalInfo = payment.code == .liqpay
    self.isSelected = isSelected
  }
}

extension FullPaymentViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: FullPaymentViewModel, rhs: FullPaymentViewModel) -> Bool {
    return lhs.id == rhs.id
  }
}

