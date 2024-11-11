//
//  Gender.swift
//  UkrZoloto
//
//  Created by Mykola on 06.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

enum Gender: String, CaseIterable {
  case undefined
  case male
  case female
  
  var stringRepresentation: String {
    
    switch self {
    case .undefined: return Localizator.standard.localizedString("Не выбран")
    case .male: return Localizator.standard.localizedString("Мужской")
    case .female: return Localizator.standard.localizedString("Женский")
    }
  }
}
