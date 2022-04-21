//
//  CouponLogItemCell.swift
//  Gururi
//
//  Created by Yu Shimura on 2020/06/08.
//

import UIKit

class CouponLogItemCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var couponLog: [String: Any]? {
        didSet {
            if let couponLog = couponLog {
                apply(couponLog: couponLog)
            }
        }
    }
    
    func apply(couponLog: [String: Any]){
        if let date = couponLog["date"],
            let price = couponLog["payment"] {
            if let deposit = couponLog["deposit"] {
                dateLabel.text = "\(date)"
                priceLabel.text = "+\(price)円"
                priceLabel.textColor = RndvColor.primaryColor
            } else {
                dateLabel.text = "\(date)"
                priceLabel.text = "-\(price)円"
                priceLabel.textColor = RndvColor.dangerColor
            }
        }
    }
}
