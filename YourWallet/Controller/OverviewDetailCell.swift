//
//  OverviewDetailCell.swift
//  YourWallet
//
//  Created by Tran Van Dong on 10/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class OverviewDetailCell: UITableViewCell {

    @IBOutlet weak var Amount_Label: UILabel!
    @IBOutlet weak var NoteTransaction_Label: UILabel!
    @IBOutlet weak var CategoryName_Label: UILabel!
    @IBOutlet weak var CategoryIcon_ImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
