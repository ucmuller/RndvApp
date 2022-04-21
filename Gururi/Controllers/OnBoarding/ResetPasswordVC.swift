//
//  ResetPasswordVCViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/07/21.
//

import UIKit
import Firebase

class ResetPasswordVC: CustomViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.addTarget(self, action: #selector(checkEmailValidation), for: .editingDidEnd)
        configureSendButton()
    }
    

    func configureSendButton() {
        sendButton.layer.cornerRadius = 10.0
        disableButton()
    }
    
    func disableButton() {
        sendButton.isEnabled = false
        sendButton.backgroundColor = RndvColor.darkYellowColor
    }
    
    func enableButton() {
        sendButton.isEnabled = true
        sendButton.backgroundColor = RndvColor.yellowColor
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        let actionCodeSettings = ActionCodeSettings.init()
        AUTH.sendPasswordReset(withEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.showAlert(message: "\(email)にパスワードリセットメールを送信しました。", completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc func checkEmailValidation() {
        guard
        emailTextField.hasText,
            let emailString = emailTextField.text else {
                disableButton()
                return
        }
        emailErrorLabel.text = emailString.isValidEmail() ? "" : "入力として正しくありません。"
        emailString.isValidEmail() ? enableButton() : disableButton()
    }

}
