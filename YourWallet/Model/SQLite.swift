//
//  SQLite.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
import  UIKit
// MARK: *** Global Variable

let DBName = "YourWallet-DB"
let DBType = "sqlite"

// MARK: *** SQLite3 function

func Copy_DB_To_DocURL(dbName:String, type:String){
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let storePath : String = documentURL.appendingPathComponent("\(dbName).\(type)").path
    let dbPath = Bundle.main.path(forResource: dbName , ofType:type)!
    do {
        try FileManager.default.copyItem(atPath: dbPath, toPath: storePath)
    } catch{
        //print("File exists! Can not copy file")
    }
    print("\nDatabase has been stored at: \(storePath)\n\n")
}
//Database pointer
func Connect_DB_SQLite( dbName:String, type:String)->OpaquePointer{
    var database:OpaquePointer? = nil
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let storePath : String = documentURL.appendingPathComponent("\(dbName).\(type)").path
    if sqlite3_open(storePath, &database) == SQLITE_OK{
        print("Opened < \(dbName).\(type) > from storePath")
    }else{
        sqlite3_close(database)
        print("Failed to open database -> Created \(dbName).\(type) but it wasn't set a valid structure/table!")
        //createdTable(database: database, query: String) to create any table
    }
    
    return database!
}
func Query(Sql: String, database:OpaquePointer?)-> Bool{
    var result:Bool = false
    var Statement : OpaquePointer? = nil
    if sqlite3_prepare_v2(database, Sql, -1, &Statement, nil) == SQLITE_OK{
        if sqlite3_step(Statement) == SQLITE_DONE{
            result = true
        }else{
            result = false
        }
    }else{
        print("Edit statement could not be prepared.")
        result = false
    }
    sqlite3_finalize(Statement)
    return result
}

// MARK: *** Tran Van Dong



//func addRow(_ T: Table){
//    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
//    let query = "INSERT INTO BanAn VALUES(\(T.SoBan!),\(T.TinhTrang!),'\(T.HinhAnh!)','\(T.GhiChu!)',\(T.MaKV!),null)"
//    print(query)
//    if edit(query: query){
//        print("Thêm bàn số \(T.SoBan!)")
//    }else{
//        print("Không thể thêm bàn số \(T.SoBan!)")
//    }
//    sqlite3_close(database)
//}
//func addRow(_ F: Food){
//    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
//    let query = "INSERT INTO MonAn VALUES(null,'\(F.TenMon!)', \(F.Gia!), '\(F.HinhAnh!)','\(F.MoTa!)', \(F.Loai!), '\(F.Icon!)')"
//    print(query)
//    if edit(query: query){
//        print("Thêm món: \(F.TenMon!)")
//    }else{
//        print("Không thể thêm món: \(F.TenMon!)")
//    }
//    sqlite3_close(database)
//}
//func updateRow( _ T: Table){
//    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
//    var query = ""
//    if (T.MaHD != nil){
//        query = "UPDATE BanAn SET TinhTrang = \(T.TinhTrang!), HinhAnh = '\(T.HinhAnh!)', GhiChu = '\(T.GhiChu!)', MaKV = \(T.MaKV!), MaHD = \(T.MaHD!) WHERE SoBan = \(T.SoBan!)"
//    }
//    else{
//        query = "UPDATE BanAn SET TinhTrang = \(T.TinhTrang!), HinhAnh = '\(T.HinhAnh!)', GhiChu = '\(T.GhiChu!)', MaKV = \(T.MaKV!), MaHD = null WHERE SoBan = \(T.SoBan!)"
//
//    }
//    print(query)
//    if edit(query: query){
//        print("Cập nhât bàn số \(T.SoBan!)")
//    }else{
//        print("Không thể cập nhật bàn số \(T.SoBan!)")
//    }
//    sqlite3_close(database)
//}
//func updateRow( _ F: Food){
//    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
//    let query = "UPDATE MonAn SET TenMon = '\(F.TenMon!)', Gia = \(F.Gia!), HinhAnh = '\(F.HinhAnh!)', MoTa = '\(F.MoTa!)', Loai = \(F.Loai!), Icon = '\(F.Icon!)' WHERE MaMon = \(F.MaMon!)"
//    print(query)
//    if edit(query: query){
//        print("Cập nhât món: \(F.TenMon!)")
//    }else{
//        print("Không thể cập nhật món:  \(F.TenMon!)")
//    }
//    sqlite3_close(database)
//}
// END DONG

//====================Nguyễn Đình Sơn

//SQLITE func

func Select( query:String, database:OpaquePointer)->OpaquePointer{
    var statement:OpaquePointer? = nil
    sqlite3_prepare_v2(database, query, -1, &statement, nil)
    return statement!
}

//Trùng hàm phía trên trên = chức năng tương tự
func Query( sql:String, database:OpaquePointer){
    var errMsg:UnsafeMutablePointer<Int8>? = nil
    let result = sqlite3_exec(database, sql, nil, nil, &errMsg);
    
    
    print(sql)
    if (result != SQLITE_OK) {
        sqlite3_close(database)
        print("Truy van bi loi! ERROR \(result)")
        return
    }
}


//====================Nguyễn Đình Sơn

