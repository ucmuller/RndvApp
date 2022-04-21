//
//  StaffSignupSecondView.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/11/16.
//

import UIKit

protocol StaffSignupSecondViewDelegate {
    func passingDataFromStaffSignupSecondView(didTapKeyboardReturn formView: StaffSignupSecondView)
}

class StaffSignupSecondView: AutoLoadableView, UITextFieldDelegate{


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var telErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    var isEmailReady: Bool = false
    var isTelReady: Bool = false
    var isPasswordReady: Bool = false
    
    private var selectedTextField: UITextField?
    
    var delegate: StaffSignupSecondViewDelegate?
    var email: String {
        return emailTextField.text ?? ""
    }
    var tel: String {
        return telTextField.text ?? ""
    }
    var password: String {
        return passwordTextField.text ?? ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetting()
    }
    
    func initialSetting() {
        configureTextField()
        configureButton()
        configureNotification()
    }
    
    func configureTextField() {
        configureTextFieldValidation()
        emailTextField.delegate = self
        telTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.layer.cornerRadius = 10
        telTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
    }
    
    func configureButton() {
        signupButton.layer.cornerRadius = 10
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        delegate?.passingDataFromStaffSignupSecondView(didTapKeyboardReturn: self)
    }
    
    func configureTextFieldValidation() {
        emailTextField.addTarget(self, action: #selector(checkEmailValidation), for: .editingDidEnd)
        telTextField.addTarget(self, action: #selector(telStringValidation), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(checkPasswordValidation), for: .editingDidEnd)
    }
    
    @objc func checkEmailValidation() {
        guard
        emailTextField.hasText,
            let emailString = emailTextField.text else {
                disableButton()
                return
        }
        isEmailReady = emailString.isValidEmail()
        emailErrorLabel.text = emailString.isValidEmail() ? "" : "入力として正しくありません。"
        emailString.isValidEmail() ? enableButton(isEmailReady: isEmailReady, isTelReady: isTelReady, isPasswordReady: isPasswordReady) : disableButton()
    }
    
    @objc func checkPasswordValidation() {
        guard
            passwordTextField.hasText,
            let passwordString = passwordTextField.text else {
                disableButton()
                return
        }
        isPasswordReady = passwordString.isValidPasswordPattern()
        passwordErrorLabel.text = passwordString.isValidPasswordPattern() ? "" : "入力として正しくありません。"
        passwordString.isValidPasswordPattern() ? enableButton(isEmailReady: isEmailReady, isTelReady: isTelReady, isPasswordReady: isPasswordReady) : disableButton()
    }
    
    @objc func telStringValidation() {
        guard
        telTextField.hasText,
            let telString = telTextField.text else {
                disableButton()
                return
        }
        isTelReady = telString.isTelNumber()
        telErrorLabel.text = isTelReady ? "" : "入力として正しくありません。"
        isTelReady ? enableButton(isEmailReady: isEmailReady, isTelReady: isTelReady, isPasswordReady: isPasswordReady) : disableButton()
    }
    
    func enableButton(isEmailReady: Bool, isTelReady: Bool, isPasswordReady: Bool) {
        if isEmailReady && isTelReady && isPasswordReady {
            signupButton.isEnabled = true
            signupButton.backgroundColor = RndvColor.yellowColor
        }
    }
    
    func disableButton() {
        signupButton.isEnabled = false
        signupButton.backgroundColor = RndvColor.darkYellowColor
    }
    
    func configureNotification() {
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(keyboardWillBeShown(notification:)),
                                                      name: UIResponder.keyboardWillShowNotification,
                                                      object: nil)
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(keyboardWillBeHidden(notification:)),
                                                      name: UIResponder.keyboardWillHideNotification,
                                                      object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }

    @objc func keyboardWillBeShown(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
                let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                restoreScrollViewSize()

                let convertedKeyboardFrame = scrollView.convert(keyboardFrame, from: nil)
                if let selectedTextField = self.selectedTextField {
                    let offsetY: CGFloat = selectedTextField.frame.maxY - convertedKeyboardFrame.minY
                    if offsetY < 0 { return }
                    updateScrollViewSize(moveSize: offsetY * 2, duration: animationDuration)
                }

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
