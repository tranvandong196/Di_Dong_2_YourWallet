//
//  MoreViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 1/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var More_TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("🖥 Mở rộng --------------------------------")
        isAddTransaction = false
        currentTabBarItem = 4
        More_TableView.reloadData()
 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2:1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cellIden = indexPath.row == 0 ? "Budgets-Cell":"Categories-Cell"
            return tableView.dequeueReusableCell(withIdentifier: cellIden, for: indexPath)
            
        }
        if indexPath.section == 1{
            return tableView.dequeueReusableCell(withIdentifier: "SetCurrency-Cell", for: indexPath)
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "AboutUs-Cell", for: indexPath)
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
