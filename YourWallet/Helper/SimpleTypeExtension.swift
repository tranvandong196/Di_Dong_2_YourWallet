//
//  SimpleTypeExtension.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/19/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
// MARK: *** Interger
//Setup NumberFormatter: Int 1250000 --> to String: 1.250.000
struct Number {
    static let formatterWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Integer {
    var stringFormattedWithSeparator: String {
        return Number.formatterWithSeparator.string(for: self) ?? ""
    }
}
var VNDCurrency:Currency? = nil
extension Double{
    func toVND(ExchangeRate: Double) -> Double{
        return (self*VNDCurrency!.ExchangeRate/(ExchangeRate)).roundTo(places: 0)
    }
    func VNDtoCurrency(ExchangeRate: Double) -> Double{
        return (self*ExchangeRate/VNDCurrency!.ExchangeRate).roundTo(places: 2)
    }
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func toCurrencyFormatter(CurrencyID: String)->String{
        if CurrencyID == "VND"{
            return Int(self).stringFormattedWithSeparator
        }
        
        return String(self)
    }
}

// MARK: *** String
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    func trim(_ characterSetIn: String) -> String {
        let cs = CharacterSet.init(charactersIn: characterSetIn)
        return self.trimmingCharacters(in: cs)
    }
    
}

