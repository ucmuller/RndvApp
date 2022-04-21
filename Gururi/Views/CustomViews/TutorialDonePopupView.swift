//
//  TutorialDonePopupView.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/27.
//

import UIKit

protocol TutorialDonePopupViewDelegate {
    func tutorialDonePopupView(didButtonTapped view: TutorialDonePopupView)
}

class TutorialDonePopupView: AutoLoadableView {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var rewardLabel: UILabel!

    override func setupViews() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.3
        layer.cornerRadius = 10
        layer.masksToBounds = false
        doneButton.layer.cornerRadius = 10
    }

    var delegate: TutorialDonePopupViewDelegate?

    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.tutorialDonePopupView(didButtonTapped: self)
    }
}
