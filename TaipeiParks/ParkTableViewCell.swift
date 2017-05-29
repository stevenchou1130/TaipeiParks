//
//  ParkTableViewCell.swift
//  TaipeiParks
//
//  Created by steven.chou on 2017/5/29.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class ParkTableViewCell: UITableViewCell {

    class var identifier: String {
        return String(describing: self)
    }

    @IBOutlet weak var parkImageView: UIImageView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
