//
//  BookViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class BookViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var previousDay_Button: UIButton!
    @IBOutlet weak var currentDay_Button: UIButton!
    @IBOutlet weak var nextDay_Button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.navigationController?.navigationBar.barTintColor = UIColor.green
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SwipeRight_Gesture(_ sender: Any) {
        previousDay_Button.setTitle("29/05/2017", for: .normal)
        currentDay_Button.setTitle("HÔM QUA", for: .normal)
        nextDay_Button.setTitle("HÔM NAY", for: .normal)
        
        print("Thao tác vuốt phải thành công")
    }
    
    @IBAction func SwipeLeft_Gesture(_ sender: Any) {
        previousDay_Button.setTitle("HÔM NAY", for: .normal)
        currentDay_Button.setTitle("NGÀY MAI", for: .normal)
        nextDay_Button.setTitle("31/05/2017", for: .normal)
        print("Thao tác vuốt trái thành công")
    }
    
    
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! BookHeaderCell
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! BookTransactionCell
        return cell
        
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
