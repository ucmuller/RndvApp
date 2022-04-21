//
//  SettingsHeaderCell.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/10/16.
//

import UIKit

class SettingsHeaderCell: UITableViewCell {
    
    @IBOutlet weak var staffNameLabel: UILabel!
    @IBOutlet weak var staffRegisteredDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
