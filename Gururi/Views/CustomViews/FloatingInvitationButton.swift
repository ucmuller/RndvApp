//
//  FloatingInvitationButton.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/24.
//

import UIKit

class FloatingInvitationButton: AutoLoadableView {
    static let size: CGFloat = 60

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupConstraints()
    }

    func setupConstraints() {
        addConstraints([
            NSLayoutConstraint(
                item: self,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .width,
                multiplier: 1,
                constant: type(of: self).size
            ),
            NSLayoutConstraint(
                item: self,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .height,
                multiplier: 1,
                constant: type(of: self).size
            ),
        ])
    }
}
