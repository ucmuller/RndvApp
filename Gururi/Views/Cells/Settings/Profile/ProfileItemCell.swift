//
//  ProfileItemCell.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/10/17.
//

import UIKit

class ProfileItemCell: UITableViewCell {
    
    @IBOutlet weak var profileItemNameLabel: UILabel!
    @IBOutlet weak var profileItemDataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
