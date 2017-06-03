//
//  SelectTimeViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 3/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class SelectTimeViewController: UIViewController {
    var timeSelected:Date!
    override func viewDidLoad() {
        super.viewDidLoad()
        timeSelected = Date()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Done_ButtonTapped(_ sender: Any) {
        
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
