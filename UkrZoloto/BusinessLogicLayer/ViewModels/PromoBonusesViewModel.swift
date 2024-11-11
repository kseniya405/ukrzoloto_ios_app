//
//  PromoBonusesViewModel.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 25.11.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation

struct ResultPromoViewModel {
  let title: String
  let descriptionTitle: String
  let cancelButton: String
}

struct PromoBonusesViewModel {
  let title: NSAttributedString
  let writeOffButtonTitle: String
  let resultVM: ResultPromoViewModel?
  let isActive: Bool
}

