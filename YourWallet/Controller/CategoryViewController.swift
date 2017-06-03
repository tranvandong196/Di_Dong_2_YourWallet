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
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func addCategory_ButtonTapped(_ sender: Any) {
        pushToVC(withStoryboardID: "AddCategoryVC", animated: true)
    }
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Chi tiêu":"Thu nhập"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? CategoriesOut.count:CategoriesIn.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category-Cell", for: indexPath) as! CategoryCell
        
        let nameIcon = indexPath.section == 0 ? CategoriesOut[indexPath.row].Icon:CategoriesIn[indexPath.row].Icon
        cell.CategoryIcon_ImageView.image = UIImage(named: nameIcon!)
        cell.CategoryName_Label.text = indexPath.section == 0 ? CategoriesOut[indexPath.row].Name:CategoriesIn[indexPath.row].Name
        
        if isSelectCategory && category_GV?.ID != nil {
            let ID = indexPath.section == 0 ? CategoriesOut[indexPath.row].ID:CategoriesIn[indexPath.row].ID
            cell.accessoryType = category_GV?.ID == ID ? .checkmark:.none
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category_GV = indexPath.section == 0 ? CategoriesOut[indexPath.row]:CategoriesIn[indexPath.row]
        
        if isSelectCategory{
            self.navigationController?.popViewController(animated: true)
        }else{
            //pushToVC(withStoryboardID: "ID của màn hình xem chi tiết nhóm", animated: true)
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
