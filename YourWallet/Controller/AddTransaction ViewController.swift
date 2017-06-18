//
//  AddTransaction ViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
class AddTransaction_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var NewTransaction_TableView: UITableView!
    
    
    @IBOutlet weak var Save_Button: UIBarButtonItem!
    let dateFormattor = DateFormatter()
    var datePicker : UIDatePicker!
    var doneButton:UIButton!
    var datePickerContainer: UIView!
    var addTime = Date().current
    var amount:String = ""
    var name:String = ""
    var colorLabel:UIColor = UIColor.init(red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0, alpha: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormattor.dateFormat = "EEEE, dd MMMM yyyy"
        //dateFormattor.timeZone = TimeZone.init(abbreviation: "UTC")
        
        if transaction_GV != nil{
            let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
            let C = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom WHERE Ma = '\(String(describing: (transaction_GV?.ID_Category)!))'", database: database)
            category_GV = C[0]
            let W = GetWalletsFromSQLite(query: "SELECT * FROM ViTien WHERE Ma = \(String(describing: (transaction_GV?.ID_Wallet)!))", database: database)
            wallet_detail = W[0]
            sqlite3_close(database)
            let tmp:Double = (transaction_GV?.Amount)! < 0 ? (transaction_GV?.Amount)!*(-1):(transaction_GV?.Amount)!
            amount = currency_GV?.ID == "VND" ? String(describing: Int(tmp)):String(describing: tmp)
            name = (transaction_GV?.Name)!
            addTime = (transaction_GV?.Time)!
            self.navigationItem.title = "Sửa giao dịch"
            self.navigationItem.leftBarButtonItem = nil
        }else{
            wallet_detail = wallet_GV
        }
        print("View did load")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        print("🖥 Thêm giao dịch --------------------------------")
        isSelectCategory = false
        isSelectWallet = false
        isAddTransaction = true
        NewTransaction_TableView.reloadData()
        self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func Cancel_ButtonTapped(_ sender: Any) {
        category_GV = nil
        wallet_detail = nil
        isAddTransaction = false
        amount = ""
        name = ""
        
        NewTransaction_TableView.reloadData()
        let a = NewTransaction_TableView.dequeueReusableCell(withIdentifier: "Add-Amount-Cell") as! AddAmountCell
        let n = NewTransaction_TableView.dequeueReusableCell(withIdentifier: "Add-Note-Cell") as! AddNodeCell
        a.reloadInputViews()
        n.reloadInputViews()
        self.tabBarController?.selectedIndex = currentTabBarItem
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func Save_ButtonTapped(_ sender: Any) {
        NewTransaction_TableView.reloadData()
        
        let cell0 = NewTransaction_TableView.dequeueReusableCell(withIdentifier: "Add-Amount-Cell") as! AddAmountCell
        let cell2 = NewTransaction_TableView.dequeueReusableCell(withIdentifier: "Add-Note-Cell") as! AddNodeCell
        amount = cell0.addAmount_TextField.text!
        name = cell2.addNote_TextField.text!
        
        if cell0.addAmount_TextField.isEmpty() || category_GV == nil || wallet_detail == nil{
            print("Tên: \(name)")
            print("Tiền: \(amount)")
            alert(title: "⚠️", message: "Bạn chưa nhập đầy đủ thông tin")
        }else{
            let tmp:Double = category_GV?.Kind == 0 ? -Double(amount)!:Double(amount)!
            let db = Connect_DB_SQLite(dbName: DBName, type: DBType)
            
            if transaction_GV == nil{
                wallet_detail?.Balance = (wallet_detail?.Balance)! + tmp
                insertTransaction(name: name, amount: tmp, time: addTime, ID_Category: (category_GV?.ID)!, ID_Wallet: (wallet_detail?.ID)!)
                if Query(Sql: "UPDATE ViTien SET SoDu = \((wallet_detail?.Balance)!) WHERE Ma = \((wallet_detail?.ID)!)", database: db){
                    print("Đã cập nhật số dư ví: \((wallet_detail?.Name)!)")
                }
                sqlite3_close(db)
                self.tabBarController?.selectedIndex = currentTabBarItem
            }else{
                updateTransaction(name: name, amount: tmp, time: addTime, ID_Category: (category_GV?.ID)!, ID_Wallet: (wallet_detail?.ID)!, ID_Transaction: (transaction_GV?.ID)!)
                if transaction_GV?.ID_Wallet == wallet_detail?.ID{
                    if transaction_GV?.Amount != tmp{
                        let balanceFinal:Double = (wallet_detail?.Balance)! - (transaction_GV?.Amount)! + tmp
                        if Query(Sql: "UPDATE ViTien SET SoDu = \(balanceFinal) WHERE Ma = \((wallet_detail?.ID)!)", database: db){
                            print("Đã cập nhật số dư ví: \((wallet_detail?.Name)!)")
                        }
                    }
                }else{
                    let wOLD:Wallet = GetWalletsFromSQLite(query: "SELECT * FROM ViTien WHERE Ma = \((transaction_GV?.ID_Wallet)!)", database: db)[0]
                    
                    if Query(Sql: "UPDATE ViTien SET SoDu = \(wOLD.Balance! - (transaction_GV?.Amount)!) WHERE Ma = \(wOLD.ID!)", database: db){
                        print("Ví đã thay đổi! Đã bù lại tiền cho ví: \(wOLD.Name!)")
                    }
                    let balanceFinal:Double = (wallet_detail?.Balance)! + tmp
                    if Query(Sql: "UPDATE ViTien SET SoDu = \(balanceFinal) WHERE Ma = \((wallet_detail?.ID)!)", database: db){
                        print("Đã cập nhật số dư ví: \((wallet_detail?.Name)!)")
                    }
                }
                
                
                transaction_GV = GetTransactionsFromSQLite(query: "SELECT * FROM GiaoDich WHERE Ma = \((transaction_GV?.ID)!)", database: db)[0]
                sqlite3_close(db)
                self.navigationController?.popViewController(animated: true)
            }
            amount = ""
            name = ""
            category_GV = nil
            //wallet_detail = nil
            isAddTransaction = false
            self.tabBarController?.tabBar.isHidden = false
        }
        
        
    }
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5:1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 87
            }
            return indexPath.row == 1 ? 72:48
        }else{
            return 48
        }
    }
    let Cells = ["Add-Amount-Cell","Select-Category-Cell","Add-Note-Cell","Change-Time-Cell","Select-Wallet-Cell"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell0 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! AddAmountCell
            cell0.selectionStyle = .none
            cell0.selectCurrency_Button.layer.cornerRadius = 3
            cell0.selectCurrency_Button.layer.borderWidth = 0.7
            cell0.selectCurrency_Button.layer.borderColor = UIColor.lightGray.cgColor
            if amount != ""{
                cell0.addAmount_TextField.text = amount
                amount = ""
            }
            addDoneButton(to: cell0.addAmount_TextField)
            return cell0
        case 1:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! SelectCategoryCell
            if category_GV != nil{
                cell1.categoryIcon_ImageView.image = UIImage(named: (category_GV?.Icon)!)
                cell1.categoryName_Label.textColor = colorLabel
                cell1.categoryName_Label.text = category_GV?.Name
            }else{
                cell1.categoryIcon_ImageView.image = #imageLiteral(resourceName: "SelectCategory-Circle-icon")
                cell1.categoryName_Label.textColor = UIColor.lightGray
                cell1.categoryName_Label.text = "Chọn nhóm"
            }
            
            return cell1
        case 2:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! AddNodeCell
            if name != ""{
                cell2.addNote_TextField.text = name
                name = ""
            }
            return cell2
        case 3:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! ChangeTimeCell
            cell3.Time_Label.text = dateFormattor.string(from: addTime)
            return cell3
        default:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! SelectWalletCell
            if wallet_detail != nil{
                cell4.WalletName_Label.textColor = colorLabel
                cell4.WalletIcon_ImageView.image = UIImage(named: (wallet_detail?.Icon)!)
                cell4.WalletName_Label.text = wallet_detail?.Name
                
            }else{
                cell4.WalletIcon_ImageView.image = #imageLiteral(resourceName: "SelectCategory-Circle-icon")
                cell4.WalletName_Label.textColor = UIColor.lightGray
                cell4.WalletName_Label.text =  "Chọn ví"
            }
            
            return cell4
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            isSelectCategory = true
            self.tabBarController?.tabBar.isHidden = true
            pushToVC(withStoryboardID: "CategoryVC", animated: true)
        }
        if indexPath.row == 3{
            selectTime()
            let cell3 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! ChangeTimeCell
            cell3.Time_Label.text = dateFormattor.string(from: addTime)
        }
        if indexPath.row == 4{
            //isSelectWallet = true
            self.tabBarController?.tabBar.isHidden = true
            pushToVC(withStoryboardID: "WalletVC", animated: true)
        }
    }
    
    // MARK: *** DatePickerView
    func createDatePicker()
    {
        
        datePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 0.0, y: (UIScreen.main.bounds).height - 200, width: (UIScreen.main.bounds).width, height: 200)
        
        // format for picker
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        datePicker.date = addTime
        
        doneButton = UIButton()
        doneButton.setTitle("Xong", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: UIControlEvents.touchUpInside)
        doneButton.backgroundColor = UIColor.init(red: 28.0/255.0, green: 179.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        doneButton.contentHorizontalAlignment = .center
        doneButton.frame    = CGRect(x: 0, y: (UIScreen.main.bounds).height - 237,width: (UIScreen.main.bounds).width,height: 37.0)
        
        // Animation
        doneButton.alpha = 0
        view.addSubview(doneButton)
        doneButton.fadeIn(withDuration: 0.2)
        datePicker.alpha = 0
        view.addSubview(datePicker)
        datePicker.fadeIn(withDuration: 0.3)
    }
    
    
    // nút done
    func donePressed(){
        if addTime != datePicker.date{
            addTime = datePicker.date.current
        }
        doneButton.fadeOut(withDuration: 0.2)
        datePicker.fadeOut(withDuration: 0.1)
        
        doneButton.removeFromSuperview()
        datePicker.removeFromSuperview()
        self.NewTransaction_TableView.reloadData()
    }
    
    
    
    func selectTime(){
        view.endEditing(true)
        let today = UIAlertAction(title: "Hôm nay", style: .default){_ in
            self.addTime = Date().current
            self.NewTransaction_TableView.reloadData()
        }
        let yesterday = UIAlertAction(title: "Hôm qua", style: .default){_ in
            self.addTime = Date().current - 1.day
            self.NewTransaction_TableView.reloadData()
        }
        let Custom = UIAlertAction(title: "Tuỳ chỉnh", style: .default){_ in
            _ = self.createDatePicker()
        }
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel){_ in
            self.NewTransaction_TableView.reloadData()
        }
        
        
        let sheetCtrl = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheetCtrl.addAction(today)
        sheetCtrl.addAction(yesterday)
        sheetCtrl.addAction(Custom)
        sheetCtrl.addAction(cancelAction)
        
        //sheetCtrl.popoverPresentationController?.sourceView = self.view
        //sheetCtrl.popoverPresentationController?.sourceRect = self.changeLanguageButton.frame
        present(sheetCtrl, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
