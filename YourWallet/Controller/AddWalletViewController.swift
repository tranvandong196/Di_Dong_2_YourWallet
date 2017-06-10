//
//  AddWalletViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 2/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class AddWalletViewController: UIViewController{

    @IBOutlet weak var WalletIcon_ImageView: UIImageView!
    @IBOutlet weak var WalletName_textField: UITextField!
    @IBOutlet weak var currCurrency_btn: UIButton!
    @IBOutlet weak var currAmount_txtField: UITextField!
    
    @IBOutlet weak var Save_Button: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    @IBAction func Cancel_ButtonTapped(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = isSelectWallet ? true: false
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Save_ButtonTapped(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = isSelectWallet ? true: false
        //Thao tác lưu ở đây
        
        let walletName = WalletName_textField.text!
        let moneyAmount = Double(currAmount_txtField.text!)!
        let currency = currCurrency_btn.titleLabel!.text!
        let walletIcon = "Vi-icon"
        
        let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        let sqlQueryStr = "INSERT INTO ViTien (Ma,Ten,TienTe,TongGiaTri,Icon) VALUES (null, '\(walletName)', '\(currency)', \(moneyAmount), '\(walletIcon)')"
        
        Query(Sql: sqlQueryStr, database: database)
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
