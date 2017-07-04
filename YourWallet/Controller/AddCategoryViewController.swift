//
//  AddCategoryViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 2/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var CategoryName_Label: UITextField!
    @IBOutlet weak var SelectIconCategory_Button: UIButton!
    @IBOutlet weak var Save_Button: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        iconName = nil
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if iconName != nil{
            self.SelectIconCategory_Button.setImage(UIImage(named: iconName!), for: .normal)
        }
    }
    
    @IBAction func Cancel_ButtonTapped(_ sender: Any){
        self.tabBarController?.tabBar.isHidden = isSelectCategory ? true: false
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func Save_ButtonTapped(_ sender: Any) {
        if CategoryName_Label.text != ""{
            self.tabBarController?.tabBar.isHidden = isSelectCategory ? true: false
            //Thao tác lưu ở đây
            let name:String = CategoryName_Label.text!
            let DB = Connect_DB_SQLite(dbName: DBName, type: DBType)
            let sql = "INSERT INTO Nhom(Ma, Ten, Loai, Icon) VALUES(null, '\(name)', 1, '\(iconName!)')"
            print(sql)
            if Query(Sql: sql, database: DB){
                print("Đã thêm nhóm: \(name)")
            }
            sqlite3_close(DB)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func SelectIconCategory_ButtonTapped(_ sender: Any) {
        pushToVC(withStoryboardID: "SelectIconVC", animated: true)
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
