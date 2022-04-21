//
//  InvitationCellAlertLabelView.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/16.
//

import UIKit

class InvitationCellAlertLabelView: AutoLoadableView {
    @IBOutlet weak var alertLabel: UILabel!

    func apply(invitation: Invitation) {
        alertLabel.text = invitation.status.alertText
        switch invitation.status {
        case .invited, .reviewing, .approved, .paid:
            isHidden = true
        case .waiting:
            isHidden = false
        }
    }
}
