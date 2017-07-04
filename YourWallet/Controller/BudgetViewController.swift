//
//  BudgetViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 19/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var showEndedBudget = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var endedOutlet: UIButton!
    @IBAction func endedBtn(_ sender: Any) {
        if (showEndedBudget == true){
            endedOutlet.setTitle("Xem ngân sách đã kết thúc", for: .normal)
        }
        else{
            endedOutlet.setTitle("Xem ngân sách đang hoạt động", for: .normal)
        }
        showEndedBudget = !showEndedBudget
        reload()
    }
    
    var budget = [Budget]()
    var budgetIcons = [String]()
    var budgetNames = [String]()
    var walletNames = [String]()
    var walletIcons = [String]()
    var budgetLeft = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        isAddBudget = false
        
        reload()
        
    }
    
    func reload(){
        budget = [Budget]()
        budgetIcons = [String]()
        budgetNames = [String]()
        budgetLeft = [Double]()
        walletNames = [String]()
        walletIcons = [String]()
        
        let date = Date()
        let dateFormattor = DateFormatter()
        dateFormattor.timeZone = TimeZone.current
        dateFormattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var compare = ""
        
        if(showEndedBudget){
            compare = "< '"
        }
        else{
            compare = ">= '"
        }
        
        let currentDate = compare + dateFormattor.string(from: date) + "'"
        //Lay du lieu tu dbs
        let sql = "Select * From NganSach where NgayKT " + currentDate
        
        var database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        budget = GetBudgetsFromSQLite(query: sql, database: database)
        database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        let statement:OpaquePointer =  Select(query: "Select * from (Select Icon, Ten, NganSach.Ma, NganSach.MaVi From Nhom join NganSach WHERE Nhom.Ma = NganSach.MaNhom and NganSach.NgayKT " + currentDate + ") JOIN ViTien WHERE MaVi = ViTien.Ma", database: database)
        
        var i = -1
        // Do du lieu vao mang
        while sqlite3_step(statement) == SQLITE_ROW
        {
            i += 1
            if(sqlite3_column_text(statement, 0) != nil)
            {
                // Them Vao mang da co
                budgetIcons.append(String(cString: sqlite3_column_text(statement, 0)))
            }
            if(sqlite3_column_text(statement, 1) != nil)
            {
                // Them Vao mang da co
                budgetNames.append(String(cString: sqlite3_column_text(statement, 1)))
            }
            if(sqlite3_column_text(statement, 5) != nil)
            {
                // Them Vao mang da co
                walletNames.append(String(cString: sqlite3_column_text(statement, 5)))
            }
            if(sqlite3_column_text(statement, 9) != nil)
            {
                // Them Vao mang da co
                walletIcons.append(String(cString: sqlite3_column_text(statement, 9)))
            }
            
            //lay so tien con lai
            if(sqlite3_column_text(statement, 2) != nil)
            {
                // Them Vao mang da co
                let MaNganSach = sqlite3_column_int(statement, 2)
                
                let database2 = Connect_DB_SQLite(dbName: DBName, type: DBType)
                let statement2:OpaquePointer =  Select(query: "Select * from GiaoDich as A join NganSach as B where b.NgayKT " + currentDate + " and a.MaNhom = b.manhom and a.Mavi = b.mavi and a.thoidiem >= b.NgayBD and a.thoidiem <= b.ngaykt and b.Ma = \(MaNganSach)", database: database2)
                
                var SumLeft = 0.0
                if (budget.count >= 1){
                    SumLeft = budget[i].Amount
                }
                // Do du lieu vao mang
                while sqlite3_step(statement2) == SQLITE_ROW
                {
                    if(sqlite3_column_text(statement2, 2) != nil)
                    {
                        let expense = (sqlite3_column_double(statement2, 2))
                        if (expense < 0)
                        {
                            SumLeft += expense;
                        }
                        
                    }
                }
                sqlite3_finalize(statement2)
                sqlite3_close(database2)
                budgetLeft.append(SumLeft)
            }
            
            
        }
        
        
        sqlite3_finalize(statement)
        sqlite3_close(database)
        
        tableView.reloadData()
    }
    
    @IBAction func addBudget_ButtonTapped(_ sender: Any) {
        isAddBudget = true
        pushToVC(withStoryboardID: "AddBudgetVC", animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Table View func begin
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budget.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NganSachCell
//        
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "dd/MM/yyyy"

        let dateStr = dateFormattor.string(from: budget[indexPath.row].StartDate) + " - " + dateFormattor.string(from: budget[indexPath.row].EndDate)

        
        cell.txt_Date.text = dateStr
        
        cell.icon.image = UIImage(named: budgetIcons[indexPath.row])
        cell.txt_Categories.text = budgetNames[indexPath.row]
        
        let tmp = budget[indexPath.row].Amount!.VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!)
        
        let currencyStr = "\(tmp)" + (currency_GV?.Symbol)!
        
        cell.txt_TotalCash.text = currencyStr
        
        let tmp2 = budgetLeft[indexPath.row].VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!)
        
        let currencyStr2 = "\(tmp2)" + (currency_GV?.Symbol)!
        
        cell.txt_Left.text = "Còn lại: " + currencyStr2
        cell.iconWallet.image = UIImage(named: walletIcons[indexPath.row])
        cell.txt_WalletName.text = walletNames[indexPath.row]
        
        
//        let a = Double(budgetLeft[indexPath.row])
//        let b = Double(budget[indexPath.row].Amount)
//        var c = Double(cell.UIImageV_percentBar.frame.width) * (a/b)
//        if(c<=0){
//            c = 0;
//        }
//        //cell.UIImageV_percentBar.frame = CGRect(x: 0, y: 0, width: c, height: Double(cell.UIImageV_percentBar.frame.height))
//        
//        cell.UIImageV_percentBar.frame.size = CGSize(width: c, height: Double(cell.UIImageV_percentBar.frame.height))
//        let sPrice =  Foods[indexPath.row].Gia!.getCurrencyValue(Currency: Currency)
//        
//        cell.Name.text = Foods[indexPath.row].TenMon
        return cell
    }
    //Table View func end

}

class NganSachCell: UITableViewCell {
    
    @IBOutlet weak var txt_Date: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var txt_Categories: UILabel!
    @IBOutlet weak var txt_TotalCash: UILabel!
    @IBOutlet weak var txt_Left: UILabel!
    @IBOutlet weak var UIImageV_percentBar: UIImageView!
    @IBOutlet weak var iconWallet: UIImageView!
    @IBOutlet weak var txt_WalletName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

