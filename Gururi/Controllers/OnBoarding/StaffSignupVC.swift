//
//  StaffSignupVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/11/07.
//

import UIKit
import SVProgressHUD
import Firebase

class StaffSignupVC: CustomViewController, ReferralCodeInputFormViewDelegate, StaffSignupViewDelegate, StaffSignupSecondViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var referralCodeInputFormView: ReferralCodeInputFormView!
    @IBOutlet weak var staffSignupView: StaffSignupView!
    @IBOutlet weak var staffSignupSecondView: StaffSignupSecondView!
    
    var shop: Shop? {
        didSet {
            configureTextFieldText()
        }
    }
    
    var fromShopUid: String = "" {
        didSet {
            fetchShopData(shopId: fromShopUid)
        }
    }
    var name: String = ""
    var shopName: String = ""
    var shopTel:String = ""
    var employmentStatus: Int?
    var email: String = ""
    var tel: String = ""
    var password: String = ""
    
    var currentPage: Int = 0
    var leftBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        referralCodeInputFormView.delegate = self
        staffSignupView.delegate = self
        staffSignupSecondView.delegate = self
        scrollView.isScrollEnabled = false
        configureNavigationItem()
        staffSignupView.nameTextField.text = ""
    }
    
    
    func fetchShopData(shopId: String) {
        SVProgressHUD.show()
        Shop.getCurrentShopData(shopId: shopId) { (shop, errorMessage) in
            if let errorMessage = errorMessage {
                self.showAlert(message: errorMessage)
                SVProgressHUD.dismiss()
            }
            guard let shop = shop else {return}
            self.shop = shop
            SVProgressHUD.dismiss()
        }
    }
    
    func configureNavigationItem() {
        leftBarButton = UIBarButtonItem(title: "< 戻る", style: .plain, target: self, action: #selector(tappedLeftBarButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func configureTextFieldText() {
        if let shop = shop{
            name = shop.name
            shopTel = shop.tel
            staffSignupView.shopNameTextField.text = shop.name
            staffSignupView.shopTelTextField.text = shop.tel
        }

    }
    
    func passingDataFromReferralCodeInputFormView(didPressReferralCodeSendButton formView: ReferralCodeInputFormView) {
        if let fromShopUid = formView.fromShopUid {
            self.fromShopUid = fromShopUid
            scrollToPage(page: 1, animated: true)
        }
    }
    
        
    func passindDataFromStaffSignupView( didTapKeyboardReturn formView: StaffSignupView) {
        name = formView.name
        shopName = formView.shopName
        shopTel = formView.shopTel
        employmentStatus = formView.employmentStatus
        scrollToPage(page: 2, animated: true)
        currentPage = 2
    }
    
    func passingDataFromStaffSignupSecondView(didTapKeyboardReturn formView: StaffSignupSecondView) {
        email = formView.email
        tel = formView.tel
        password = formView.password
        signup()
    }
    
    

    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = scrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        scrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    func signup() {
        SVProgressHUD.show()
        AUTH.createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                self.showAlert(message: "このメールアドレスは使用されています。")
            } else {
                let user = AUTH.currentUser
                if let user = user {
                    if let employmentStatus = self.employmentStatus {
                        STAFF_REF.document(user.uid).setData([
                            "created_at" : FieldValue.serverTimestamp(),
                            "display_name" : self.name,
                            "full_name" : "",
                            "furi_gana" : "",
                            "email" : self.email,
                            "employment_status" : employmentStatus,
                            "fcm_token" : UserDefaults.standard.string(forKey: "fcmToken") ?? "",
                            "shop_name" : self.shopName,
                            "shop_tel" : self.shopTel,
                            "shop_uid" : self.fromShopUid,
                            "is_active" : true,
                            "tel" : self.tel,
                            "line_message" : "",
                            "uid" : user.uid,
                            "updated_at" : FieldValue.serverTimestamp()
                        ]) { error in
                            if let error = error {
                                self.showAlert(message: error.localizedDescription)
                                return
                            }
                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                appDelegate.showNavigationStoryboard()
                            }
                            REFERRAL_REF.document(user.uid).setData([
                                "created_at" : FieldValue.serverTimestamp(),
                                "from_uid" : "",
                                "display_name" : self.name
                            ])
                            SVProgressHUD.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    
    @objc func tappedLeftBarButton() {
        switch currentPage {
        case 0, 1:
            AppDelegate().showOnBoardingStoryboard()
            break
        case 2:
            scrollToPage(page: 0, animated: true)
            currentPage = 1
            break
        default:
            break
        }
    }
}
