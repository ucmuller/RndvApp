//
//  ViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/12.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SigninVC: CustomViewController, UINavigationControllerDelegate{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    var email: String {
        return emailTextField.text ?? ""
    }
    var password: String {
        return passwordTextField.text ?? ""
    }
    private var isEmailReady: Bool = false
    private var isPasswordReady: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        initialSetting()

        if AUTH.currentUser != nil {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showNavigationStoryboard()
            }
        }
    }

    @IBAction func pressSigninButton(_ sender: Any) {
        signin()
    }
    
    func initialSetting() {
        configureTextFields()
        configureButton()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signin()
        return true
    }
    
    
    func configureTextFields(){
        emailTextField.layer.cornerRadius = 10.0
        passwordTextField.layer.cornerRadius = 10.0
        
        emailTextField.addTarget(self, action: #selector(checkEmailValidation), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(checkPasswordValidation), for: .editingDidEnd)
    }
    
    func configureButton() {
        disableButton()
        signInButton.layer.cornerRadius = 10.0
    }
    
    func enableButton(isEmailReady: Bool, isPasswordReady: Bool) {
        if isEmailReady && isPasswordReady {
            signInButton.isEnabled = true
            signInButton.setTitleColor(RndvColor.blackColor, for: .normal)
            signInButton.backgroundColor = RndvColor.yellowColor
        }
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
        emailString.isValidEmail() ? enableButton(isEmailReady: isEmailReady, isPasswordReady: isPasswordReady) : disableButton()
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
        passwordString.isValidPasswordPattern() ? enableButton(isEmailReady: isEmailReady, isPasswordReady: isPasswordReady) : disableButton()
    }

    func disableButton() {
        signInButton.isEnabled = false
        signInButton.setTitleColor(RndvColor.blackColor, for: .normal)
        signInButton.backgroundColor = RndvColor.darkYellowColor
    }

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: nil)
    }

    @IBAction func resetPasswordButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToResetPassword", sender: nil)
    }
    
    func signin() {
        SVProgressHUD.show()
        if emailTextField.text != "" && passwordTextField.text != "" {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            AUTH.signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    self.showAlert(message: "入力した情報に誤りがあります。")
                    return
                } else {
                    guard let user = user else { return }
                    STAFF_REF.document(user.user.uid).setData([
                        "fcm_token" : UserDefaults.standard.string(forKey: "fcmToken") ?? ""
                    ], merge: true)
                    SVProgressHUD.dismiss()
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                        let didSeeTutorial: Bool = UserDefaults.standard.bool(forKey: "didSeeTutorial")
//                        if !didSeeTutorial {
//                            appDelegate.showTutorialStoryboard()
//                            UserDefaults.standard.set(true, forKey: "didSeeTutorial")
//                        } else {
//                            appDelegate.showNavigationStoryboard()
//                        }
                        appDelegate.showNavigationStoryboard()
                    }
                }
            }
        } else {
            SVProgressHUD.dismiss()
            self.showAlert(message: "入力した情報に誤りがあります。")
            return
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is StaffSignupVC {
            navigationItem.backBarButtonItem = UIBarButtonItem(
                title: "戻る",
                style: .plain,
                target: nil,
                action: #selector(backAction(_:)))
        }
    }
    
    @objc func backAction(_ sender: UIBarButtonItem)  {
        self.navigationController?.popViewController(animated: true)
    }
}
