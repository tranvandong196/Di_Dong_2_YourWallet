//
//  PrimaryViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 17/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class PrimaryViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var SwitchLockApp_Switch: UISwitch!
    
    @IBOutlet weak var DescribeToUser_Label: UILabel!
    @IBOutlet weak var EnterPassword_TextField: UITextField!
    @IBOutlet weak var Result_Label: UILabel!
    
    @IBOutlet weak var DeletePassword_Button: UIButton!
    @IBOutlet weak var ChangePassword_Button: UIButton!
    var isSetPw = false
    var oldPw:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.EnterPassword_TextField.delegate = self
        EnterPassword_TextField.isHidden = true
        DescribeToUser_Label.isHidden = true
        Result_Label.alpha = 0
        if UserDefaults.standard.value(forKey: "Password") != nil{
            ChangePassword_Button.setTitle("Đổi mật khẩu", for: .normal)
            DeletePassword_Button.isHidden = false
            isSetPw = true
        }else{
            ChangePassword_Button.setTitle("Thêm mật khẩu", for: .normal)
            DeletePassword_Button.isHidden = true
        }
        if UserDefaults.standard.value(forKey: "isLockApp") != nil{
            SwitchLockApp_Switch.isOn = true
        }else{
            SwitchLockApp_Switch.isOn = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func SwitchLockApp_SwitchTapped(_ sender: Any) {
        if SwitchLockApp_Switch.isOn{
            if !isSetPw{
                alert(title: "Bạn chưa đặt mật khẩu!", message: nil)
                SwitchLockApp_Switch.isOn = false
            }else{
                UserDefaults.standard.setValue(1, forKey: "isLockApp")
            }
            return
        }else if isSetPw{
            SwitchLockApp_Switch.isOn = true
            DescribeToUser_Label.text = "Nhập mật khẩu để khoá"
            ShowEnterPassword()
            step = 5
        }
    }
    
    @IBAction func ChangePassword_ButtonTapped(_ sender: Any) {
        ShowEnterPassword()
        DescribeToUser_Label.text = !isSetPw ? "Nhập mật khẩu mới":"Nhập mật khẩu cũ"
        Result_Label.text = !isSetPw ? "Đã thêm mật khẩu mới":"Đổi mật khẩu thành công"

    }
    @IBAction func DeletePassword_ButtonTapped(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "Password") != nil{
            let sheetCtrl = UIAlertController(title: "Xoá mật khẩu?", message: nil, preferredStyle: .actionSheet)
            
            let action = UIAlertAction(title: "Xoá", style: .destructive) { _ in
                self.step = 4
                self.ShowEnterPassword()
                self.DescribeToUser_Label.text = "Nhập mật khẩu để xoá"
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            sheetCtrl.addAction(action)
            sheetCtrl.addAction(cancelAction)
            
            present(sheetCtrl, animated: true, completion: nil)
           
        }
    }
    
    var newPw = ""
    var step = 1
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !isSetPw{
            if textField.text!.characters.count == 3{
                if newPw == ""{
                    newPw = textField.text! + string
                    DescribeToUser_Label.textColor = UIColor.black
                    DescribeToUser_Label.text = "Nhập lại mật khẩu mới"
                }else{
                    if textField.text! + string != newPw{
                        DescribeToUser_Label.textColor = UIColor.red
                        DescribeToUser_Label.text = "Mật khẩu không trùng khớp!\nNhập mật khẩu mới"
                        newPw = ""
                    }else{
                        textField.endEditing(true)
                        UserDefaults.standard.setValue(newPw, forKey: "Password")
                        isSetPw = true
                        ChangePassword_Button.setTitle("Đổi mật khẩu", for: .normal)
                        DeletePassword_Button.isHidden = false
                        
                        HideEnterPassword()
                    }
                }
                
                textField.text = ""
                return false
            }
        }else{
            if textField.text!.characters.count == 3{
                switch step {
                case 1:
                    DescribeToUser_Label.textColor = UIColor.black
                    if textField.text! + string == oldPw{
                        step = 2
                        DescribeToUser_Label.text = "Nhập mật khẩu mới"
                    }else{
                        DescribeToUser_Label.textColor = UIColor.red
                        DescribeToUser_Label.text = "Sai mật khẩu!\nNhập mật khẩu cũ"
                    }
                case 2:
                    DescribeToUser_Label.textColor = UIColor.black
                    DescribeToUser_Label.text = "Nhập lại mật khẩu mới"
                    newPw = textField.text! + string
                    step = 3
                case 3:
                    if textField.text! + string != newPw{
                        step = 2
                        DescribeToUser_Label.textColor = UIColor.red
                        DescribeToUser_Label.text = "Mật khẩu không trùng khớp!\nNhập mật khẩu mới"
                    }else{
                        textField.endEditing(true)
                        UserDefaults.standard.setValue(newPw, forKey: "Password")
                        
                        HideEnterPassword()
                    }
                    newPw = ""
                case 4:
                    if textField.text! + string == oldPw{
                        UserDefaults.standard.removeObject(forKey: "Password")
                        self.isSetPw = false
                        self.DeletePassword_Button.isHidden = true
                        self.ChangePassword_Button.setTitle("Thêm mật khẩu", for: .normal)
                        
                        if SwitchLockApp_Switch.isOn{
                            SwitchLockApp_Switch.isOn = false
                            UserDefaults.standard.removeObject(forKey: "isLockApp")
                        }
                        
                        Result_Label.text = "Đã xoá mật khẩu"
                        HideEnterPassword()
                    }else{
                        DescribeToUser_Label.textColor = UIColor.red
                        DescribeToUser_Label.text = "Sai mật khẩu!"
                    }
                case 5:
                    if textField.text! + string == oldPw{
                        UserDefaults.standard.removeObject(forKey: "isLockApp")
                        SwitchLockApp_Switch.isOn = false
                        
                        Result_Label.text = "Đã tắt khoá bằng mật khẩu"
                        HideEnterPassword()
                    }else{
                        DescribeToUser_Label.textColor = UIColor.red
                        DescribeToUser_Label.text = "Sai mật khẩu!"
                    }
                default:
                    break
                }
                
                textField.text = ""
                return false
            }
        }
        
        return true
    }
    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        HideEnterPassword(true)
    }
    func ShowEnterPassword(){
        if UserDefaults.standard.value(forKey: "Password") != nil{
            oldPw = UserDefaults.standard.value(forKey: "Password") as! String
        }
        EnterPassword_TextField.isHidden = false
        DescribeToUser_Label.isHidden = false
        EnterPassword_TextField.becomeFirstResponder()
        DescribeToUser_Label.textColor = UIColor.black
    }
    func HideEnterPassword(_ isHiddenResult:Bool = false){
        DescribeToUser_Label.isHidden = true
        EnterPassword_TextField.text = ""
        EnterPassword_TextField.isHidden = true
        EnterPassword_TextField.endEditing(true)
        
        if !isHiddenResult{
            Result_Label.alpha = 0
            Result_Label.fadeIn(withDuration: 1.2)
            Result_Label.fadeOut(withDuration: 1.2)
        }
        newPw = ""
        step = 1
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
