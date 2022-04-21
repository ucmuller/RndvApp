//
//  InvitationProgressBarItem.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/11/17.
//

import UIKit

class InvitationProgressBarItem: AutoLoadableView {
    @IBOutlet weak var titleLabel: UILabel!

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var isSelected: Bool = false {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        backgroundColor = isSelected ? RndvColor.greenColor : RndvColor.lightGreenColor
    }
}
