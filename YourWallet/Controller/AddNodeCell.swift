//
//  AddNodeCell.swift
//  YourWallet
//
//  Created by Tran Van Dong on 1/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class AddNodeCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var addNote_TextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addNote_TextField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //addNote_TextField
        // Configure the view for the selected state
    }
    //Hide or switch next keyboard when user Presses "return" key (for textField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return true
    }

}
