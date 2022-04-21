//
//  InvitationDetailView.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/10/15.
//

import UIKit
import Firebase
import SDWebImage

enum ProgressBarType: Int {
    case invited
    case waiting
    case reviewing
    case approved
    case paid

    var imageName: String {
        return "progress_\(self.rawValue + 1)"
    }

    init(status: Invitation.Status) {
        switch status {
        case .invited:
            self = .invited
        case .waiting:
            self = .waiting
        case .reviewing:
            self = .reviewing
        case .approved:
            self = .approved
        case .paid:
            self = .paid
        }
    }
}

protocol InvitationDetailViewDelegate {
    func invitationDetailView(didTapRegisterButton view: InvitationDetailView, image: UIImage?)
    func invitationDetailView(didTapReceiptImageView view: InvitationDetailView, image: UIImage?)
    func invitationDetailView(shouldShowAlert view: InvitationDetailView)
    func invitationDetailView(didPressedCheckOutButton view: InvitationDetailView)
    func invitationDetailView(didPressedLogButton view: InvitationDetailView)
}

class InvitationDetailView: AutoLoadableView, UITextFieldDelegate {
    @IBOutlet weak var progressBarImageView: UIImageView!
    @IBOutlet weak var alertTextLabel: UILabel!
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var guestTelLabel: UILabel!
    @IBOutlet weak var telIconLabel: UIImageView!
    @IBOutlet weak var receiptImageView: CustomImageView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var couponNumberLabel: UILabel!
    @IBOutlet weak var couponPriceLabel: UILabel!
    @IBOutlet weak var couponLinkButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var couponPriceTextField: UITextField!
    @IBOutlet weak var logButton: UIButton!
    
    var invitaion: Invitation?
    var delegate: InvitationDetailViewDelegate?
    
    
    override func setupViews() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.3
        layer.cornerRadius = 20
        registerButton.layer.cornerRadius = 17
        checkOutButton.layer.cornerRadius = 17
    }

//    var progressBarType: ProgressBarType? {
//        didSet {
//            guard let progressBarType = progressBarType else { return }
//            progressBarImageView.image = UIImage(named: progressBarType.imageName)
//        }
//    }

    func apply(invitation: Invitation) {
        addReturnKey()
        self.invitaion = invitation
        configureLabel(invitation: invitation)
        configureButton(invitation: invitation)
    }

    func applyPhoto(image: UIImage) {
        receiptImageView.image = image
    }
    
    func configureButton(invitation: Invitation) {
        logButton.isHidden = invitation.couponLogs.count > 0 ? false : true
    }
    
    func configureLabel(invitation: Invitation) {
        alertTextLabel.text = ""
        //        progressBarType = .init(status: invitation.status)
        guestNameLabel.text = invitation.guestName != "" ? "\(invitation.guestName) さん" : "未定"
        dateLabel.text = invitation.date != "" ? "\(invitation.date)" : "未定"
        timeLabel.text = invitation.time != "" ? "\(invitation.time)" : "未定"
        peopleLabel.text = invitation.people != 0 ?  "\(invitation.people)名様" : "未定"
        guestTelLabel.text = invitation.guestTel
                
        if let couponNumber = invitation.couponNumber,
            let couponPrice = invitation.couponPrice,
            let couponBalance = invitation.couponBalance,
            let couponUrl = invitation.couponUrl{
            couponNumberLabel.text = couponNumber != "" ? "No. \(couponNumber)" : ""
            couponPriceLabel.text = couponNumber != "" ? "残り\(couponBalance)円 / \(couponPrice)円" : "クーポン利用なし"
            if couponUrl != "" {
                couponLinkButton.setTitle("クーポンページへ", for: .normal)
                couponLinkButton.setTitleColor(#colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 1, alpha: 1), for: .normal)
            }
        }

        invitation.receiptImageTitle == "" ?
            registerButton.setTitle("レシートを登録", for: .normal) : registerButton.setTitle("レシートを修正", for: .normal)
        
        if let receiptImageTitle = invitation.receiptImageTitle {
            let storageReference = STORAGE.reference().child("receiptImages/" + receiptImageTitle)
            self.receiptImageView.sd_setImage(with: storageReference)
        }

    }
    
    
    @IBAction func pressedCouponLinkButton(_ sender: Any) {
        if let invitation = invitaion {
           if let couponUrl = invitation.couponUrl {
                guard let url = URL(string: couponUrl) else {return}
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func receiptImageViewTapped(_ sender: Any) {
//        delegate?.invitationDetailView(shouldShowAlert: self)
        delegate?.invitationDetailView(didTapReceiptImageView: self, image: receiptImageView.image)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.invitationDetailView(didTapRegisterButton: self, image: receiptImageView.image)
    }
    
    @IBAction func pressedCheckOutButton(_ sender: Any) {
        delegate?.invitationDetailView(didPressedCheckOutButton: self)
    }
    
    @IBAction func pressedLogButton(_ sender: Any) {
        delegate?.invitationDetailView(didPressedLogButton: self)
    }
    
    func addReturnKey() {
        let toolbar: UIToolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        let done = UIBarButtonItem(title: "done",
                                   style: .done,
                                   target: self,
                                   action: #selector(pressedDoneKey))
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        self.couponPriceTextField.inputAccessoryView = toolbar
        self.couponPriceTextField.keyboardType = .numberPad
    }
    
    @objc func pressedDoneKey(){
        couponPriceTextField.resignFirstResponder()
    }
}
