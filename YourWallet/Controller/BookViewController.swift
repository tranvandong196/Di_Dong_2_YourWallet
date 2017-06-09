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
    var TransactionByCateID = [[Int]]()
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
        
        
        dateFormattor.timeZone = TimeZone.init(abbreviation: "UTC") //Tránh tự động cộng giờ theo vùng
        
        if VNDCurrency == nil{
            let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
            let C = GetCurrenciesFromSQLite(query: "SELECT * FROM TienTe WHERE Ma = 'VND'", database: database)
            VNDCurrency = C[0]
            sqlite3_close(database)
        }
        dateFormattor.dateFormat = "yyyy-MM-dd"
        let date01 = dateFormattor.string(from: TimeRange.start)
        let date02 = dateFormattor.string(from: TimeRange.end)
        
        dateFormattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        TimeRange.start = dateFormattor.date(from: date01 + " 00:00:00")!
        TimeRange.end = dateFormattor.date(from: date02 + " 23:59:59")!
        print(TimeRange)
        dateFormattor.dateFormat = "M yyyy, EEEE"
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
        
        let Wallet_ID:Int = wallet_GV != nil ? (wallet_GV?.ID)!:-1
        filterTable(WalletID: Wallet_ID, Range: TimeRange)
        Book_TableView.reloadData()
        
        
        
        let Titles = getTitleByTimeRange(Range: TimeRange)
        previousDay_Button.setTitle(Titles[0], for: .normal)
        currentDay_Button.setTitle(Titles[1], for: .normal)
        nextDay_Button.setTitle(Titles[2], for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SelectWallet_ButtonTapped(_ sender: Any) {
        isSelectWallet = true
        pushToVC(withStoryboardID: "WalletVC",animated: true)
    }
    @IBAction func previousTimeRange(_ sender: Any, forEvent event: UIEvent) {
        changeTimeRange(Operator: "-")
    }
    
    @IBAction func nextTimeRange(_ sender: Any, forEvent event: UIEvent) {
        changeTimeRange(Operator: "+")
    }
    @IBAction func ViewStatistic_ButtonTapped(_ sender: Any) {
        
        pushToVC(withStoryboardID: "StatisticsVC", animated: true)
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func SwipeRight_Gesture(_ sender: Any) {
        changeTimeRange(Operator: "-")
  
    }
    
    @IBAction func SwipeLeft_Gesture(_ sender: Any) {
        changeTimeRange(Operator: "+")
    }

    // MARK: *** Filter Table
    func filterTable(WalletID: Int, Range: TIMERANGE){
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        dateFormat.timeZone = TimeZone.init(abbreviation: "UTC")
        let date1 = dateFormat.string(from: Range.start) + " 00:00:00"
        let date2 = dateFormat.string(from: Range.end) + " 23:59:59"
        print("Khoảng thời gian: \(date1) đến \(date2)")
        var conditionByWallet = ""
        if WalletID != -1{
            conditionByWallet = " AND MaVi = \(WalletID)"
        }
        
        let sqlT = "SELECT * FROM GiaoDich WHERE ThoiDiem BETWEEN '\(date1)' AND '\(date2)'\(conditionByWallet)"
        let sqlC = "SELECT * FROM Nhom WHERE Ma IN (SELECT MaNhom FROM GiaoDich WHERE ThoiDiem BETWEEN '\(date1)' AND '\(date2)'\(conditionByWallet) GROUP BY MaNhom) "
        let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        Transactions = GetTransactionsFromSQLite(query: sqlT, database: database)
        Categories = GetCategoriesFromSQLite(query: sqlC, database: database)
        sqlite3_close(database)
        TransactionByCateID = getTransactionByCategoryID()
    }
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        refreshOverview()
        return Categories.count
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! BookHeaderCell
        header.CategoryIcon_ImageView.image = UIImage(named: Categories[section].Icon)
        header.CategoryName_Label.text = Categories[section].Name
        header.NumberTransacion_Label.text = "\(TransactionByCateID[section].count) giao dịch"
        let tmp = getAmountOfCategory(Secion: section)
        let tmp2 = tmp.VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!)
        header.Amount_Label.text = "\(tmp2)"
        header.Amount_Label.textColor = tmp >= 0 ? UIColor.black:UIColor.red
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TransactionByCateID[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! BookTransactionCell
        let T = Transactions[TransactionByCateID[indexPath.section][indexPath.row]]
        let day = Calendar.current.component(.day, from: T.Time)
        cell.Day_Label.text = day < 10 ? "0\(day)":"\(day)"
        cell.MonthYear_Label.text = "thg " + dateFormattor.string(from: T.Time)
        cell.TransactionName_Label.text = T.Name
        let money = T.Amount!.VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!)
        cell.Amount_Label.text = "\(money)" + (currency_GV?.Symbol)!
        cell.Amount_Label.textColor = T.Amount >= 0 ? UIColor.black:UIColor.red
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

    func getTransactionByCategoryID()->[[Int]]{
        var tmp = [[Int]]()
        for i in 0..<Categories.count{
            var tmp2c = [Int]()
            for x in 0..<Transactions.count{
                if Transactions[x].ID_Category == Categories[i].ID{
                    tmp2c.append(x)
                }
            }
            tmp.append(tmp2c)
        }
        return tmp
    }
    
    func getTitleByTimeRange(Range: TIMERANGE) -> [String] {
        let df = dateFormattor
        df.timeZone = TimeZone.init(abbreviation: "UTC") //Tránh tự động cộng giờ theo vùng
        var Titles = ["","",""]
        if Range.end == Range.start + 1.day - 1.second{
            df.dateFormat = "dd/MM/yyyy"
            if df.string(from: Range.start) == df.string(from: Date()){
                Titles = ["HÔM QUA","HÔM NAY","NGÀY MAI"]
            }else if df.string(from: Range.start) == df.string(from: Date() - 1.day){
                Titles = [df.string(from: Range.start - 1.day),"HÔM QUA","HÔM NAY"]
            }else if df.string(from: Range.start) == df.string(from: Date() - 2.days){
                Titles = [df.string(from: Range.start - 1.day),df.string(from: Range.start),"HÔM QUA"]
            }else{
                Titles = [df.string(from: Range.start - 1.day),df.string(from: Range.start),df.string(from: Range.start + 1.day)]
            }
        }else if Range.end == Range.start + 1.month - 1.second{
            df.dateFormat = "MM/yyyy"
            if df.string(from: Range.start) == df.string(from: Date()){
                Titles = ["THÁNG QUA","THÁNG NAY","THÁNG SAU"]
            }else if df.string(from: Range.start) == df.string(from: Date() - 1.month){
                Titles = [df.string(from: Range.start - 1.month),"THÁNG QUA","THÁNG NAY"]
            }else if df.string(from: Range.start) == df.string(from: Date() - 2.months){
                Titles = [df.string(from: Range.start - 1.month),df.string(from: Range.start),"THÁNG QUA"]
            }else{
                Titles = [df.string(from: Range.start - 1.month),df.string(from: Range.start),df.string(from: Range.start + 1.month)]
            }
        }else if Range.end == Range.start + 1.year - 1.second{
            df.dateFormat = "yyyy"
            if df.string(from: Range.start) == df.string(from: Date()){
                Titles = ["NĂM QUA","NĂM NAY","NĂM SAU"]
            }else if df.string(from: Range.start) == df.string(from: Date() - 1.year){
                Titles = [df.string(from: Range.start - 1.year),"NĂM QUA","NĂM NAY"]
            }else if df.string(from: Range.start) == df.string(from: Date() - 2.years){
                Titles = [df.string(from: Range.start - 1.year),df.string(from: Range.start),"NĂM QUA"]
            }else{
                Titles = [df.string(from: Range.start - 1.year),df.string(from: Range.start),df.string(from: Range.start + 1.year)]
            }
        }
        return Titles
    }
    func getUnitTime(Range: TIMERANGE) -> DateComponents {
        switch Range.end {
        case Range.start + 1.day - 1.second:
            return 1.day
        case Range.start + 1.month - 1.second:
            return 1.month
        case Range.start + 1.year - 1.second:
            return 1.year
        default:
            break
        }
        return 1.day
    }
    
    func changeTimeRange(Operator: String){
        let unit = getUnitTime(Range: TimeRange)
        
        if Operator == "+"{
            if TimeRange.start + unit > Date().current{return}
            TimeRange.update(start:  (TimeRange.start + unit), end: (TimeRange.end + unit))
        }else if Operator == "-"{
            TimeRange.update(start:  (TimeRange.start - unit), end: (TimeRange.end - unit))
        }
        let Titles = getTitleByTimeRange(Range: TimeRange)
        previousDay_Button.setTitle(Titles[0], for: .normal)
        currentDay_Button.setTitle(Titles[1], for: .normal)
        nextDay_Button.setTitle(Titles[2], for: .normal)
        
        let WalletID:Int = wallet_GV != nil ? (wallet_GV?.ID)!:-1
        filterTable(WalletID: WalletID, Range: TimeRange)
        Book_TableView.reloadData()
    }
    
    func getAmountOfCategory(Secion: Int)->Double{
        var sum:Double = 0
        for i in 0..<TransactionByCateID[Secion].count{
            sum += Transactions[TransactionByCateID[Secion][i]].Amount
        }
        return sum
    }
    func getAmountAllTransaction()-> Double{
        var sum:Double = 0
        for i in 0..<Transactions.count{
            sum += Transactions[i].Amount
        }
        return sum
    }
    func getOpeningBalance(Range: TIMERANGE)->Double{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        dateFormat.timeZone = TimeZone.init(abbreviation: "UTC")
        
        let unit = getUnitTime(Range: TimeRange)
        
        let date2 = dateFormat.string(from: Range.end - unit) + " 23:59:59"
        
        var conditionByWallet = ""
        if wallet_GV != nil{
            conditionByWallet = " AND MaVi = \((wallet_GV?.ID)!)"
        }
        
        let sqlT = "SELECT * FROM GiaoDich WHERE ThoiDiem <= '\(date2)'\(conditionByWallet)"

        let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        let TransactionsPreviousRangeTime = GetTransactionsFromSQLite(query: sqlT, database: database)
        
        
        var sum:Double = 0
        for i in 0..<TransactionsPreviousRangeTime.count{
            sum += TransactionsPreviousRangeTime[i].Amount
        }
        
        if wallet_GV != nil{
            sqlite3_close(database)
            return (wallet_GV?.Amount)! + sum
        }else{
            let wallets = GetWalletsFromSQLite(query: "SELECT * FROM ViTien", database: database)
            sqlite3_close(database)
            
            var sum2:Double = 0
            for i in 0..<wallets.count{
                sum2 += wallets[i].Amount
            }
            
            return sum2 - sum
        }
    }
    
    func refreshOverview(){
        let openingBalance = getOpeningBalance(Range: TimeRange)
        let endingBalance = openingBalance + getAmountAllTransaction()
        WalletEndingBalance_Label.text = "\(endingBalance.VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!))" + (currency_GV?.Symbol)!
        OpeningBalance_Label.text = "\(openingBalance.VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!))" + (currency_GV?.Symbol)!
        EndingBalance_Label.text = "\((endingBalance).VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!))" + (currency_GV?.Symbol)!
        TotalMoneyTransactions_Label.text = "\((-openingBalance + endingBalance).VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!))" + (currency_GV?.Symbol)!
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
