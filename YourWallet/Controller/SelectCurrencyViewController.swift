//
//  SelectCurrencyViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 16/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class SelectCurrencyViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var Currencies = [Currency]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let DB = Connect_DB_SQLite(dbName: DBName, type: DBType)
        Currencies = GetCurrenciesFromSQLite(query: "SELECT * FROM TienTe", database: DB)
        sqlite3_close(DB)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Currencies.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Currency-Cell", for: indexPath)
        cell.textLabel?.text = Currencies[indexPath.row].ID + "   ⇢   " + Currencies[indexPath.row].Name
        if (currency_GV?.ID)! == Currencies[indexPath.row].ID {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currency_GV = Currencies[indexPath.row]
        UserDefaults.standard.setValue(Currencies[indexPath.row].ID!, forKey: "Currency")
        
        print("Đã chọn tiền tệ: \(Currencies[indexPath.row].ID!)")
        
        self.navigationController?.popViewController(animated: true)
        
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
