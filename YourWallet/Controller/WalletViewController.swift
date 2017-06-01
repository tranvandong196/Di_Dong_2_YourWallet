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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = isSelectWallet ? true:false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let db = Connect_DB_SQLite(dbName: DBName, type: DBType)
        Wallets = GetWalletsFromSQLite(query: "SELECT * FROM ViTien", database: db)
        sqlite3_close(db)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
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
        return section == 0 ? 1:Wallets.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80:70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalWallet", for: indexPath) as! AllWalletCell
            cell.TotalMoney_Label.text = "chưa tính"
            if isSelectWallet && wallet_GV == nil{
                cell.accessoryType = .checkmark
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListWallet", for: indexPath) as! WalletCell
            cell.WalletIcon_ImageView.image = UIImage(named: Wallets[indexPath.row].Icon)
            cell.WalletName_Label.text = Wallets[indexPath.row].Name
            cell.WalletEndingBalance_Label.text = "Chưa tính"
            
            if isSelectWallet && wallet_GV?.ID == Wallets[indexPath.row].ID{
                cell.accessoryType = .checkmark
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelectWallet{
            if indexPath.section == 0{
                wallet_GV = nil
                UserDefaults.standard.setValue(Int(-1), forKey: "Wallet")
                print("Chọn tất cả ví")
            }else{
                wallet_GV = Wallets[indexPath.row]
                UserDefaults.standard.setValue(Wallets[indexPath.row].ID, forKey: "Wallet")
                print("Đã chọn \(Wallets[indexPath.row].Name!)")
            }
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            }
            self.navigationController?.popViewController(animated: true)
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
