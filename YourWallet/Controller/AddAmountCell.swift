//
//  AddAmountCell.swift
//  YourWallet
//
//  Created by Tran Van Dong on 1/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
import Foundation
class AddAmountCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var selectCurrency_Button: UIButton!
    @IBOutlet weak var addAmount_TextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addAmount_TextField.delegate = self
        //selectCurrency_Button.setTitle("USD", for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
