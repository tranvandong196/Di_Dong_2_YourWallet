//
//  AddBudgetViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 19/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class AddBudgetViewController: UIViewController,UITextFieldDelegate {
    
    static var isAddingBudget = false
    
    static public var WalletCode = 0
    static public var CategoryCode = 0
    static public var Id = 0
    
    @IBOutlet weak var Amount: UITextField!
    
    @IBOutlet weak var choseWalletOutlet: UIButton!

    @IBOutlet weak var choseCategoryOutlet: UIButton!
    
    @IBOutlet weak var datePickerTxt: UITextField!
    @IBOutlet weak var datePickerTxt1: UITextField!
    
    let datePicker = UIDatePicker()
    let datePicker1 = UIDatePicker()
    
    static var date1 = String("")
    static var date2 = String("")
    static var amount = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.Amount.delegate = self
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
        
        if(BudgetViewController.isEditing == true){
            Amount.text = "\(AddBudgetViewController.amount)"
            datePickerTxt.text = AddBudgetViewController.date1
            datePickerTxt1.text = AddBudgetViewController.date2
        }
        else{
            AddBudgetViewController.WalletCode = 0
            AddBudgetViewController.CategoryCode = 0
            AddBudgetViewController.amount = 0.0
            AddBudgetViewController.date1 = String("")
            AddBudgetViewController.date2 = String("")
            
        }
        
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
        AddBudgetViewController.date1 = dateFormattor.string(from: datePicker.date)
        
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
        AddBudgetViewController.date2 = dateFormattor.string(from: datePicker.date)
        
        
        self.view.endEditing(true)
    }
    
    func done() -> Bool {
        if(AddBudgetViewController.date1 == nil || AddBudgetViewController.date2 == nil || Amount.text == nil)//phai chon ca hai moc ngay
        {
            return false
        }
        if(AddBudgetViewController.date1 != "" || AddBudgetViewController.date2 != ""){
            
            if (AddBudgetViewController.date1 == ""){
                AddBudgetViewController.date1 = AddBudgetViewController.date2
            }
            else{
                if(AddBudgetViewController.date2 == ""){
                    AddBudgetViewController.date2 = AddBudgetViewController.date1
                }
            }
            
            
            if (AddBudgetViewController.date1! > AddBudgetViewController.date2!){
                let dateTemp = AddBudgetViewController.date1
                AddBudgetViewController.date1 = AddBudgetViewController.date2
                AddBudgetViewController.date2 = dateTemp
                
            }
            AddBudgetViewController.date1 =  AddBudgetViewController.date1! + " 00:00:00"
            AddBudgetViewController.date2 =  AddBudgetViewController.date2! + " 23:59:59"
            
            var sql = ""
            
            if( BudgetViewController.isEditing == false){
                sql = "INSERT INTO NganSach VALUES (null, " + Amount.text! + ", '" + AddBudgetViewController.date1! + "','" + AddBudgetViewController.date2! + "', \(AddBudgetViewController.CategoryCode), \(AddBudgetViewController.WalletCode))"
            }
            else{
                sql = "UPDATE NganSach SET TongGiaTri = " + Amount.text! + ", NgayBD = '" + AddBudgetViewController.date1! + "', NgayKT = '" + AddBudgetViewController.date2! + "', MaNhom = \(AddBudgetViewController.CategoryCode), MaVi = \(AddBudgetViewController.WalletCode)   WHERE Ma = \(AddBudgetViewController.Id)"
            }
            
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
    //Hide or switch next keyboard when user Presses "return" key (for textField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return true
    }
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

