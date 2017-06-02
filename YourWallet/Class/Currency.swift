//
//  Currency.swift
//  YourWallet
//
//  Created by Tran Van Dong on 1/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation

struct Currency {
    var ID:String!
    var Symbol:String!
    var Name: String!
    var ExchangeRate:Double!
}

func GetCurrenciesFromSQLite(query: String, database: OpaquePointer?) -> [Currency]{
    var Currencies = [Currency]()
    var queryStatement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
        while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
            var cur = Currency()
            if sqlite3_column_text(queryStatement, 0) != nil {
                cur.ID = String(cString: sqlite3_column_text(queryStatement, 0))
            }
            if sqlite3_column_text(queryStatement, 1) != nil {
                cur.Symbol = String(cString: sqlite3_column_text(queryStatement, 1))
            }
            if sqlite3_column_text(queryStatement, 2) != nil {
                cur.Name =  String(cString: sqlite3_column_text(queryStatement, 2))           }
            if sqlite3_column_text(queryStatement, 3) != nil {
                cur.ExchangeRate = Double(sqlite3_column_double(queryStatement, 3))
            }
            
            Currencies.append(cur)
        }
    }
    return Currencies
}
