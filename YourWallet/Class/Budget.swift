//
//  Budget.swift
//  YourWallet
//
//  Created by Tran Van Dong on 1/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation

struct Budget{
    var ID:Int!
    var Amount:Double!
    var StartDate:Date!
    var EndDate:Date!
    var ID_Category:Int!
    var ID_Wallet:Int!
}

func GetBudgetsFromSQLite(query: String, database: OpaquePointer?) -> [Budget]{
    var Budgets = [Budget]()
    let dateFormattor = DateFormatter()
    dateFormattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormattor.timeZone = TimeZone.init(abbreviation: "UTC") //Tránh tự động cộng giờ theo vùng
    var queryStatement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
        while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
            var B = Budget()
            if sqlite3_column_text(queryStatement, 0) != nil {
                B.ID = Int(sqlite3_column_int(queryStatement, 0))
            }
            if sqlite3_column_text(queryStatement, 1) != nil {
                B.Amount = Double(sqlite3_column_double(queryStatement, 1))
            }
            if sqlite3_column_text(queryStatement, 2) != nil {
                let strDate = String(cString: sqlite3_column_text(queryStatement, 2))
                B.StartDate = dateFormattor.date(from: strDate)
            }
            if sqlite3_column_text(queryStatement, 3) != nil {
                let strDate = String(cString: sqlite3_column_text(queryStatement, 3))
                B.EndDate = dateFormattor.date(from: strDate)//! + dateFormattor.date(from: "0000:00:00 07:00:00")
            }
            if sqlite3_column_text(queryStatement, 4) != nil {
                B.ID_Category = Int(sqlite3_column_int(queryStatement, 4))
            }
            if sqlite3_column_text(queryStatement, 5) != nil {
                B.ID_Wallet = Int(sqlite3_column_int(queryStatement, 5))
            }
            
            Budgets.append(B)
        }
    }
    return Budgets
}

