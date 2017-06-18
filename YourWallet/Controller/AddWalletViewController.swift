//
//  AddWalletViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 2/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class AddWalletViewController: UIViewController,UITextFieldDelegate{


    @IBOutlet weak var WalletName_textField: UITextField!
    @IBOutlet weak var currCurrency_btn: UIButton!
    @IBOutlet weak var currAmount_txtField: UITextField!
    @IBOutlet weak var WalletIcon_Button: UIButton!
    
    @IBOutlet weak var Save_Button: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        iconName = nil
        self.WalletName_textField.delegate = self
        currCurrency_btn.layer.cornerRadius = 3
        currCurrency_btn.layer.borderWidth = 0.7
        currCurrency_btn.layer.borderColor = UIColor.lightGray.cgColor
        currCurrency_btn.setTitle(currency_GV?.ID, for: .normal)
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if iconName != nil{
            WalletIcon_Button.setImage(UIImage(named: iconName!), for: .normal)
        }
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
        let walletIcon:String = iconName != nil ? iconName!:""
        
        let database = Connect_DB_SQLite(dbName: DBName, type: DBType)
        let sqlQueryStr = "INSERT INTO ViTien (Ma,Ten,TienTe,TongGiaTri,SoDu,Icon) VALUES (null, '\(walletName)', '\(currency)', \(moneyAmount),\(moneyAmount), '\(walletIcon)')"
        
        if Query(Sql: sqlQueryStr, database: database){
            print("Đã thêm ví: \(walletName)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func WalletIcon_ButtonTapped(_ sender: Any) {
        //chọn được icon phù hợp và gán tên icon và biến iconName (Hàm test thử trong viewDidload)
        pushToVC(withStoryboardID: "SelectIconVC", animated: true)
    }
    //Hide or switch next keyboard when user Presses "return" key (for textField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return true
    }
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
