//
//  BookViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class BookViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate {
    let dateFormattor = DateFormatter()
    var Transactions = [Transaction]()
    var Categories = [Category]()
    @IBOutlet weak var Book_TableView: UITableView!
    
    @IBOutlet weak var WalletName_Label: UILabel!
    @IBOutlet weak var WalletEndingBalance_Label: UILabel!
    
    @IBOutlet weak var previousDay_Button: UIButton!
    @IBOutlet weak var currentDay_Button: UIButton!
    @IBOutlet weak var nextDay_Button: UIButton!
    
    @IBOutlet weak var SelectWallet_Button: UIButton!
    
    @IBOutlet weak var OpeningBalance_Label: UILabel!
    @IBOutlet weak var EndingBalance_Label: UILabel!
    @IBOutlet weak var TotalMoneyTransactions_Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Copy_DB_To_DocURL(dbName: DBName, type: DBType)
        getWalletCurrent()
        getCurrencyDefault()
        
        dateFormattor.dateFormat = "M yyyy, EEEE"
        dateFormattor.timeZone = TimeZone.init(abbreviation: "UTC") //Tránh tự động cộng giờ theo vùng
        
        if VNDCurrency == nil{
            let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
            let C = GetCurrenciesFromSQLite(query: "SELECT * FROM TienTe WHERE Ma = 'VND'", database: database)
            VNDCurrency = C[0]
            sqlite3_close(database)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("🖥 Sổ giao dịch --------------------------------")
        isSelectWallet = false
        transaction_GV = nil
        isAddTransaction = false
        currentTabBarItem = 0
        category_GV = nil
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        SelectWallet_Button.imageView?.image = wallet_GV != nil ? UIImage(named: (wallet_GV?.Icon)!):#imageLiteral(resourceName: "All-Wallet-icon")
        WalletName_Label.text = wallet_GV?.Name ?? "Tất cả các ví"
        WalletEndingBalance_Label.text = "Chưa tính"
        OpeningBalance_Label.text = "Chưa tính"
        EndingBalance_Label.text = "Chưa tính"
        TotalMoneyTransactions_Label.text = "Chưa tính"
        
        let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        Transactions = GetTransactionsFromSQLite(query: "SELECT * FROM GiaoDich", database: database)
        Categories = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom WHERE Ma = 0", database: database)
        sqlite3_close(database)
        Book_TableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SelectWallet_ButtonTapped(_ sender: Any) {
        isSelectWallet = true
        pushToVC(withStoryboardID: "WalletVC",animated: true)
    }
    
    @IBAction func ViewStatistic_ButtonTapped(_ sender: Any) {
        
        pushToVC(withStoryboardID: "StatisticsVC", animated: true)
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func SwipeRight_Gesture(_ sender: Any) {
        previousDay_Button.setTitle("29/05/2017", for: .normal)
        currentDay_Button.setTitle("HÔM QUA", for: .normal)
        nextDay_Button.setTitle("HÔM NAY", for: .normal)
        
        print("Thao tác vuốt phải thành công")
    }
    
    @IBAction func SwipeLeft_Gesture(_ sender: Any) {
        previousDay_Button.setTitle("HÔM NAY", for: .normal)
        currentDay_Button.setTitle("NGÀY MAI", for: .normal)
        nextDay_Button.setTitle("31/05/2017", for: .normal)
        print("Thao tác vuốt trái thành công")
    }
    
    
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return Categories.count
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! BookHeaderCell
        header.CategoryIcon_ImageView.image = UIImage(named: Categories[section].Icon)
        header.CategoryName_Label.text = Categories[section].Name
        header.NumberTransacion_Label.text = "Chưa tính"
        header.Amount_Label.text = "Chưa tính"
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Transactions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! BookTransactionCell
        let day = Calendar.current.component(.day, from: Transactions[indexPath.row].Time)
        cell.Day_Label.text = day < 10 ? "0\(day)":"\(day)"
        cell.MonthYear_Label.text = "thg " + dateFormattor.string(from: Transactions[indexPath.row].Time) //"thg 6 2017, Thứ Sáu"
        cell.TransactionName_Label.text = Transactions[indexPath.row].Name
        let money = Transactions[indexPath.row].Amount!.VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!)
        cell.Amount_Label.text = "-\(money)" + (currency_GV?.Symbol)!
        return cell
        
    }
    func  getWalletCurrent() {
        if UserDefaults.standard.value(forKey: "Wallet") != nil{
            let ID:Int = UserDefaults.standard.value(forKey: "Wallet") as! Int
            if ID == -1{
                wallet_GV = nil
                print("Lấy ví hiện tại: Tất cả ví")
            }else{
                let db = Connect_DB_SQLite(dbName: DBName, type: DBType)
                let w = GetWalletsFromSQLite(query: "SELECT * FROM ViTien WHERE Ma = \(ID)", database: db)
                sqlite3_close(db)
                wallet_GV = w[0]
                print("Lấy ví hiện tại: \(w[0].Name!)")
            }
            
        }else{
            UserDefaults.standard.setValue(-1, forKey: "Wallet")
            print("Đặt ví hiện tại mặc định: Tất cả ví")
        }
    }
    func getCurrencyDefault() {
        let db = Connect_DB_SQLite(dbName: DBName, type: DBType)
        var ID:String = "VND"
        if UserDefaults.standard.value(forKey: "Currency") != nil{
            ID = UserDefaults.standard.value(forKey: "Currency") as! String
        }else{
            UserDefaults.standard.setValue(ID, forKey: "Currency")
        }
        let c = GetCurrenciesFromSQLite(query: "SELECT * FROM TienTe WHERE Ma = '\(ID)'", database: db)
        currency_GV = c[0]
        sqlite3_close(db)
        print("Tiền tệ mặc định: \(c[0].ID!)")
    }

//    func handleTouchTabbarCenter(sender : UIButton)
//    {
//        if let count = self.tabBarController?.tabBar.items?.count
//        {
//            let i = floor(Double(count / 2))
//            self.ta = self.viewControllers?[Int(i)]
//        }
//    }
//    
//    func addCenterButton(withImage buttonImage : UIImage, highlightImage: UIImage) {
//        
//        let paddingBottom : CGFloat = 10.0
//        
//        let button = UIButton(type: .custom)
//        button.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin]
//        button.frame = CGRect(x: 0.0, y: 0.0, width: buttonImage.size.width / 2.0, height: buttonImage.size.height / 2.0)
//        button.setBackgroundImage(buttonImage, for: .normal)
//        button.setBackgroundImage(highlightImage, for: .highlighted)
//        
//        let rectBoundTabbar = self.tabBar.bounds
//        let xx = rectBoundTabbar.midX
//        let yy = rectBoundTabbar.midY - paddingBottom
//        button.center = CGPoint(x: xx, y: yy)
//        
//        self.tabBar.addSubview(button)
//        self.tabBar.bringSubview(toFront: button)
//        
//        button.addTarget(self, action: #selector(handleTouchTabbarCenter), for: .touchUpInside)
//        
//        if let count = self.tabBar.items?.count
//        {
//            let i = floor(Double(count / 2))
//            let item = self.tabBar.items![Int(i)]
//            item.title = ""
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
