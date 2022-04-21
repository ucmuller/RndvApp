//
//  SummaryHeaderCell.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/09/23.
//

import UIKit

class SummaryHeaderCell: UITableViewCell {
    @IBOutlet weak var totalPricePriceLabel: UILabel!
    @IBOutlet weak var totalPeopleLabel: UILabel!
    @IBOutlet weak var totalRewardPriceLabel: UILabel!
    @IBOutlet weak var totalVisitorsLabel: UILabel!

    private let totalPriceLabelPrefix: String = "売上：¥"
    private let totalPeopleLabelPrefix: String = "招待人数："
    private let totalRewardLabelPrefix: String = "報酬額：¥"
    private let totalVisitorsLabelPrefix: String = "来店人数："
    
    func apply(invitations: [Invitation]) {
        var predictedPrice: Int = 0
        var predictedPeople: Int = 0
        var actualPrice: Int = 0
        var actualPeople: Int = 0
        invitations.forEach {
            switch $0.status {
            case .invited, .waiting, .reviewing:
                predictedPrice += $0.totalPrice ?? 0
                predictedPeople += $0.people
            case .approved, .paid:
                predictedPrice += $0.totalPrice ?? 0
                predictedPeople += $0.people
                actualPrice += $0.rewardPrice ?? 0
                actualPeople += $0.people
            }
        }
        totalPricePriceLabel.text = totalPriceLabelPrefix + String(predictedPrice)
        totalPeopleLabel.text = totalPeopleLabelPrefix + String(predictedPeople)
        totalRewardPriceLabel.text = totalRewardLabelPrefix + String(actualPrice)
        totalVisitorsLabel.text = totalVisitorsLabelPrefix + String(actualPeople)
    }
}
