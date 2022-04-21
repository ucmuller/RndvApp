//
//  InvitationCreateTutorialVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/27.
//

import UIKit
import SwiftDate

class InvitationCreateTutorialVC: InvitationCreateVC {
    var instructionImageView2: UIImageView?
    var instructionImageView3: UIImageView?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .floatingInvitationButtonHide, object: nil)
        setupImageView2()
        setupImageView3()
        setupTextFields()
    }

    func setupImageView2() {
        let imageView = UIImageView()
        let imageWidth = view.frame.width / 2
        let imageHeight = imageWidth / 238 * 88
        scrollView.contentInset = UIEdgeInsets(top: imageHeight, left: 0, bottom: 0, right: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -imageHeight)
        imageView.image = UIImage(named: "tutorial_fukidashi_2")
        imageView.frame = CGRect(x: guestNameTextField.frame.minX + guestNameTextField.frame.width / 2, y: guestNameTextField.frame.minY - imageHeight, width: imageWidth, height: imageHeight)
        instructionImageView2 = imageView
        self.scrollView.addSubview(instructionImageView2!)
    }

    func setupImageView3() {
        let imageView = UIImageView()
        let imageWidth = view.frame.width / 1.4
        let imageHeight = imageWidth / 319 * 99
        imageView.image = UIImage(named: "tutorial_fukidashi_3")
        imageView.frame = CGRect(x: (view.frame.width - imageWidth) / 2, y: sendButton.frame.minY - imageHeight, width: imageWidth, height: imageHeight)
        instructionImageView3 = imageView
        self.scrollView.addSubview(instructionImageView3!)
    }

    func setupTextFields() {
        guestNameTextField.text = "ランデブ"
        dateTextField.text = "2019/12/27"
        timeTextField.text = "19:00"
        peopleTextField.text = "2"
        shopNameTextField.text = "店舗名"
        messageTextField.text = "当日会えるのを楽しみにしているね！"
        telTextField.text = "なまえ"
        sendButton.isEnabled = true
        sendButton.backgroundColor = RndvColor.yellowColor
    }

    @IBAction override func sendButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showInvitationListTutorialVC", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InvitationListTutorialVC {
            vc.state = .third
        }
    }

    override func loadView() {
        if let view = UINib(nibName: "InvitationCreateVC", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView{
            self.view = view
        }
    }
}
