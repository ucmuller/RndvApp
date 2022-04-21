//
//  ReceiptRegistrationPeopleVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2020/03/22.
//

import UIKit

protocol ReceiptRegistrationPeopleVCDelegate {
    func receiptRegistrationPeopleVC(didTapKeyboardReturn formView: ReceiptRegistrationPeopleVC)
}

class ReceiptRegistrationPeopleVC: ReceiptRegistrationPageVC {
    
    @IBOutlet weak var peopleTextField: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet var peopleButtonArray: [UIButton]!
    
    var receiptRegistrationPeopleVCDelegate: ReceiptRegistrationPeopleVCDelegate?
    
    var currentPeople: Int {
        guard let text = peopleTextField.text else { return 0 }
        return Int(text) ?? 0
    }
    
    var currentButtonTag: Int?
        
    override func viewDidLoad() {
        self.page = .people
        configureTextFields()
        configureButtons()
    }
    
    func configureTextFields(){
        peopleTextField.delegate = self
        peopleTextField.layer.cornerRadius = 15.0
        addReturnKey()
    }
    
    func configureButtons() {
        nextPageButton.layer.cornerRadius = 20.0
    }
    
    @IBAction func pressedPeopleSelectButton(_ sender: UIButton) {
        changeButtonState(button: sender)
        peopleTextField.text = String(sender.tag)
        currentButtonTag = sender.tag
        if sender.tag == 0 {
            peopleTextField.becomeFirstResponder()
            peopleTextField.text = ""
        } else {
            receiptRegistrationPeopleVCDelegate?.receiptRegistrationPeopleVC(didTapKeyboardReturn: self)
        }
        
    }
    
    func changeButtonState(button: UIButton) {
        button.isSelected.toggle()
        peopleButtonArray.forEach {
            if currentButtonTag == $0.tag{
                $0.isSelected.toggle()
            }
        }
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
        self.peopleTextField.inputAccessoryView = toolbar
        self.peopleTextField.keyboardType = .numberPad
    }
    
    @objc func pressedDoneKey(){
        peopleTextField.resignFirstResponder()
        receiptRegistrationPeopleVCDelegate?.receiptRegistrationPeopleVC(didTapKeyboardReturn: self)
    }
    
    @IBAction func pressedNextPageButton(_ sender: Any) {
        receiptRegistrationPeopleVCDelegate?.receiptRegistrationPeopleVC(didTapKeyboardReturn: self)    }
    
}
