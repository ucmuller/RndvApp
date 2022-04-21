//
//  InvitationTableViewCell.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/25.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit

class ReceiptItemCell: UITableViewCell {
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var staffNameLabel: UILabel!
    @IBOutlet weak var couponNumberLabel: UILabel!
    @IBOutlet weak var couponNameLabel: UILabel!
    
    var invitations: Invitation? {
        didSet {
            guard let invitation = invitations else { return }
            apply(invitation: invitation)
        }
    }

    let rewardPerPerson: Int = 300

    func apply(invitation: Invitation) {
        guestNameLabel.text = invitation.guestName != "" ? "\(invitation.guestName) さん" : "未記入"
        staffNameLabel.text = "\(invitation.staffName)"
        peopleLabel.text = invitation.people != 0 ? "\(invitation.people)人" : "未定"
        dateLabel.text = invitation.date != "" ? "\(invitation.date)" : "未定"
        timeLabel.text = invitation.time != "" ? "\(invitation.time)" : "未定"
        if let couponNumber = invitation.couponNumber, let couponName = invitation.couponName {
                couponNumberLabel.text = couponNumber != "" ? "No.\(couponNumber)" : ""
            if (couponName == "全店舗共通の一ヶ月間、ドリンク1杯無料チケット") {
                couponNameLabel.text = "1ヶ月ドリンク1杯無料"
            } else {
                couponNameLabel.text = couponName != "" ? "\(couponName)" : ""
            }
        } else {
            couponNumberLabel.text = ""
            couponNameLabel.text = ""
        }

//        alertLabelView.apply(receipt: Receipt)
//        statusView.apply(invitation: invitation)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let inset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        contentView.frame = contentView.frame.inset(by: inset)
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 4
    }
}
