//
//  AddTransaction ViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
var addTime = Date()
class AddTransaction_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var NewTransaction_TableView: UITableView!
    
    @IBOutlet weak var Save_Button: UIBarButtonItem!
    let dateFormattor = DateFormatter()

    var amount:String = ""
    var name:String = ""
    var colorLabel:UIColor = UIColor.init(red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0, alpha: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormattor.dateFormat = "EEEE, dd MMMM yyyy"
        //dateFormattor.timeZone = TimeZone.init(abbreviation: "UTC")
        
        if transaction_GV != nil{
            let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
            let C = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom WHERE Ma = '\(String(describing: transaction_GV?.ID_Category))'", database: database)
            category_GV = C[0]
            if wallet_GV == nil{
                let W = GetWalletsFromSQLite(query: "SELECT * FROM Nhom WHERE Ma = \(String(describing: transaction_GV?.ID_Wallet))", database: database)
                wallet_GV = W[0]
            }
            addTime = (transaction_GV?.Time)!
            sqlite3_close(database)
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
        
        if cell2.addNote_TextField.isEmpty() || cell0.addAmount_TextField.isEmpty() || category_GV == nil || wallet_GV == nil{
            print("Tên: \(name)")
            print("Tiền: \(amount)")
            alert(title: "⚠️", message: "Bạn chưa nhập đầy đủ thông tin")
        }else{
            if transaction_GV == nil{
                insertTransaction(name: name, amount: Double(amount)!, time: addTime, ID_Category: (category_GV?.ID)!, ID_Wallet: (wallet_GV?.ID)!)
            }
            amount = ""
            name = ""
            category_GV = nil
            isAddTransaction = false
            self.tabBarController?.selectedIndex = currentTabBarItem
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
            if transaction_GV != nil{
                cell0.addAmount_TextField.text = transaction_GV?.Name
            }else if amount != ""{
                cell0.addAmount_TextField.text = amount
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
            if transaction_GV != nil{
                cell2.addNote_TextField.text = transaction_GV?.Name
            }else if name != ""{
                cell2.addNote_TextField.text = name
            }
            return cell2
        case 3:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! ChangeTimeCell
            cell3.Time_Label.text = dateFormattor.string(from: addTime)
            return cell3
        default:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! SelectWalletCell
            if wallet_GV != nil{
                cell4.WalletName_Label.textColor = colorLabel
                cell4.WalletIcon_ImageView.image = UIImage(named: (wallet_GV?.Icon)!)
                cell4.WalletName_Label.text = wallet_GV?.Name
                
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
            isSelectWallet = true
            self.tabBarController?.tabBar.isHidden = true
            pushToVC(withStoryboardID: "WalletVC", animated: true)
        }
    }
    func selectTime(){
        let dateFormattor2 = DateFormatter()
        dateFormattor2.dateFormat = "dd-MM-yyyy"
        let today = UIAlertAction(title: "Hôm nay", style: .default){_ in
            addTime = Date()
            self.NewTransaction_TableView.reloadData()
        }
//        let today = UIAlertAction(title: "Hôm qua", style: .default){_ in
//            addTime =
//        }
        let Custom = UIAlertAction(title: "Tuỳ chỉnh", style: .default){_ in
            _ = self.pushToVC(withStoryboardID: "SelectTimeVC", animated: true)
        }
        let cancelAction = UIAlertAction(title: "Huỷ", style: .destructive){_ in
            
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(today)
        alert.addAction(Custom)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
