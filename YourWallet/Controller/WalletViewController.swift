//
//  WalletViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var Wallets = [Wallet]()
    @IBOutlet weak var Wallets_TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("🖥 Ví --------------------------------")
        if !isAddTransaction{
            currentTabBarItem = 1
        }
        
        isAddWallet = false
        self.tabBarController?.tabBar.isHidden = isFilterByWallet ? true:false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let db = Connect_DB_SQLite(dbName: DBName, type: DBType)
        Wallets = GetWalletsFromSQLite(query: "SELECT * FROM ViTien ORDER BY Ten", database: db)
        sqlite3_close(db)
        Wallets_TableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddWallet_ButtonTapped(_ sender: Any) {
        isAddWallet = true
        pushToVC(withStoryboardID: "AddWalletVC", animated: true)
    }
    
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFilterByWallet || isAddWallet || isAddTransaction || isAddBudget{
            Wallets_TableView.allowsSelection = true
        }else {
            Wallets_TableView.allowsSelection = false
        }
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0:40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tính vào tổng"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = !isAddTransaction ? 1:0
        return section == 0 ? num:Wallets.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80:70
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false:true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalWallet", for: indexPath) as! AllWalletCell
            var sum:Double = 0
            for w in Wallets{
                sum += w.Balance!
            }
            let sumstr:String = sum.VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!)
            
            cell.TotalMoney_Label.text = "\(sumstr)" + (currency_GV?.Symbol)!
            if isFilterByWallet && wallet_GV == nil{
                cell.accessoryType = .checkmark
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListWallet", for: indexPath) as! WalletCell
            cell.WalletIcon_ImageView.image = UIImage(named: Wallets[indexPath.row].Icon)
            cell.WalletName_Label.text = Wallets[indexPath.row].Name
            let tmp = Wallets[indexPath.row].Balance!.VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!)
            cell.WalletEndingBalance_Label.text = "\(tmp)" + (currency_GV?.Symbol)!
            if isFilterByWallet && wallet_GV?.ID == Wallets[indexPath.row].ID{
                cell.accessoryType = .checkmark
            }
            if !isFilterByWallet && wallet_detail != nil && (wallet_detail?.ID)! == Wallets[indexPath.row].ID{
                cell.accessoryType = .checkmark
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFilterByWallet{
            if indexPath.section == 0{
                wallet_GV = nil
                UserDefaults.standard.setValue(Int(-1), forKey: "Wallet")
                print("Chọn tất cả ví")
            }else{
                wallet_GV = Wallets[indexPath.row]
                UserDefaults.standard.setValue(Wallets[indexPath.row].ID, forKey: "Wallet")
                print("Đã chọn ví: \(Wallets[indexPath.row].Name!)")
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            wallet_detail = Wallets[indexPath.row]
            self.navigationController?.popViewController(animated: true)
            //pushToVC(withStoryboardID: "ID Màn hình xem chi tiết ví", animated: true)
        }
        
    }
    
    //Thêm tuỳ chọn khi vuốt cell trừ phải qua trái
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "✏️") { (rowAction, indexPath) in
            wallet_detail = self.Wallets[indexPath.row]
            self.pushToVC(withStoryboardID: "AddWalletVC", animated: true)
        }
        let delAction = UITableViewRowAction(style: .normal, title: "🗑") { (rowAction, indexPath) in
            let sheetCtrl = UIAlertController(title: "Xoá ví này?", message: "⚠️Lưu ý: Tất cả giao dịch và ngân sách thuộc ví này sẽ bị mất!", preferredStyle: .actionSheet)
            
            let action = UIAlertAction(title: "Xoá", style: .destructive) { _ in
                let IDw:Int = self.Wallets[indexPath.row].ID
                let Namew:String = self.Wallets[indexPath.row].Name
                
                let DB = Connect_DB_SQLite(dbName: DBName, type: DBType)
                if Query(Sql: "DELETE FROM ViTien WHERE Ma = \(IDw)", database: DB){
                    print("🗑 Đã xoá ví: \(Namew)")
                    
                    if wallet_GV != nil && (wallet_GV?.ID)! == IDw {
                        wallet_GV = nil
                        UserDefaults.standard.setValue(Int(-1), forKey: "Wallet")
                        print("Chọn tất cả ví")
                    }
                    
                    self.Wallets = GetWalletsFromSQLite(query: "SELECT * FROM ViTien ORDER BY Ten", database: DB)
                    self.Wallets_TableView.reloadData()
                    
                    if Query(Sql: "DELETE FROM GiaoDich WHERE MaVi = \(IDw)", database: DB){
                        print("🗑 Đã xoá toàn bộ giao dịch từ ví: \(Namew)")
                    }
                    if Query(Sql: "DELETE FROM NganSach WHERE MaVi = \(IDw)", database: DB){
                        print("🗑 Đã xoá toàn bộ ngân sách từ ví: \(Namew)")
                    }
                }
                sqlite3_close(DB)
            }
            
            let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel){ _ in
                self.Wallets_TableView.setEditing(false, animated: true)
            }
            sheetCtrl.addAction(action)
            sheetCtrl.addAction(cancelAction)
            
            self.present(sheetCtrl, animated: true, completion: nil)
        }
        editAction.backgroundColor = UIColor.init(red: 28.0/255.0, green: 179.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        delAction.backgroundColor = UIColor.red
        return (isFilterByWallet || isAddWallet || isAddTransaction || isAddBudget) ? [editAction]:[editAction,delAction]
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
