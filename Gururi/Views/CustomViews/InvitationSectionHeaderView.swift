//
//  InvitationSectionHeaderView.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/09/23.
//

import UIKit

class InvitationSectionHeaderView: UITableViewHeaderFooterView {
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = RndvColor(name: "yellow")?.uiColor
    }
}
