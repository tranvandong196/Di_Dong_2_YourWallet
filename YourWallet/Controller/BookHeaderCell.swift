//
//  BookHeaderCell.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class BookHeaderCell: UITableViewCell {

    @IBOutlet weak var CategoryIcon_ImageView: UIImageView!
    @IBOutlet weak var CategoryName_Label: UILabel!
    @IBOutlet weak var NumberTransacion_Label: UILabel!
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
