//
//  InvitationCellStatusView.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/15.
//

import UIKit

class InvitationCellStatusView: AutoLoadableView {
    @IBOutlet weak var titleLabel: UILabel!

    func apply(invitation: Invitation) {
        switch invitation.status {
        case .invited:
            titleLabel.text = invitation.status.title
        case .waiting, .reviewing:
            titleLabel.text = "予約確定"
        case .approved, .paid:
            if let rewardPrice = invitation.rewardPrice {
                titleLabel.text = "報酬確定\n¥\(rewardPrice)"
            }
        }
    }
}
