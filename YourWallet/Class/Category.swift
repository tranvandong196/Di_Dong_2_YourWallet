//
//  Category.swift
//  YourWallet
//
//  Created by Tran Van Dong on 1/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation

struct Category {
    var ID:Int!
    var Name:String!
    var Kind:Int!
    var Icon:String!
}
func GetCategoriesFromSQLite(query: String, database: OpaquePointer?) -> [Category]{
    var Categories = [Category]()
    var queryStatement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
        while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
            var C = Category()
            if sqlite3_column_text(queryStatement, 0) != nil {
                C.ID = Int(sqlite3_column_int(queryStatement, 0))
            }
            if sqlite3_column_text(queryStatement, 1) != nil {
                C.Name = String(cString: sqlite3_column_text(queryStatement, 1))
            }
            if sqlite3_column_text(queryStatement, 2) != nil {
                C.Kind = Int(sqlite3_column_double(queryStatement, 2))
            }
            if sqlite3_column_text(queryStatement, 3) != nil {
                C.Icon = String(cString: sqlite3_column_text(queryStatement, 3))
            }
            
            Categories.append(C)
        }
    }
    return Categories
}
