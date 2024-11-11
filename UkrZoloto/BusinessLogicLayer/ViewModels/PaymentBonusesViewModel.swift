//
//  PaymentBonusesViewModel.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 30.04.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation

struct PaymentBonusesViewModel {
  let title: String
  let buttonTitle: String
  let isWriteOffActive: Bool
  let bonusInfo: BonusInfo?
  let writeOffVM: WriteOffViewModel
  let isWriteOffVisible: Bool
  let isFreezedBonuses: Bool
  let maxBonusesCount: Int
  let isRestricted: Bool
}

struct WriteOffViewModel {
  let placeholder: String
  let writeOffButtonTitle: String
  let cancelButtonTitle: String
  
  let bonusInfo: BonusInfo?
}

struct BonusInfo {
  let isWrittenOff: Bool
  
  let bonus: String
  
  let cancelTitle: String
  
  let acceptedBonuses: String
  let resultTitleString: String
}
