//
//  SelectIconViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 19/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class SelectIconViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var Coll: UICollectionView!
    var Icons = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Coll.delegate = self
        Coll.dataSource = self
        
        let DB = Connect_DB_SQLite(dbName: DBName, type: DBType)
        Icons = GetIconNameFromSQLite(query: "SELECT * FROM BieuTuong", database:  DB  )
        sqlite3_close(DB)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: *** CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Icons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SelectIconCell
        Cell.CategoryIcon_Imageview.image = UIImage(named: Icons[indexPath.row])
        return Cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        iconName =  Icons[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
    //  MARK: ***Fuction
    func GetIconNameFromSQLite(query: String, database: OpaquePointer?) -> [String]{
        var Icons = [String]()
        var queryStatement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
            while sqlite3_step(queryStatement) == SQLITE_ROW{sqlite3_column_text(queryStatement, 1)
                if sqlite3_column_text(queryStatement, 0) != nil {
                    let n:String = String(cString: sqlite3_column_text(queryStatement, 0))
                    Icons.append(n)
                }
            }
        }
        return Icons
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
