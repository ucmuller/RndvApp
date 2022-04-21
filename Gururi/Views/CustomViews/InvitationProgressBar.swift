//
//  InvitationProgressBarView.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/11/17.
//

import UIKit

class InvitationProgressBar: AutoLoadableView {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var progressBarItems: [InvitationProgressBarItem]!

    var indexForSelectedItem: Int = 0 {
        didSet {
            updateItems()
        }
    }

    override func setupViews() {
        for (item, status) in zip(progressBarItems, Invitation.Status.allCases) {
            item.title = status.title
        }
    }

    func updateItems() {
        for i in 0..<progressBarItems.count {
            if i == indexForSelectedItem {
                progressBarItems[i].isSelected = true
            }
            else {
                progressBarItems[i].isSelected = false
            }
        }
    }
}
