//
//  EnterPasswordViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 17/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class EnterPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var EnterPassword_TextField: UITextField!
    @IBOutlet weak var DescribeToUser_Label: UILabel!
    var Pw:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.value(forKey: "Password") != nil){
            Pw = UserDefaults.standard.value(forKey: "Password") as! String
        }
        self.EnterPassword_TextField.delegate = self
        EnterPassword_TextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Do anything when textView changed (when user typing on textView)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count == 3 {
            if textField.text! + string == Pw{
                performSegue(withIdentifier: "MoveToHomeVC", sender: nil)
                print("Mật khẩu là: \(String(describing: textField.text! + string))")
            }else{
                DescribeToUser_Label.textColor = UIColor.red
                DescribeToUser_Label.text = "Sai mật khẩu!"
                textField.text = ""
                return false
            }
            
        }
        return true
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
