//
//  InvitationDetailVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/26.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SDWebImage
import SwiftDate

class InvitationDetailVC: CustomViewController {
    @IBOutlet weak var detailView: InvitationDetailView!

    var staff: Staff?
    var invitation: Invitation? {
        didSet {
            guard let invitation = invitation else { return }
            detailView.apply(invitation: invitation)
        }
    }
    
    var date = { () -> String in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let now = Date()
        return formatter.string(from: now)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStaff()
        detailView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .floatingInvitationButtonHide, object: nil)
    }
    
    func initStaff() {
        Staff.getCurrentStaffData(handler: { staff, errorMessage in
            if let staff = staff {
                self.staff = staff
            } else {
                guard let errorMessage = errorMessage else {return}
                self.showAlert(message: errorMessage)
            }
        })
    }

    func showActionSheets(_ isPhotoSet: Bool) {
        let title: String = isPhotoSet ? "写真を変更する" : "写真を追加する"

        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        let camera = UIAlertAction(title: "撮影する", style: .default, handler: { (action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            }
        })

        let album = UIAlertAction(title: "ライブラリから選択する", style: .default, handler: { (action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        })

        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })

        alertController.addAction(camera)
        alertController.addAction(album)
        alertController.addAction(cancelAction)
        
        // iPad の場合のみ、ActionSheetを表示するための必要な設定
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2,
                                                                           y: screenSize.size.height,
                                                                           width: 0,
                                                                           height: 0)
        }

        self.present(alertController, animated: true, completion:{})
    }

    func saveImage(image: UIImage) {
        SVProgressHUD.show()
        guard let invitation = invitation else { return }
        guard let data = image.jpegData(compressionQuality: 0.2) else { return }
        let imageTitle = invitation.id + DateInRegion().toString()
        let storageReference = STORAGE.reference().child("receiptImages/" + imageTitle + ".jpg")
        storageReference.putData(data, metadata: nil) { (metadata , error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            }
            INVITATION_REF.document(invitation.id).updateData([
                "receipt_image_title" : imageTitle + ".jpg",
                "unapproved_reason" : 1
            ]) { error in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                }
                SVProgressHUD.dismiss()
            }
        }
    }

    func saveTotalPrice(totalPriceString: String?) {
        SVProgressHUD.show()
        guard let invitation = invitation else { return }
        guard let totalPriceString = totalPriceString, let totalPrice = Int(totalPriceString) else {
            showAlert(message: "合計金額を正しく入力してください。")
            return
        }
        INVITATION_REF.document(invitation.id).updateData([
            "total_price" : totalPrice
        ]) { error in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            }
            SVProgressHUD.dismiss()
        }
    }
}

extension InvitationDetailVC: InvitationDetailViewDelegate {
    func invitationDetailView(didTapRegisterButton view: InvitationDetailView, image: UIImage?) {
        guard let image = image else {
            showAlert(message: "画像を選択してください。")
            return
        }
        saveImage(image: image)
//        saveTotalPrice(totalPriceString: totalPriceString)
    }

    func invitationDetailView(didTapReceiptImageView view: InvitationDetailView, image: UIImage?) {
        showActionSheets(image != nil)
    }

    func invitationDetailView(shouldShowAlert view: InvitationDetailView) {
        showAlert(message: "レシートのアップデートは完了しています。")
    }
    
    func invitationDetailView(didPressedCheckOutButton view: InvitationDetailView) {
        guard let invitation = invitation else { return }
        if let couponPriceText = view.couponPriceTextField.text,
            let currentCouponBalance = invitation.couponBalance {
            if couponPriceText == "" {
                performSegue(withIdentifier: "showCouponLogList", sender: nil)
                self.showAlert(message: "未入力です。")
            } else {
                let couponBalance = currentCouponBalance - Int(couponPriceText)!
                if couponBalance < 0 {
                    self.showAlert(message: "クーポン残額より大きい数字が入力されています。")
                } else {
                    updateDataOfInvitation(invitation: invitation, couponBalance: couponBalance, couponPriceText: couponPriceText)
                }
            }
        }
    }
    
    
    func invitationDetailView(didPressedLogButton view: InvitationDetailView) {
        performSegue(withIdentifier: "showCouponLogList", sender: view.invitaion?.couponLogs)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CouponLogListVC {
            vc.ensureViewIsLoaded()
            vc.couponLogs = sender as? [[String: Any]]
        }
    }
    
    func updateDataOfInvitation(invitation: Invitation, couponBalance: Int, couponPriceText: String) {
        var isSetData = false
        if isSetData == false {
            guard let staff = staff else { return }
            INVITATION_REF.document(invitation.id).updateData([
                "coupon_balance" : couponBalance,
                "updated_at" : FieldValue.serverTimestamp()
            ], completion: { error in
                if error == nil {
                    self.showAlert(message: "\(couponPriceText)円分のクーポンを利用しました。", completion:  {
                            self.navigationController?.popViewController(animated: true)
                        })
                }
            })
            INVITATION_REF.document(invitation.id).collection("log").document().setData([
                "created_at" :  FieldValue.serverTimestamp(),
                "payment" : Int(couponPriceText) ?? 0,
                "staff_uid" : staff.id,
                "shop_uid" : staff.shopId,
                "date" : self.date()
            ], merge: true)
            isSetData = true
        }
    }
}

extension InvitationDetailVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            detailView.applyPhoto(image: image)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension InvitationDetailVC: UINavigationControllerDelegate {}
