//
//  DetailTransactionViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 10/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class DetailTransactionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let dateFormattor = DateFormatter()
    @IBOutlet weak var DetailTransaction_TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormattor.timeZone = TimeZone.init(abbreviation: "UTC") //Tránh tự động cộng giờ theo vùng
        dateFormattor.dateFormat = "M yyyy, EEEE"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        isAddTransaction = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EditTransaction_ButtonTapped(_ sender: Any) {
        //isAddTransaction = true
        //pushToVC(withStoryboardID: "AddTransactionVC", animated: true)
    }
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3:1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 154
            }
            return 45
        }else{
            return 45
        }
    }
    let Cells = ["OverviewDetail_Cell","TimeDetail_Cell","WalletDetail_Cell", "DeleteTransaction_Cell"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                let cell0 = tableView.dequeueReusableCell(withIdentifier: Cells[0], for: indexPath) as! OverviewDetailCell
                cell0.CategoryIcon_ImageView.image = UIImage(named: (category_GV?.Icon)!)
                cell0.CategoryName_Label.text = category_GV?.Name
                cell0.NoteTransaction_Label.text = transaction_GV?.Name
                return cell0
            case 1:
                let cell1 = tableView.dequeueReusableCell(withIdentifier: Cells[1], for: indexPath) as! TimeDetailCell
                cell1.Time_Label.text = "thg " + dateFormattor.string(from: (transaction_GV?.Time)!)
                return cell1
            case 2:
                let cell2 = tableView.dequeueReusableCell(withIdentifier: Cells[2], for: indexPath) as! WalletDetailCell
                cell2.WalletIcon_ImageView.image = UIImage(named: (wallet_detail?.Icon)!)
                cell2.WalletName_Label.text = wallet_detail?.Name
                return cell2
                
            default:
                break
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells[3], for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        func deleteTrasactions(){
            let db = Connect_DB_SQLite(dbName: DBName, type: DBType)
            let ID:Int = (transaction_GV?.ID)!
            if Query(Sql: "DELETE FROM GiaoDich WHERE Ma = \(ID)", database: db){
                print("Đã xoá: \((transaction_GV?.Name)!) - \((transaction_GV?.Amount)!)\((currency_GV?.Symbol)!)")
            }
            sqlite3_close(db)
            self.navigationController?.popViewController(animated: true)
        }
        
        if indexPath.section == 1{
            let sheetCtrl = UIAlertController(title: "Xoá giao dịch này?", message: nil, preferredStyle: .actionSheet)

            let action = UIAlertAction(title: "Xoá", style: .destructive) { _ in
                deleteTrasactions()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            sheetCtrl.addAction(action)
            sheetCtrl.addAction(cancelAction)
            
            sheetCtrl.popoverPresentationController?.sourceView = self.view
            present(sheetCtrl, animated: true, completion: nil)
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
