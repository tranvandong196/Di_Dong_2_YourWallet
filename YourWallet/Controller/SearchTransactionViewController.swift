//
//  SearchTransactionViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class SearchTransactionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var ListTransaction_TableView: UITableView!
    let dateFormattor = DateFormatter()
    var Transactions = [Transaction]()
    var Transactions_Backup = [Transaction]()
    var Transaction_primaryCount:Int = 0
    var TransID:Int = -1
    var indexCell:IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = NSTimeZone.init(abbreviation: "UTC")
        NSTimeZone.default = locale! as TimeZone
        dateFormattor.timeZone = TimeZone.init(abbreviation: "UTC") //Tránh tự động cộng giờ theo vùng
        dateFormattor.dateFormat = "M yyyy, EEEE"
        let ID:Int = wallet_GV == nil ? -1:(wallet_GV?.ID)!
        getTransactionList(WalletID: ID, Range: TimeRange)
        Transaction_primaryCount = Transactions_Backup.count
        searchBarSetup()
        filterTableView(searchText: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let ID:Int = wallet_GV == nil ? -1:(wallet_GV?.ID)!
        getTransactionList(WalletID: ID, Range: TimeRange)
        if Transaction_primaryCount != Transactions_Backup.count{
            ListTransaction_TableView.deleteRows(at: [indexCell!], with: .left)
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: *** SearchBar
    func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 36))
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        self.ListTransaction_TableView.tableHeaderView = searchBar
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.becomeFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //searchBar.setShowsCancelButton(false, animated: true)
        //filterTableView(searchText: nil)
        //searchBar.text = nil
        //searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
        //self.searchDisplayController?.setActive(false, animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(searchText: searchBar.text)
    }
    func filterTableView(searchText: String?){
        
        if searchText != nil && searchText! != ""{
            Transactions = Transactions_Backup.filter({(mod) -> Bool in
                let x = String(mod.Amount!).contains(searchText!) ? true:searchText!.contains(String(mod.Amount!))
                let y = mod.Name!.lowercased().contains(searchText!.lowercased()) ? true:searchText!.lowercased().contains(mod.Name!.lowercased())
                return (x || y)
            })
        }else{
            Transactions.removeAll()
        }
        ListTransaction_TableView.reloadData()
    }
    // MARK: *** Filter Table
    func getTransactionList(WalletID: Int, Range: TIMERANGE){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormat.timeZone = TimeZone.init(abbreviation: "UTC")
        
        let date1 = dateFormat.string(from: Range.start)
        let date2 = dateFormat.string(from: Range.end)
        
        //print("Khoảng thời gian: (\(date1), \(date2))")
        var conditionByWallet = ""
        if WalletID != -1{
            conditionByWallet = " AND MaVi = \(WalletID)"
        }
        
        let sqlT = "SELECT * FROM GiaoDich WHERE ThoiDiem BETWEEN '\(date1)' AND '\(date2)'\(conditionByWallet) ORDER BY ThoiDiem ASC"
        let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        Transactions_Backup = GetTransactionsFromSQLite(query: sqlT, database: database)
        Transactions = Transactions_Backup
        sqlite3_close(database)
    }
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Transactions.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell2") as! BookTransactionCell
        let T:Transaction = Transactions[indexPath.row]
        let day = Calendar.current.component(.day, from: T.Time)
        cell.Day_Label.text = day < 10 ? "0\(day)":"\(day)"
        cell.MonthYear_Label.text = "thg " + dateFormattor.string(from: T.Time)
        cell.TransactionName_Label.text = T.Name
        var money = T.Amount!.VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!)
        if T.Amount! > 0{
            money = "+" + money
        }
        cell.Amount_Label.text = "\(money)" + (currency_GV?.Symbol)!
        cell.Amount_Label.textColor = T.Amount >= 0 ? UIColor.init(red: 4.0/255.0, green: 155.0/255.0, blue: 229.0/255.0, alpha: 1.0):UIColor.red
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexCell = indexPath
        Transaction_primaryCount = Transactions_Backup.count
        transaction_GV = Transactions[indexPath.row]
        let IDW:Int = (transaction_GV?.ID_Wallet)!
        if wallet_GV == nil{
            let db = Connect_DB_SQLite(dbName: DBName, type: DBType)
            wallet_detail = GetWalletsFromSQLite(query: "SELECT * FROM ViTien WHERE Ma = \(IDW)", database: db)[0]
            sqlite3_close(db)
        }else{
            wallet_detail = wallet_GV
        }
        pushToVC(withStoryboardID: "DetailTransactionVC", animated: true)
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
