//
//  AddTransaction ViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class AddTransaction_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var NewTransaction_TableView: UITableView!
    
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
        isSelectCategory = false
        isSelectWallet = false
        isAddTransaction = true
        NewTransaction_TableView.reloadData()
        self.tabBarController?.tabBar.isHidden = true
            //self.navigationController?.navigationBar.barTintColor = UIColor.green
    }
    @IBAction func Cancel_ButtonTapped(_ sender: Any) {
        category_GV = nil
        isAddTransaction = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Save_ButtonTapped(_ sender: Any) {
        category_GV = nil
        isAddTransaction = false
        // Thao tác lưu vài CSDL ở đây
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: ** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5:1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 87
            }
            return indexPath.row == 1 ? 72:48
        }else{
            return 48
        }
    }
    let Cells = ["Add-Amount-Cell","Select-Category-Cell","Add-Note-Cell","Change-Time-Cell","Select-Wallet-Cell"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell0 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! AddAmountCell
            cell0.selectionStyle = .none
            cell0.selectCurrency_Button.layer.cornerRadius = 3
            cell0.selectCurrency_Button.layer.borderWidth = 0.7
            cell0.selectCurrency_Button.layer.borderColor = UIColor.lightGray.cgColor
            
            addDoneButton(to: cell0.addAmount_TextField)
            return cell0
        case 1:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! SelectCategoryCell
            if category_GV != nil{
                cell1.categoryIcon_ImageView.image = UIImage(named: (category_GV?.Icon)!)
                cell1.categoryName_Label.textColor = UIColor.black
                cell1.categoryName_Label.text = category_GV?.Name
            }
            return cell1
        case 2:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! AddNodeCell
            return cell2
        case 3:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! ChangeTimeCell
            return cell3
        default:
            let cell4 = tableView.dequeueReusableCell(withIdentifier: Cells[indexPath.row], for: indexPath) as! SelectWalletCell
            if wallet_GV != nil{
                cell4.WalletIcon_ImageView.image = UIImage(named: (wallet_GV?.Icon)!)
                cell4.WalletName_Label.text = wallet_GV?.Name
                
            }else{
                cell4.WalletIcon_ImageView.image = #imageLiteral(resourceName: "SelectCategory-Circle-icon")
                cell4.WalletName_Label.textColor = UIColor.lightGray
                cell4.WalletName_Label.text =  "Chọn ví"
            }
            
            return cell4
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            isSelectCategory = true
            self.tabBarController?.tabBar.isHidden = true
            pushToVC(withStoryboardID: "CategoryVC", animated: true)
        }
        if indexPath.row == 4{
            isSelectWallet = true
            self.tabBarController?.tabBar.isHidden = true
            pushToVC(withStoryboardID: "WalletVC", animated: true)
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
