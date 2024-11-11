//
//  Credits.swift
//  UkrZoloto
//
//  Created by Mykola on 22.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Credits {
  
  let monobank: Credit?
  let privatBankCredit: Credit?
  let privatBankInstantInstallment: Credit?
  let alphabank: Credit?
  let globusPlus: Credit?
  let otp: Credit?
  let abank: Credit?
	
  init(json: JSON) {
    self.monobank = Credit(json: json[NetworkResponseKey.Credits.monobank])
    self.privatBankCredit = Credit(json: json[NetworkResponseKey.Credits.privatBank])
    self.privatBankInstantInstallment = Credit(json: json[NetworkResponseKey.Credits.privatBankInstantInstallment])
    self.alphabank = Credit(json: json[NetworkResponseKey.Credits.alphabank])
    self.globusPlus = Credit(json: json[NetworkResponseKey.Credits.globusPlus])
    self.otp = Credit(json: json[NetworkResponseKey.Credits.otp])
    self.abank = Credit(json: json[NetworkResponseKey.Credits.abank])
  }
	
	func getDisplayableCredits(withActiveIcon: Bool = false) -> [DisplayableCredit] {
		let otpInactiveIconName = withActiveIcon ? "otp_active" : "otp_inactive"
		let alphabankInactiveIconName = withActiveIcon ? "alpha_active" : "alpha_inactive"
		let monobankInactiveIconName = withActiveIcon ? "monobank_active" : "monobank_inactive"
		let privatInactiveIconName = withActiveIcon ? "privat_active" : "privat_inactive"
		let privatInstallmentInactiveIconName = withActiveIcon ? "privat_installment_active" : "privat_installment_inactive"
		let abankIconName = withActiveIcon ? "abank_active" : "abank_inactive"
		
		var result = [DisplayableCredit?]()

		if (monobank?.icon) != nil {
			result.append(DisplayableCredit(image: UIImage(named:monobankInactiveIconName)))
		}

		if (privatBankCredit?.icon) != nil {
			result.append(DisplayableCredit(image: UIImage(named:privatInactiveIconName)))
		}

		if (abank?.icon) != nil {
			result.append(DisplayableCredit(image: UIImage(named:abankIconName)))
		}
		
		if (alphabank?.icon) != nil {
			result.append(DisplayableCredit(image: UIImage(named:alphabankInactiveIconName)))
		}
		
		if (privatBankInstantInstallment?.icon) != nil {
			result.append(DisplayableCredit(image: UIImage(named:privatInstallmentInactiveIconName)))
		}
		if (otp?.icon) != nil {
			result.append(DisplayableCredit(image: UIImage(named:otpInactiveIconName)))
		}
		return result.compactMap({$0})
	}
}

struct DisplayableCredit {
  let icon: String?
	let image: UIImage?

	init?(icon: String? = nil, image: UIImage? = nil) {
		self.icon = icon
		self.image = image
	}
}

extension Credits {
  
  struct Credit {
		let icon: String?

    init?(json: JSON) {
			icon = json[NetworkResponseKey.Credits.icon].string
    }
  }
}
