//
//  InvitationDetailTutorialVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/27.
//

import UIKit

class InvitationDetailTutorialVC: InvitationDetailVC {
    var instructionImageView5: UIImageView?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .floatingInvitationButtonHide, object: nil)
        setup()
        setupImageView5()
    }

    override func loadView() {
        if let view = UINib(nibName: "InvitationDetailVC", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView{
            self.view = view
        }
    }

    func setupImageView5() {
        let imageView = UIImageView()
        let imageWidth = view.frame.width / 1.4
        let imageHeight = imageWidth / 283 * 112
        imageView.image = UIImage(named: "tutorial_fukidashi_5")
        imageView.frame = CGRect(x: detailView.receiptImageView.frame.minX, y: detailView.receiptImageView.frame.minY - imageHeight, width: imageWidth, height: imageHeight)
        instructionImageView5 = imageView
        self.detailView.addSubview(instructionImageView5!)
    }

    func setup() {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = detailView.frame
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didViewTapped))
        view.addGestureRecognizer(gestureRecognizer)
        self.view.addSubview(view)
    }

    @objc func didViewTapped() {
        performSegue(withIdentifier: "backToInvitationListTutorialVC", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InvitationListTutorialVC {
            vc.ensureViewIsLoaded()
            vc.state = .fifth
        }
    }
}

extension InvitationDetailTutorialVC: UIGestureRecognizerDelegate {}
