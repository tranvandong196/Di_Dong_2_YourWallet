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

var database:OpaquePointer?


var Parent_dir_data:String = "Resources"
var Sub_folder_data:[String] = ["Table","Food","Area"]
let DBName = "QuanLyNhaHang"
let DBType = "sqlite"

// MARK: *** SQLite3 function
//Database pointer
func Connect_DB_SQLite( dbName:String, type:String)->OpaquePointer{
    var database:OpaquePointer? = nil
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let storePath : String = documentURL.appendingPathComponent("\(dbName).\(type)").path
    let dbPath = Bundle.main.path(forResource: dbName , ofType:type)!
    do {
        try FileManager.default.copyItem(atPath: dbPath, toPath: storePath)
    } catch{
        //print("File exists! Can not copy file")
    }
    if sqlite3_open(storePath, &database) == SQLITE_OK{
        print("Opened < \(dbName).\(type) > from storePath")
    }else{
        sqlite3_close(database)
        print("Failed to open database -> Created \(dbName).\(type) but it wasn't set a valid structure/table!")
        //createdTable(database: database, query: String) to create any table
    }
    //print("\nDatabase has been stored at: \(storePath)\n")
    return database!
}
func createTable(database: OpaquePointer?,query: String) {
    var statement : OpaquePointer?
    if sqlite3_prepare_v2(database, query,-1, &statement, nil) == SQLITE_OK{
        if sqlite3_step(statement) == SQLITE_DONE{
            print("Table created!")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(database))
            print(errmsg)
        }
    }else{
        let errmsg = String(cString: sqlite3_errmsg(database))
        print(errmsg)
    }
}
func edit(query: String)-> Bool{
    var result:Bool = false
    var insertStatement : OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &insertStatement, nil) == SQLITE_OK{
        if sqlite3_step(insertStatement) == SQLITE_DONE{
            result = true
        }else{
            result = false
        }
    }else{
        print("Edit statement could not be prepared.")
        result = false
    }
    sqlite3_finalize(insertStatement)
    return result
}

// MARK: *** Tran Van Dong
func getQueryStament(query: String)->OpaquePointer?{
    database = Connect_DB_SQLite(dbName: DBName, type: DBType)
    var queryStatement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
        return queryStatement
    }
    sqlite3_close(database)
    return nil
}
//func GetTablesFromSQLite(query: String) -> [Table]{
//    var Tables = [Table]()
//    
//    if let queryStatement = getQueryStament(query: query){
//        while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
//            let table = Table(SoBan: -1, TinhTrang: 0, HinhAnh: "", GhiChu: "", MaKV: 0, MaHD: 0)
//            if sqlite3_column_text(queryStatement, 0) != nil {
//                table.SoBan = Int(sqlite3_column_int(queryStatement, 0))
//            }
//            if sqlite3_column_text(queryStatement, 1) != nil {
//                table.TinhTrang = Int(sqlite3_column_int(queryStatement, 1))
//            }
//            if sqlite3_column_text(queryStatement, 2) != nil {
//                table.HinhAnh = String(cString: sqlite3_column_text(queryStatement, 2))
//            }
//            if sqlite3_column_text(queryStatement, 3) != nil {
//                table.GhiChu = String(cString: sqlite3_column_text(queryStatement, 3))
//            }
//            if sqlite3_column_text(queryStatement, 4) != nil {
//                table.MaKV = Int(sqlite3_column_int(queryStatement, 4))
//            }
//            if sqlite3_column_text(queryStatement, 5) != nil {
//                table.MaHD = Int(sqlite3_column_int(queryStatement, 5))
//            }
//            else{
//                table.MaHD = nil
//            }
//            
//            Tables.append(table)
//        }
//    }
//    return Tables
//}


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
func createDirectoryStoreData(ParentDir: String,SubFolder:[String]) -> Bool{
    let fileManager = FileManager.default
    let ParentDirURL = DocURL().appendingPathComponent(ParentDir)
    print("\nDataStoreURL: \(ParentDirURL.path)\n")
    
    if !fileManager.fileExists(atPath: ParentDirURL.path){
        // Tạo các thư mục chứa data vào DocURL
        fileManager.createDirectory(at: DocURL(), withName: ParentDir)
        for i in 0..<SubFolder.count{
            fileManager.createDirectory(at: ParentDirURL, withName: SubFolder[i])
        }
        return true
    }else{
        print("Directory Database is exists!")
        return false
    }
    
}
//func copyDataToDocumentURL(ParentDir: String,SubFolder:[String]){
//    let ParentDirURL = DocURL().appendingPathComponent(ParentDir)
//    let result = createDirectoryStoreData(ParentDir: Parent_dir_data,SubFolder: Sub_folder_data)
//    if result{
//        Tables = GetTablesFromSQLite(query: "SELECT * FROM BanAn")
//        Foods = GetFoodsFromSQLite(query: "SELECT * FROM MonAn")
//        Areas = GetAreasFromSQLite(query: "SELECT * FROM KhuVuc")
//        for i in 0..<Tables.count{
//            let iName:String = Tables[i].HinhAnh
//            let img:UIImage = UIImage(named: iName) ?? #imageLiteral(resourceName: "Ban")
//            img.saveImageToDir(at: ParentDirURL.appendingPathComponent(Sub_folder_data[0]), name: iName)
//        }
//        for i in 0..<Foods.count{
//            let imName:String = Foods[i].HinhAnh
//            let icName:String = Foods[i].Icon
//            if let img:UIImage = UIImage(named: imName){
//                img.saveImageToDir(at: ParentDirURL.appendingPathComponent(Sub_folder_data[1]), name: imName)
//            }
//            if let icon:UIImage = UIImage(named: icName){
//                icon.saveImageToDir(at: ParentDirURL.appendingPathComponent(Sub_folder_data[1]), name: icName)
//            }
//        }
//        for i in 0..<Areas.count{
//            let iName:String = Areas[i].HinhAnh
//            let img:UIImage = UIImage(named: Areas[i].HinhAnh) ?? #imageLiteral(resourceName: "tang1")
//            img.saveImageToDir(at: ParentDirURL.appendingPathComponent(Sub_folder_data[2]), name: iName)
//        }
//    }
//    
//    
//    
//}
// END DONG

//====================Nguyễn Đình Sơn

//SQLITE func

func Select( query:String, database:OpaquePointer)->OpaquePointer{
    var statement:OpaquePointer? = nil
    sqlite3_prepare_v2(database, query, -1, &statement, nil)
    return statement!
}

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

