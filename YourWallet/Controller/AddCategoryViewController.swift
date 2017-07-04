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
    
    @IBOutlet weak var SelectKind_Segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Category_willEdit == nil{
            iconName = nil
            SelectKind_Segment.selectedSegmentIndex = 0
            
        }else{
            iconName = (Category_willEdit?.Icon)!
            SelectKind_Segment.selectedSegmentIndex = (Category_willEdit?.Kind)!
            CategoryName_Label.text = (Category_willEdit?.Name)!
            self.navigationItem.title = "Sửa nhóm"
        }

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if iconName != nil && iconName != ""{
            self.SelectIconCategory_Button.setImage(UIImage(named: iconName!), for: .normal)
        }else{
            self.SelectIconCategory_Button.setImage(#imageLiteral(resourceName: "SelectCategory-Circle-icon"), for: .normal)
        }
    }
    
    @IBAction func Cancel_ButtonTapped(_ sender: Any){
        Category_willEdit = nil
        self.tabBarController?.tabBar.isHidden = isSelectCategory ? true: false
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func Save_ButtonTapped(_ sender: Any) {
        if CategoryName_Label.text != ""{
            self.tabBarController?.tabBar.isHidden = isSelectCategory ? true: false
            //Thao tác lưu ở đây
            let name:String = CategoryName_Label.text!
            let kind:Int = SelectKind_Segment.selectedSegmentIndex
            let icon:String = iconName == nil ? "":iconName!
            let DB = Connect_DB_SQLite(dbName: DBName, type: DBType)
            if Category_willEdit == nil{
                let sql = "INSERT INTO Nhom(Ma, Ten, Loai, Icon) VALUES(null, '\(name)', \(kind), '\(icon)')"
                print(sql)
                if Query(Sql: sql, database: DB){
                    print("Đã thêm nhóm: \(name)")
                }
            }else{
                let sql = "UPDATE Nhom SET Ten = '\(name)', Loai = \(kind), Icon = '\(icon)' WHERE Ma = \((Category_willEdit?.ID)!)"
                print(sql)
                if Query(Sql: sql, database: DB){
                    print("Đã cập nhật nhóm: \(name)")
                }
                Category_willEdit = nil
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
