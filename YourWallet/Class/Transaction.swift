//
//  Transaction.swift
//  YourWallet
//
//  Created by Tran Van Dong on 1/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
struct Transaction{
    var ID:Int!
    var Name:String!
    var Amount:Double!
    var Time:Date!
    var ID_Category:Int!
    var ID_Wallet:Int!
    
}
func GetTransactionsFromSQLite(query: String, database: OpaquePointer?) -> [Transaction]{
    var Transactions = [Transaction]()
    let dateFormattor = DateFormatter()
    dateFormattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormattor.timeZone = TimeZone.init(abbreviation: "UTC") //Tránh tự động cộng giờ theo vùng
    var queryStatement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
        while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
            var T = Transaction()
            if sqlite3_column_text(queryStatement, 0) != nil {
                T.ID = Int(sqlite3_column_int(queryStatement, 0))
            }
            if sqlite3_column_text(queryStatement, 1) != nil {
                T.Name = String(cString: sqlite3_column_text(queryStatement, 1))
            }
            if sqlite3_column_text(queryStatement, 2) != nil {
                T.Amount = Double(sqlite3_column_double(queryStatement, 2))            }
            if sqlite3_column_text(queryStatement, 3) != nil {
                let strDate = String(cString: sqlite3_column_text(queryStatement, 3))
                T.Time = dateFormattor.date(from: strDate)
            }
            if sqlite3_column_text(queryStatement, 4) != nil {
                T.ID_Category = Int(sqlite3_column_int(queryStatement, 4))
            }
            if sqlite3_column_text(queryStatement, 5) != nil {
                T.ID_Wallet = Int(sqlite3_column_int(queryStatement, 5))
            }
            
            Transactions.append(T)
        }
    }
    return Transactions
}
