//
//  ReferralCodeInputFormView.swift
//  Gururi
//
//  Created by Yu Shimura on 2020/01/15.
//

import UIKit
import Firebase

protocol ReferralCodeInputFormViewDelegate {
    func passingDataFromReferralCodeInputFormView(didPressReferralCodeSendButton formView: ReferralCodeInputFormView)
}

class ReferralCodeInputFormView: AutoLoadableView, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var referralCodeTextField: UITextField!
    @IBOutlet weak var refferralCodeSendButton: UIButton!
    @IBOutlet weak var referralCodeErrorLabel: UILabel!
    @IBOutlet weak var cautionaryPointsTextView: UITextView!
    
    private var selectedTextField: UITextField?
    var fromShopUid: String?
    var delegate: ReferralCodeInputFormViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSettting()
        cautionaryPointsTextView.delegate = self
    }
    
    func initialSettting() {
        configureNotification()
        configureButton()
        configureTextField()
        configureCautionaryPointsTextView()
    }
    
    func configureButton() {
        refferralCodeSendButton.layer.cornerRadius = 10
        disableButton()
    }
    
    func configureTextField() {
        referralCodeTextField.layer.cornerRadius = 10
        referralCodeTextField.delegate = self
        configureTextFieldValidation()
        referralCodeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func configureTextFieldValidation() {
        referralCodeTextField.addTarget(self, action: #selector(referralCodeStringValidation), for: .editingDidEnd)
    }
    
    @objc func textFieldDidChange(textFiled: UITextField) {
        if textFiled.text?.count == 6 {
            enableButton()
        } else {
            disableButton()
        }
    }
    
    func configureCautionaryPointsTextView() {
        let cautionaryPointsMessage = "RNDV（ランデブ）は招待制です。RNDVを利用しているスタッフから招待コードを受け取りましょう。\n\n「次へ」をクリックすることで 利用規約 及び プライバシーポリシー に同意したものとみなします。\n\n※招待コードを希望する方コチラから申請することが出来ます。（審査制）"
        
        let attributedString = NSMutableAttributedString(string: cautionaryPointsMessage)

        attributedString.addAttributes([
            .font : UIFont.systemFont(ofSize: 15.0)
        ], range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(.link, value: "https://rndv.jp/tos", range: NSString(string: cautionaryPointsMessage).range(of: "利用規約"))

        attributedString.addAttribute(.link, value: "https://rndv.jp/privacypolicy", range: NSString(string: cautionaryPointsMessage).range(of: "プライバシーポリシー"))
        
        attributedString.addAttribute(.link, value: "https://docs.google.com/forms/d/e/1FAIpQLSfRK8dBD0_Id1Eoj52hvM08jN8ntZ1hkOQWwOCMoDALm50czg/viewform?usp=sf_link", range: NSString(string: cautionaryPointsMessage).range(of: "コチラ"))

        cautionaryPointsTextView.attributedText = attributedString
        cautionaryPointsTextView.isEditable = false
    }
    
    @objc func referralCodeStringValidation() {
        guard referralCodeTextField.hasText,
            let referralCodeString = referralCodeTextField.text else {return}

        referralCodeErrorLabel.text = referralCodeString.isValidPasswordPattern() ? "" : "6桁の半角英数字で入力してください。"
        referralCodeString.isValidPasswordPattern() ? enableButton() : disableButton()
    }
    
    func enableButton() {
        refferralCodeSendButton.isEnabled = true
        refferralCodeSendButton.backgroundColor = RndvColor.yellowColor
    }
    
    func disableButton() {
        refferralCodeSendButton.isEnabled = false
        refferralCodeSendButton.backgroundColor = RndvColor.darkYellowColor
    }

    @IBAction func referralCodeSendButtonPressed(_ sender: Any) {
        if let referralCode = referralCodeTextField.text {
            getDocuments { querySnapshot -> Void in
                let result = self.checkCollectReferralCode(referralCode: referralCode, querySnapshot: querySnapshot)
                if result.isCollect {
                    self.fromShopUid = result.shopUid
                    self.delegate?.passingDataFromReferralCodeInputFormView(didPressReferralCodeSendButton: self)
                } else {
                    self.updateReferralCodeErrorLabel()
                }
            }
        }
    }

    func updateReferralCodeErrorLabel() {
        referralCodeErrorLabel.text = "招待コードが正しくありません。"
    }

    func getDocuments(completion: @escaping ((QuerySnapshot)->Void)) {
        SHOPS_REF.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            if let querySnapshot = querySnapshot {
                completion(querySnapshot)
            }
        }
    }

    func checkCollectReferralCode(referralCode: String, querySnapshot: QuerySnapshot) -> (isCollect: Bool, shopUid: String?) {
        for document in querySnapshot.documents {
            let shopUid = String(document.documentID)
            if (shopUid.hasPrefix(referralCode)) {
                return (true, shopUid)
            }
        }
        return (false, nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
    
    func configureNotification() {
//        NotificationCenter.default.addObserver(self,
//                                                      selector: #selector(keyboardWillBeShown(notification:)),
//                                                      name: UIResponder.keyboardWillShowNotification,
//                                                      object: nil)
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(keyboardWillBeHidden(notification:)),
                                                      name: UIResponder.keyboardWillHideNotification,
                                                      object: nil)
    }

    @objc func keyboardWillBeShown(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
                let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                restoreScrollViewSize()

                let convertedKeyboardFrame = scrollView.convert(keyboardFrame, from: nil)
                let offsetY: CGFloat = self.selectedTextField!.frame.maxY - convertedKeyboardFrame.minY
                if offsetY < 0 { return }
                updateScrollViewSize(moveSize: offsetY * 2, duration: animationDuration)
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {
        restoreScrollViewSize()
    }

    func updateScrollViewSize(moveSize: CGFloat, duration: TimeInterval) {
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(duration)
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: moveSize, right: 0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.scrollView.contentOffset = CGPoint(x: 0, y: moveSize)
        UIView.commitAnimations()
    }

    func restoreScrollViewSize() {
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
}
