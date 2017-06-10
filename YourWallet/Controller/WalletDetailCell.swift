//
//  WalletDetailCell.swift
//  YourWallet
//
//  Created by Tran Van Dong on 10/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class WalletDetailCell: UITableViewCell {

    @IBOutlet weak var WalletIcon_ImageView: UIImageView!
    @IBOutlet weak var WalletName_Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
