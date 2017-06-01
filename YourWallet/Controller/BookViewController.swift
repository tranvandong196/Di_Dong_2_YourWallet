//
//  BookViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class BookViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var database:OpaquePointer? = nil
    let dateFormattor = DateFormatter()
    
    @IBOutlet weak var previousDay_Button: UIButton!
    @IBOutlet weak var currentDay_Button: UIButton!
    @IBOutlet weak var nextDay_Button: UIButton!
    @IBOutlet weak var SelectWallet_Button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Copy_DB_To_DocURL(dbName: DBName, type: DBType)
        
        getWalletCurrent()
        
        dateFormattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormattor.timeZone = TimeZone.init(abbreviation: "UTC") //Tránh tự động cộng giờ theo vùng
        
        
//        database = Connect_DB_SQLite(dbName: DBName, type: DBType)
//        
//        let querysql = "INSERT INTO GiaoDich VALUES(null, 'Phồng tôm', 5000, datetime('now', 'localtime'), 0, 1)"
//        if Query(Sql: querysql,database: database){
//            print(querysql)
//        }
//        let querysql2 = "INSERT INTO NganSach VALUES(null, 1500000, '2017-06-01 00:00:00', '2017-06-30  00:00:00', 0, 1)"
//        if Query(Sql: querysql2,database: database){
//            print(querysql2)
//        }
//        
//        let Transactions = GetTransactionsFromSQLite(query: "SELECT * FROM GiaoDich",database: database)
//        print(Transactions[0])
//        
//        let Budgets = GetBudgetsFromSQLite(query: "SELECT * FROM NganSach", database: database)
//        print(Budgets[0])
//        
//        let Categories = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom", database: database)
//        print(Categories[0])
//        
//        let Wallets = GetWalletsFromSQLite(query: "SELECT * FROM ViTien", database: database)
//        print(Wallets[0])
//        
//        let Currencies = GetCurrenciesFromSQLite(query: "SELECT * FROM TienTe", database: database)
//        print(Currencies[1])
//        
//        sqlite3_close(database)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        isSelectWallet = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        SelectWallet_Button.imageView?.image = wallet_GV != nil ? UIImage(named: (wallet_GV?.Icon)!):#imageLiteral(resourceName: "All-Wallet-icon")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SelectWallet_ButtonTapped(_ sender: Any) {
        isSelectWallet = true
        pushToVC(withStoryboardID: "WalletVC",animated: true)
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
        return 3
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! BookHeaderCell
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! BookTransactionCell
        return cell
        
    }
    func  getWalletCurrent() {
        if UserDefaults.standard.value(forKey: "Wallet") != nil{
            let ID:Int = UserDefaults.standard.value(forKey: "Wallet") as! Int
            if ID == -1{
                wallet_GV = nil
            }else{
                let db = Connect_DB_SQLite(dbName: DBName, type: DBType)
                let w = GetWalletsFromSQLite(query: "SELECT * FROM ViTien WHERE Ma = \(ID)", database: db)
                sqlite3_close(db)
                wallet_GV = w[0]
            }
            print("Lấy loại ví hiện tại: \(String(describing: wallet_GV?.Name))")
        }else{
            UserDefaults.standard.setValue(-1, forKey: "Wallet")
            print("Ví tiền chưa được chọn!")
        }
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
