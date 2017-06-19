//
//  AddBudgetViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 19/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class AddBudgetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func Cancel_ButtonTapped(_ sender: Any) {
        //Huỷ ở đây
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func Save_ButtonTapped(_ sender: Any) {
        //Lưu ở đây
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
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
