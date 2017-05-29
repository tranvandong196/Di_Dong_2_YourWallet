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
var oldExRate:Double = 22667.99
var ExRate:Double = 22667.99
extension Double{
    var VNDToUSD:Double{
        return (self/ExRate).roundTo(places: 1)
    }
    var USDToVND:Double{
        return (self*ExRate/1000).roundTo(places: 0)*1000
    }
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func getCurrencyValue(Currency: String)->(Double,String){
        switch Currency {
        case "USD":
            return (self.VNDToUSD,"$")
        case "USDVND":
            return (self.USDToVND,"đ")
        default:
            return (self,"đ")
        }
    }
    func toCurrencyString(Currency: String)->String{
        if Currency == "VNĐ"{
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

