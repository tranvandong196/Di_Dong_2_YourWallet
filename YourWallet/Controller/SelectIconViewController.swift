//
//  SelectIconViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 19/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class SelectIconViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconName = "ATM-4-icon"
        
//        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddWalletVC") as? AddWalletViewController
//        {
//            viewController.iconName = "ATM-4-icon"
//            print(viewController.iconName!)
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
