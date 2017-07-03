//
//  AddBudgetViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 19/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class AddBudgetViewController: UIViewController {
    
    static var isAddingBudget = false
    
    static public var WalletCode = 0
    static public var CategoryCode = 0
    
    @IBOutlet weak var Amount: UITextField!
    
    @IBOutlet weak var choseWalletOutlet: UIButton!

    @IBOutlet weak var choseCategoryOutlet: UIButton!
    
    @IBOutlet weak var datePickerTxt: UITextField!
    @IBOutlet weak var datePickerTxt1: UITextField!
    
    let datePicker = UIDatePicker()
    let datePicker1 = UIDatePicker()
    
    var date1 = String("")
    var date2 = String("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        createDatePicker1()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        AddBudgetViewController.isAddingBudget = true
        
        var sql = "Select * from ViTien where ma = \(AddBudgetViewController.WalletCode)"
        print(sql)
        
        var database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        //Lay data
        var statement:OpaquePointer = Select(query: sql, database: database)
        while sqlite3_step(statement) == SQLITE_ROW {
            if(sqlite3_column_text(statement, 1) != nil)
            {
                let str = String(cString: sqlite3_column_text(statement, 1))
                choseWalletOutlet.setTitle(str, for: .normal)
            }
            else{
                choseWalletOutlet.setTitle("Tên ví rỗng!", for: .normal)
            }
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(database)
        
        
        sql = "Select * from Nhom where ma = \(AddBudgetViewController.CategoryCode)"
        database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        //Lay data
        statement = Select(query: sql, database: database)
        while sqlite3_step(statement) == SQLITE_ROW {
            if(sqlite3_column_text(statement, 1) != nil)
            {
                let str = String(cString: sqlite3_column_text(statement, 1))
                choseCategoryOutlet.setTitle(str, for: .normal)
            }
            else{
                choseCategoryOutlet.setTitle("Tên nhóm rỗng!", for: .normal)
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
    }
    
    
    
    
    @IBAction func Cancel_ButtonTapped(_ sender: Any) {
        //Huỷ ở đây
        
        AddBudgetViewController.isAddingBudget = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func Save_ButtonTapped(_ sender: Any) {
        //Lưu ở đây
        done()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //Date picker
    // tạo chọn ngày: Từ ngày
    func createDatePicker()
    {
        // format for picker
        datePicker.datePickerMode = .date
        
        let date = Date()
        datePicker.setDate(date, animated: true)
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        datePickerTxt.inputAccessoryView = toolbar
        datePickerTxt.inputView = datePicker
        
    }
    
    // tạo chọn ngày: Tới ngày
    func createDatePicker1()
    {
        
        let date = Date()
        datePicker1.setDate(date, animated: true)
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,target: nil, action: #selector(donePressed1))
        toolbar.setItems([doneButton], animated: false)
        
        datePickerTxt1.inputAccessoryView = toolbar
        datePickerTxt1.inputView = datePicker
        
    }
    
    // nút done 1
    func donePressed()
    {
        // format date
        let dateFormattor = DateFormatter()
        
        dateFormattor.dateFormat = "yyyy-MM-dd"
        
        //        dateFormattor.dateStyle = .long
        //        dateFormattor.timeStyle = .none
        
        datePickerTxt.text = dateFormattor.string(from: datePicker.date)
        date1 = dateFormattor.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    // nút done 2
    func donePressed1()
    {
        // format date
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        
        //dateFormattor.dateStyle = .medium
        //dateFormattor.timeStyle = .none
        datePickerTxt1.text = dateFormattor.string(from: datePicker.date)
        date2 = dateFormattor.string(from: datePicker.date)
        
        
        self.view.endEditing(true)
    }
    
    func done() -> Bool {
        if(date1 == nil || date2 == nil || Amount.text == nil)//phai chon ca hai moc ngay
        {
            return false
        }
        if(date1 != "" || date2 != ""){
            
            if (date1 == ""){
                date1 = date2
            }
            else{
                if(date2 == ""){
                    date2 = date1
                }
            }
            
            
            if (date1! > date2!){
                let dateTemp = date1
                date1 = date2
                date2 = dateTemp
                
            }
            date1 =  date1! + " 00:00:00"
            date2 =  date2! + " 23:59:59"
            
            var sql = "INSERT INTO NganSach VALUES (null, " + Amount.text! + ", '"
            sql = sql + date1! + "','" + date2! + "', \(AddBudgetViewController.CategoryCode), \(AddBudgetViewController.WalletCode))"
            
            print(sql)
            
            let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
            
            Query(sql: sql, database: database)
            
            AddBudgetViewController.isAddingBudget = false
            
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
            
            return true
        }
        
        return false
    }
}
