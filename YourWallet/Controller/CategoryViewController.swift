//
//  CategoryViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 2/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    //var CategoriesIn = [Category]()
    //var CategoriesOut = [Category]()
    var Categories = [Category]()
    var Categories_Backup = [Category]()
    @IBOutlet weak var Categories_TableView: UITableView!
    @IBOutlet weak var KindOfCategory_SegmentedControl: UISegmentedControl!
    var segment:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        KindOfCategory_SegmentedControl.selectedSegmentIndex = category_GV == nil ? segment:(category_GV?.Kind)!
        segment = KindOfCategory_SegmentedControl.selectedSegmentIndex
        searchBarSetup()
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

        //CategoriesOut = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom WHERE Loai = 0", database: database)
        //CategoriesIn = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom WHERE Loai = 1", database: database)
        Categories = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom", database: database)
        Categories_Backup = Categories
        sqlite3_close(database)
        
        filterTableView(ind: segment, searchText: nil)

    }
    @IBAction func KindOfCategory_SegmentedControlTapped(_ sender: Any) {
        segment = KindOfCategory_SegmentedControl.selectedSegmentIndex
        self.filterTableView(ind: segment, searchText: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchBarSetup()
       
    }
    @IBAction func addCategory_ButtonTapped(_ sender: Any) {
        pushToVC(withStoryboardID: "AddCategoryVC", animated: true)
    }
    
    // MARK: *** SearchBar
    func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 35))
        //searchBar.showsScopeBar = true
        //searchBar.scopeButtonTitles = ["Chi tiêu","Thu nhập"]
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        //searchBar.selectedScopeButtonIndex = 0
        self.Categories_TableView.tableHeaderView = searchBar
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchBar.setShowsCancelButton(false, animated: true)
        filterTableView(ind: segment, searchText: nil)
        searchBar.text = nil
        searchBar.resignFirstResponder()
        //self.searchDisplayController?.setActive(false, animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(ind: segment,searchText: searchBar.text)
    }
    func filterTableView(ind:Int,searchText: String?){
        Categories = Categories_Backup.filter({(mod) -> Bool in
            return mod.Kind == ind
        })
        if searchText != nil && searchText! != ""{
            Categories = Categories.filter({(mod) -> Bool in
                return mod.Name!.lowercased().contains(searchText!.lowercased()) ? true:searchText!.lowercased().contains(mod.Name!.lowercased())
            })
        }
        self.Categories_TableView.reloadData()
    }

    
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        self.Categories_TableView.allowsSelection = (isAddTransaction || isAddBudget) ? true:false
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category-Cell", for: indexPath) as! CategoryCell
        
        cell.CategoryIcon_ImageView.image = UIImage(named: Categories[indexPath.row].Icon!)
        cell.CategoryName_Label.text = Categories[indexPath.row].Name
        
        if isSelectCategory && category_GV?.ID != nil {
            cell.accessoryType = category_GV?.ID == Categories[indexPath.row].ID ? .checkmark:.none
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category_GV = Categories[indexPath.row]
        
        if isSelectCategory{
            self.navigationController?.popViewController(animated: true)
        }else{
            //pushToVC(withStoryboardID: "ID của màn hình xem chi tiết nhóm", animated: true)
        }
    }
    //Thêm tuỳ chọn khi vuốt cell trừ phải qua trái
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "✏️") { (rowAction, indexPath) in
            category_GV = self.Categories[indexPath.row]
            self.pushToVC(withStoryboardID: "AddCategoryVC", animated: true)
        }
        let delAction = UITableViewRowAction(style: .normal, title: "🗑") { (rowAction, indexPath) in
            let sheetCtrl = UIAlertController(title: "Xoá nhóm này?", message: "⚠️Lưu ý: Tất cả giao dịch và ngân sách thuộc nhóm này sẽ bị mất!", preferredStyle: .actionSheet)
            
            let action = UIAlertAction(title: "Xoá", style: .destructive) { _ in
                let IDc:Int = self.Categories[indexPath.row].ID
                let Namec:String = self.Categories[indexPath.row].Name
                
                let DB = Connect_DB_SQLite(dbName: DBName, type: DBType)
                if Query(Sql: "DELETE FROM Nhom WHERE Ma = \(IDc)", database: DB){
                    print("🗑 Đã xoá nhóm: \(Namec)")
                    //self.Categories_TableView.deleteRows(at: [indexPath], with: .left)
                    self.Categories_Backup = GetCategoriesFromSQLite(query: "SELECT * FROM Nhom", database: DB)
                    self.filterTableView(ind: self.segment, searchText: nil)
                    
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
