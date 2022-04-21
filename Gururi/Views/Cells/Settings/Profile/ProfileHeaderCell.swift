//
//  ProfileHeaderCell.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/10/17.
//

import UIKit

protocol ProfileHeaderCellDelegate {
    func profileHeaderCell(didTapSettingButton view: ProfileHeaderCell)
}

class ProfileHeaderCell: UITableViewCell {

    @IBOutlet weak var staffNameLabel: UILabel!
    @IBOutlet weak var staffRegisteredDateLabel: UILabel!
    
    var delegate: ProfileHeaderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func settingButtonPressed(_ sender: Any) {
        delegate?.profileHeaderCell(didTapSettingButton: self)
    }
    
    
}
