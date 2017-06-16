//
//  Wallet.swift
//  YourWallet
//
//  Created by Tran Van Dong on 1/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation

struct Wallet {
    var ID:Int!
    var Name:String!
    var Currency:String!
    var Amount:Double!
    var Balance:Double!
    var Icon:String!
}

func GetWalletsFromSQLite(query: String, database: OpaquePointer?) -> [Wallet]{
    var Wallets = [Wallet]()
    var queryStatement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
        while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
            var W = Wallet()
            if sqlite3_column_text(queryStatement, 0) != nil {
                W.ID = Int(sqlite3_column_int(queryStatement, 0))
            }
            if sqlite3_column_text(queryStatement, 1) != nil {
                W.Name = String(cString: sqlite3_column_text(queryStatement, 1))
            }
            if sqlite3_column_text(queryStatement, 2) != nil {
                W.Currency =  String(cString: sqlite3_column_text(queryStatement, 2))
            }
            if sqlite3_column_text(queryStatement, 3) != nil {
                W.Amount = Double(sqlite3_column_double(queryStatement, 3))
            }
            if sqlite3_column_text(queryStatement, 4) != nil {
                W.Balance = Double(sqlite3_column_double(queryStatement, 4))
            }
            if sqlite3_column_text(queryStatement, 5) != nil {
                W.Icon = String(cString: sqlite3_column_text(queryStatement, 5))
            }
            
            Wallets.append(W)
        }
    }
    return Wallets
}
