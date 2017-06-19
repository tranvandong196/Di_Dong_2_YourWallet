//
//  CategoryViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 2/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var CategoriesIn = [Category]()
    var CategoriesOut = [Category]()
    @IBOutlet weak var Categories_TableView: UITableView!
    @IBOutlet weak var KindOfCategory_SegmentedControl: UISegmentedControl!
    var segment:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        KindOfCategory_SegmentedControl.selectedSegmentIndex = category_GV == nil ? segment:(category_GV?.Kind)!
        segment = KindOfCategory_SegmentedControl.selectedSegmentIndex
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("🖥 Nhóm --------------------------------")
        self.tabBarController?.tabBar.isHidden = (isAddTransaction || isAddWallet) ? true:false
        let database = Connect_DB_SQLite(dbName: DBName, type: DBType)

        CategoriesOut = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom WHERE Loai = 0", database: database)
        CategoriesIn = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom WHERE Loai = 1", database: database)
        sqlite3_close(database)
        
        Categories_TableView.reloadData()

    }
    @IBAction func KindOfCategory_SegmentedControlTapped(_ sender: Any) {
        segment = KindOfCategory_SegmentedControl.selectedSegmentIndex
        self.Categories_TableView.reloadData()
    }
    @IBAction func addCategory_ButtonTapped(_ sender: Any) {
        pushToVC(withStoryboardID: "AddCategoryVC", animated: true)
    }
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        self.Categories_TableView.allowsSelection = (isAddTransaction || isAddBudget) ? true:false
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segment == 0 ? CategoriesOut.count:CategoriesIn.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category-Cell", for: indexPath) as! CategoryCell
        
        let nameIcon = segment == 0 ? CategoriesOut[indexPath.row].Icon:CategoriesIn[indexPath.row].Icon
        cell.CategoryIcon_ImageView.image = UIImage(named: nameIcon!)
        cell.CategoryName_Label.text = segment == 0 ? CategoriesOut[indexPath.row].Name:CategoriesIn[indexPath.row].Name
        
        if isSelectCategory && category_GV?.ID != nil {
            let ID = segment == 0 ? CategoriesOut[indexPath.row].ID:CategoriesIn[indexPath.row].ID
            cell.accessoryType = category_GV?.ID == ID ? .checkmark:.none
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category_GV = segment == 0 ? CategoriesOut[indexPath.row]:CategoriesIn[indexPath.row]
        
        if isSelectCategory{
            self.navigationController?.popViewController(animated: true)
        }else{
            //pushToVC(withStoryboardID: "ID của màn hình xem chi tiết nhóm", animated: true)
        }
    }
    //Thêm tuỳ chọn khi vuốt cell trừ phải qua trái
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "✏️") { (rowAction, indexPath) in
            category_GV = self.segment == 0 ? self.CategoriesOut[indexPath.row]:self.CategoriesIn[indexPath.row]
            //self.pushToVC(withStoryboardID: "AddWallet_VC", animated: true)
        }
        let delAction = UITableViewRowAction(style: .normal, title: "🗑") { (rowAction, indexPath) in
            let sheetCtrl = UIAlertController(title: "Xoá nhóm này?", message: "⚠️Lưu ý: Tất cả giao dịch và ngân sách thuộc nhóm này sẽ bị mất!", preferredStyle: .actionSheet)
            
            let action = UIAlertAction(title: "Xoá", style: .destructive) { _ in
                let IDc:Int = self.segment == 0 ? self.CategoriesOut[indexPath.row].ID:self.CategoriesIn[indexPath.row].ID
                let Namec:String = self.segment == 0 ? self.CategoriesOut[indexPath.row].Name:self.CategoriesIn[indexPath.row].Name
                
                let DB = Connect_DB_SQLite(dbName: DBName, type: DBType)
                if Query(Sql: "DELETE FROM Nhom WHERE Ma = \(IDc)", database: DB){
                    print("🗑 Đã xoá nhóm: \(Namec)")
                    
                    if self.segment == 0 {
                        self.CategoriesOut = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom WHERE Loai = 1", database: DB)
                    }else {
                        self.CategoriesIn = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom WHERE Loai = 1", database: DB)
                    }
                    self.Categories_TableView.reloadData()
                    
                    if Query(Sql: "DELETE FROM GiaoDich WHERE MaNhom = \(IDc)", database: DB){
                        print("🗑 Đã xoá toàn bộ giao dịch thuộc nhóm: \(Namec)")
                    }
                    if Query(Sql: "DELETE FROM NganSach WHERE MaNhom = \(IDc)", database: DB){
                        print("🗑 Đã xoá toàn bộ ngân sách thuộc nhóm: \(Namec)")
                    }
                }
                sqlite3_close(DB)
            }
            
            let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel){ _ in
                self.Categories_TableView.setEditing(false, animated: true)
            }
            sheetCtrl.addAction(action)
            sheetCtrl.addAction(cancelAction)
            
            self.present(sheetCtrl, animated: true, completion: nil)
        }
        editAction.backgroundColor = UIColor.init(red: 28.0/255.0, green: 179.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        delAction.backgroundColor = UIColor.red
        return (isAddTransaction || isAddBudget) ? [editAction]:[editAction,delAction]
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
