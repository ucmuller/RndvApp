//
//  ReceiptRegistrationConfirmationVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2020/05/25.
//

import UIKit

protocol ReceiptRegistrationConfirmationVCDelegate {
    func receiptRegistrationConfirmationVC( didPressedSendButton formView: ReceiptRegistrationConfirmationVC)
}

class ReceiptRegistrationConfirmationVC: ReceiptRegistrationPageVC {
    
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var reservationDateLabel: UILabel!
    @IBOutlet weak var reservationTimeLabel: UILabel!
    @IBOutlet weak var guestPeopleLabel: UILabel!
    @IBOutlet weak var reservationMessageLabel: UITextView!
    @IBOutlet weak var couponURLLabel: UILabel!
    @IBOutlet weak var couponPriceLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var guestName: String = ""
    var reservationDate: String = ""
    var reservationTime: String = ""
    var guestPeople: Int = 0
    var reservationMessage: String = ""
    var couponURL: String = ""
    var couponPrice: Int = 0
    
    var receiptRegistrationConfirmationVCDelegate: ReceiptRegistrationConfirmationVCDelegate?
    
    
    override func viewDidLoad() {
        page = .confirmation
        configureView()
        configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureLabel()
    }
    
    func configureView() {
        reservationMessageLabel.layer.borderColor = #colorLiteral(red: 1, green: 0.8794574142, blue: 0.1993102431, alpha: 1)
        reservationMessageLabel.layer.borderWidth = 1.0
        confirmationView.layer.cornerRadius = 15.0
    }
    
    func configureLabel() {
        guestNameLabel.text = guestName != "" ? guestName : "未記入"
        reservationDateLabel.text = reservationDate != "" ? reservationDate : "未定"
        reservationTimeLabel.text = reservationTime != "" ? reservationTime : "未定"
        reservationMessageLabel.text = reservationMessage != "" ? reservationMessage : "未記入"
        couponURLLabel.text = couponURL != "" ? couponURL : "なし"
        couponPriceLabel.text = couponPrice != 0 ? String(couponPrice) + "円" : "なし"
        guestPeopleLabel.text = guestPeople != 0 ? String(guestPeople) + "名" : "未定"
    }
    
    func configureButton() {
        sendButton.layer.cornerRadius = 15.0
    }
    
    @IBAction func pressedSendButton(_ sender: Any) {
        receiptRegistrationConfirmationVCDelegate?.receiptRegistrationConfirmationVC(didPressedSendButton: self)
    }
}
