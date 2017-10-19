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

extension BinaryInteger {
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
    var floatValue: Float {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.floatValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
    var doubleValue: Double {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.doubleValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
    
}
// http://www.globalnerdy.com/2016/08/30/how-to-work-with-dates-and-times-in-swift-3-part-4-adding-swift-syntactic-magic/
func +(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
    return combineComponents(lhs, rhs)
}

func -(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
    return combineComponents(lhs, rhs, multiplier: -1)
}

func combineComponents(_ lhs: DateComponents,
                       _ rhs: DateComponents,
                       multiplier: Int = 1)
    -> DateComponents {
        var result = DateComponents()
        result.second     = (lhs.second     ?? 0) + (rhs.second     ?? 0) * multiplier
        result.minute     = (lhs.minute     ?? 0) + (rhs.minute     ?? 0) * multiplier
        result.hour       = (lhs.hour       ?? 0) + (rhs.hour       ?? 0) * multiplier
        result.day        = (lhs.day        ?? 0) + (rhs.day        ?? 0) * multiplier
        result.weekOfYear = (lhs.weekOfYear ?? 0) + (rhs.weekOfYear ?? 0) * multiplier
        result.month      = (lhs.month      ?? 0) + (rhs.month      ?? 0) * multiplier
        result.year       = (lhs.year       ?? 0) + (rhs.year       ?? 0) * multiplier
        return result
}

// (Previous code goes here)
// (Previous code goes here)

prefix func -(components: DateComponents) -> DateComponents {
    var result = DateComponents()
    if components.second     != nil { result.second     = -components.second! }
    if components.minute     != nil { result.minute     = -components.minute! }
    if components.hour       != nil { result.hour       = -components.hour! }
    if components.day        != nil { result.day        = -components.day! }
    if components.weekOfYear != nil { result.weekOfYear = -components.weekOfYear! }
    if components.month      != nil { result.month      = -components.month! }
    if components.year       != nil { result.year       = -components.year! }
    return result
}
// (Previous code goes here)

// Date + DateComponents
func +(_ lhs: Date, _ rhs: DateComponents) -> Date
{
    return Calendar.current.date(byAdding: rhs, to: lhs)!
}

// DateComponents + Dates
func +(_ lhs: DateComponents, _ rhs: Date) -> Date
{
    return rhs + lhs
}

// Date - DateComponents
func -(_ lhs: Date, _ rhs: DateComponents) -> Date
{
    return lhs + (-rhs)
}

func -(_ lhs: Date, _ rhs: Date) -> DateComponents
{
    return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                           from: lhs,
                                           to: rhs)
}

extension Int {
    
    var second: DateComponents {
        var components = DateComponents()
        components.second = self;
        return components
    }
    
    var seconds: DateComponents {
        return self.second
    }
    
    var minute: DateComponents {
        var components = DateComponents()
        components.minute = self;
        return components
    }
    
    var minutes: DateComponents {
        return self.minute
    }
    
    var hour: DateComponents {
        var components = DateComponents()
        components.hour = self;
        return components
    }
    
    var hours: DateComponents {
        return self.hour
    }
    
    var day: DateComponents {
        var components = DateComponents()
        components.day = self;
        return components
    }
    
    var days: DateComponents {
        return self.day
    }
    
    var week: DateComponents {
        var components = DateComponents()
        components.weekOfYear = self;
        return components
    }
    
    var weeks: DateComponents {
        return self.week
    }
    
    var month: DateComponents {
        var components = DateComponents()
        components.month = self;
        return components
    }
    
    var months: DateComponents {
        return self.month
    }
    
    var year: DateComponents {
        var components = DateComponents()
        components.year = self;
        return components
    }
    
    var years: DateComponents {
        return self.year
    }
    
}


extension DateComponents {
    
    var fromNow: Date {
        return Calendar.current.date(byAdding: self,
                                     to: Date())!
    }
    
    var ago: Date {
        return Calendar.current.date(byAdding: -self,
                                     to: Date())!
    }
    
}

extension Date {
    init(utcDate:String, dateFormat:String="yyyy-MM-dd HH:mm:ss.SSS+00:00") {
        // 2016-06-06 00:24:21.164493+00:00
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        
        let date = dateFormatter.date(from: utcDate)!
        let s = TimeZone.current.secondsFromGMT(for: date)
        let timeInterval = TimeInterval(s)
        
        self.init(timeInterval: timeInterval, since: date)
    }
    var current:Date {
        return self.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT(for: Date())))
    }
}
