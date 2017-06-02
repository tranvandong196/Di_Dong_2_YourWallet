//
//  BookTransactionCell.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class BookTransactionCell: UITableViewCell {

    @IBOutlet weak var Day_Label: UILabel!
    @IBOutlet weak var MonthYear_Label: UILabel!
    @IBOutlet weak var TransactionName_Label: UILabel!
    @IBOutlet weak var Amount_Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
