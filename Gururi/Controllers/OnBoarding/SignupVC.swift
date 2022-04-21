//
//  SignUpViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/18.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class SignupVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var fullNameErrorLabel: UILabel!
    @IBOutlet weak var shopNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!

    private var isFullNameReady: Bool = false
    private var isShopNameReady: Bool = false
    private var isEmailReady: Bool = false
    private var isPasswordReady: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureButton()
    }

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        AUTH.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
                self.showAlert(message: "Failed to save!")
            } else {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.attemptToRegisterForNortifications()
                }
                let user = AUTH.currentUser
                if let user = user {
                    STAFF_REF.document(user.uid).setData([
                        "staff_uid" : user.uid,
                        "name" : self.fullNameTextField.text!,
                        "email" : self.emailTextField.text!,
                        "shopName" : self.shopNameTextField.text!,
                        "createdAt" : FieldValue.serverTimestamp()
                        ])
                }
                SVProgressHUD.dismiss()
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                    let didSeeTutorial: Bool = UserDefaults.standard.bool(forKey: "didSeeTutorial")
//                    if !didSeeTutorial {
//                        appDelegate.showTutorialStoryboard()
//                        UserDefaults.standard.set(true, forKey: "didSeeTutorial")
//                    } else {
//                        appDelegate.showNavigationStoryboard()
//                    }
                    appDelegate.showNavigationStoryboard()
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fullNameTextField.resignFirstResponder()
        shopNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }

    func configureTextFields() {
        fullNameTextField.addTarget(self, action: #selector(checkFullNameValidation), for: .editingDidEnd)
        shopNameTextField.addTarget(self, action: #selector(checkShopNameValidation), for: .editingDidEnd)
        emailTextField.addTarget(self, action: #selector(checkEmailValidation), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(checkPasswordValidation), for: .editingDidEnd)
    }

    func configureButton() {
        disableButton()
        signUpButton.layer.cornerRadius = 20.0
    }

    func enableButton(isEmailReady: Bool, isPasswordReady: Bool, isFullNameReady: Bool, isShopNameReady: Bool) {
        if isEmailReady && isPasswordReady && isFullNameReady && isShopNameReady {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(red: 251/255, green: 99/255, blue: 89/255, alpha: 1)
        }
    }

    func disableButton() {
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = UIColor(red: 233/255, green: 199/255, blue: 203/255, alpha: 1)
    }

    @objc func checkFullNameValidation() {
        isFullNameReady = fullNameTextField.hasText
        fullNameErrorLabel.text = fullNameTextField.hasText ? "" : "何か入力してください。"
        fullNameTextField.hasText ? enableButton(isEmailReady: isEmailReady, isPasswordReady: isPasswordReady, isFullNameReady: isFullNameReady, isShopNameReady: isShopNameReady) : disableButton()
    }

    @objc func checkShopNameValidation() {
        isShopNameReady = shopNameTextField.hasText
        shopNameErrorLabel.text = shopNameTextField.hasText ? "" : "何か入力してください。"
        shopNameTextField.hasText ? enableButton(isEmailReady: isEmailReady, isPasswordReady: isPasswordReady, isFullNameReady: isFullNameReady, isShopNameReady: isShopNameReady) : disableButton()
    }

    @objc func checkEmailValidation() {
        guard
            emailTextField.hasText,
            let emailString = emailTextField.text else {
                disableButton()
                return
        }
        isEmailReady = emailString.isValidEmail()
        emailErrorLabel.text = emailString.isValidEmail() ? "" : "メールアドレスの入力として正しくありません。"
        emailString.isValidEmail() ? enableButton(isEmailReady: isEmailReady, isPasswordReady: isPasswordReady, isFullNameReady: isFullNameReady, isShopNameReady: isShopNameReady) : disableButton()
    }

    @objc func checkPasswordValidation() {
        guard
            passwordTextField.hasText,
            let passwordString = passwordTextField.text else {
                disableButton()
                return
        }
        isPasswordReady = passwordString.isValidPasswordPattern()
        passwordErrorLabel.text = passwordString.isValidPasswordPattern() ? "" : "パスワードの入力として正しくありません。"
        passwordString.isValidEmail() ? enableButton(isEmailReady: isEmailReady, isPasswordReady: isPasswordReady, isFullNameReady: isFullNameReady, isShopNameReady: isShopNameReady) : disableButton()
    }
}
