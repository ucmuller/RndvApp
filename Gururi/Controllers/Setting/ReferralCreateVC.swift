//
//  ReferralCreateVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/12/26.
//

import UIKit
import SVProgressHUD

class ReferralCreateVC: CustomViewController {

    
    @IBOutlet weak var sendReferralButton: UIButton!
    @IBOutlet weak var referralCodeCopyButton: UIButton!
    @IBOutlet weak var referralCodeLabel: UILabel!
    var shopId: String? {
        didSet {
            if let shopId = shopId {
                self.generateReferralCode(shopId: shopId, length: 6)
            }
        }
    }
    var referralCode : String?
    
    var referralMessage : String = "▼ダウンロードはコチラから▼\nhttps://apps.apple.com/jp/app/id1485140161\n\n※ランデブはNTT DOCOMOからスポンサードされています。"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        configureButton()
        configureLabel()
    }
    
    func configureButton() {
        sendReferralButton.layer.cornerRadius = 10.0
        referralCodeCopyButton.layer.cornerRadius = 10.0
    }
    
    func configureLabel() {
        referralCodeLabel.text = referralCode
    }
    
    func generateReferralCode(shopId: String, length: Int) {
        referralCode = String(shopId.prefix(length))
    }
    
    @IBAction func referralCodeCopyButtonTapped(_ sender: Any) {
        UIPasteboard.general.string = referralCode
        showAlert(message: "招待コードをコピーしました")
    }
    
    @IBAction func sendReferralButtonPressed(_ sender: Any) {
        guard let referralCode = referralCode else {return}
            let activityItem = ["【招待コード】\n\(referralCode)\n\n\(referralMessage)"]
            let activityVC = UIActivityViewController(activityItems:  activityItem, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            
            activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
                if completed {
                    self.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: .didFinishCreateInvitaion, object: nil)
                        return
                    })
                } else {
                    self.showAlert(message: "キャンセル")
                }
                if let shareError = error {
                    self.showAlert(message: "\(shareError.localizedDescription)")
                }
            }
    }
}
