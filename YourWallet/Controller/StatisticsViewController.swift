//
//  StatisticsViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    static var date1 = "";
    static var date2 = "";
    static var showOnlyOneDay = false
    
    var showIncome = false
    
    @IBOutlet weak var showIncomeOutlet: UIButton!
    @IBAction func showIncomeClick(_ sender: Any) {
        if(showIncome == false)
        {
            showIncomeOutlet.setTitle("Xem thống kê chi tiêu", for: .normal)
        }
        else{
            showIncomeOutlet.setTitle("Xem thống kê thu nhập", for: .normal)
        }
        showIncome = !showIncome
        reload()
    }
    var typeNameArray = [String]()
    var iconArray = [String]()
    var valueArray = [Double]()
    var colors: [UIColor] = []
    var sum = 0.0;
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var txtNotif: UILabel!
    @IBOutlet weak var SelectWallet_Button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false;
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let currDate = "\(components.day!)/\(components.month!)/\(components.year!)";
        
        let firstDate = "01/\(components.month!)/\(components.year!)"
        
    
        txtDate.text = firstDate + "-" + currDate
        
        if(StatisticsViewController.showOnlyOneDay == false){
            
            StatisticsViewController.date1 = "\(components.year!)-\(components.month!)-01 00:00:00"
            StatisticsViewController.date2 = "\(components.year!)-\(components.month!)-\(components.day!)" + " 23:59:59"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-M-dd HH:mm:ss"
            let dateRaw1 = dateFormatter.date(from: StatisticsViewController.date1)!
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            StatisticsViewController.date1 = dateFormatter.string(from: dateRaw1)
            
            dateFormatter.dateFormat = "yyyy-M-dd HH:mm:ss"
            let dateRaw2 = dateFormatter.date(from: StatisticsViewController.date2)!
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            StatisticsViewController.date2 = dateFormatter.string(from: dateRaw2)

        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("🖥 Thống kê --------------------------------")
        reload()
    }
    
    func reload(){
        txtNotif.text = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateRaw1 = dateFormatter.date(from: StatisticsViewController.date1)!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let firstDate = dateFormatter.string(from: dateRaw1)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateRaw2 = dateFormatter.date(from: StatisticsViewController.date2)!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currDate = dateFormatter.string(from: dateRaw2)
        
        if(StatisticsViewController.showOnlyOneDay == false)
        {
            txtDate.text = firstDate + "-" + currDate
        }
        else{
            txtDate.text = firstDate
        }
        StatisticsViewController.showOnlyOneDay = false
        
        typeNameArray = [String]()
        iconArray = [String]()
        valueArray = [Double]()
        
        var showCode = 0
        if (showIncome == true){
            showCode = 1
        }
        //Lay du lieu tu dbs
        let sql = "Select * From (Select Sum(SoTien), MaNhom From GiaoDich Where ThoiDiem >= '" + StatisticsViewController.date1 + "' AND ThoiDiem <= '" + StatisticsViewController.date2 + "' GROUP BY MaNhom) as A JOIN Nhom WHERE NHOM.MA = A.MANHOM and Nhom.Loai = \(showCode)"
        print(sql)
        
        
        let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        //Lay data
        let statement:OpaquePointer = Select(query: sql, database: database)
        
        var i = -1
        var otherSum = 0.0
        
        // Do du lieu vao mang
        while sqlite3_step(statement) == SQLITE_ROW {
            i += 1
            if(i < 5)
            {
                // Do ra tung cot tuong ung voi no
                if(sqlite3_column_text(statement, 0) != nil)
                {
                    if(sqlite3_column_text(statement, 3) != nil)
                    {
                        
                        let fieldValue = String(cString: sqlite3_column_text(statement, 3))
                        typeNameArray.append(fieldValue)
                        print(fieldValue)
                    }
                    if(sqlite3_column_text(statement, 4) != nil)
                    {
                        iconArray.append(String(cString: sqlite3_column_text(statement, 4)))
                    }
                    if(sqlite3_column_text(statement, 0) != nil)
                    {
                        valueArray.append(Double(sqlite3_column_double(statement, 0)))
                        
                    }
                }
            }
            else
            {
                // Do ra tung cot tuong ung voi no
                if(sqlite3_column_text(statement, 0) != nil)
                {
                    if(sqlite3_column_text(statement, 0) != nil)
                    {
                        let num = Swift.abs(Double(sqlite3_column_double(statement, 0)))
                        otherSum += num
                        
                    }
                }
                
            }
            
            //let rowData = sqlite3_column_text(statement, 1)
            // Neu cot nao co dau tieng viet thi can phai lam them buoc nay
            //let fieldValue = String(cString: rowData!)
            // Them Vao mang da co
            //mang.append(fieldValue!)
        }
        if (otherSum != 0.0)
        {
            valueArray.append(otherSum)
            typeNameArray.append("Khác")
            
        }
        
        sum = 0.0;
        for i in 0..<valueArray.count{
            if(valueArray[i] < 0){
                valueArray[i] *= -1
            }
            sum += valueArray[i];
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(database)
        
        print(typeNameArray)
        print(valueArray)
        
        //        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        //        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        
        //pieChartView = PieChartView(frame: self.view.bounds)
        //self.view.addSubview(pieChartView!)
        setChart(dataPoints: typeNameArray, values: valueArray)
        
        //NDS
        
        isFilterByWallet = false
        isAddTransaction = false
        currentTabBarItem = 3
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        tableView.reloadData()
        
        if wallet_GV != nil {
            SelectWallet_Button.setImage(UIImage(named: (wallet_GV?.Icon)!), for: .normal)
        }else {
            SelectWallet_Button.setImage(#imageLiteral(resourceName: "All-Wallet-2-icon"), for: .normal)
        }
        
        if(i == -1)//Khong co ket qua
        {
            txtNotif.text = "Không có giao dịch trong khoảng thời gian này!"
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SelectWallet_ButtonTapped(_ sender: Any) {
        isFilterByWallet = true
        pushToVC(withStoryboardID: "WalletVC",animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StatisticTableViewCell
        
        cell.Image_Color.backgroundColor = colors[indexPath.row]
        
        let percent = String(format:"%.02f", valueArray[indexPath.row]/sum*100)
        cell.LabelName.text = typeNameArray[indexPath.row]
        var str = ""
        if(showIncome == false){
            str = "-"
        }
        let tmp = valueArray[indexPath.row].VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!)
        
        let currencyStr = "\(tmp)" + (currency_GV?.Symbol)!
//      str + "\(valueArray[indexPath.row]) - (" + percent + "%) "
        cell.Label_Value.text = str + currencyStr + " - (" + percent + "%) "
        return cell
    }
    
    //select a row
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {//do something
//    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry1)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        //pieChartDataSet.colors = ChartColorTemplates.colorful()
        
        colors = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        pieChartDataSet.colors = colors
        //pieChartDataSet.drawIconsEnabled = false
        pieChartDataSet.drawValuesEnabled = false
        
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.highlightPerTapEnabled = true
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawEntryLabelsEnabled = false
        
        
        
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInSine)
        pieChartView.chartDescription?.text = ""
    }
    
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

class StatisticTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Image_Color: UIImageView!
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var Label_Value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
