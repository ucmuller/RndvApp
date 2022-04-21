//
//  ReceiptRegistrationNameVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2020/03/22.
//

import UIKit

protocol ReceiptRegistrationNameVCDelegate {
    func receiptRegistrationNameVC(didTapKeyboardReturn formView: ReceiptRegistrationNameVC)
}

class ReceiptRegistrationNameVC: ReceiptRegistrationPageVC {

    @IBOutlet weak var guestNameTextField: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var receiptRegistrationNameVCDelegate: ReceiptRegistrationNameVCDelegate?

    
    var guestName: String {
        return guestNameTextField.text ?? ""
    }
    
    override func viewDidLoad() {
        self.page = .name
        configureTextFields()
        configureButtons()
        configureNotification()
    }
    
    func configureTextFields(){
        guestNameTextField.delegate = self
//        guestNameTextField.becomeFirstResponder()
        guestNameTextField.layer.cornerRadius = 15.0
    }
    
    func configureButtons() {
        nextPageButton.layer.cornerRadius = 20.0
    }
    
    @IBAction func pressedNextPageButton(_ sender: Any) {
        receiptRegistrationNameVCDelegate?.receiptRegistrationNameVC(didTapKeyboardReturn: self)
    }
}

extension ReceiptRegistrationNameVC {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        receiptRegistrationNameVCDelegate?.receiptRegistrationNameVC(didTapKeyboardReturn: self)
        return true
    }
}
