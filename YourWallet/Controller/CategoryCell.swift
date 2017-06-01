//
//  CategoryCell.swift
//  YourWallet
//
//  Created by Tran Van Dong on 2/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var CategoryIcon_ImageView: UIImageView!
    @IBOutlet weak var CategoryName_Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
