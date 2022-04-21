//
//  ReceiptRegistrationMessageVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2020/05/18.
//

import UIKit

protocol ReceiptRegistrationMessageVCDelegate {
    func receiptRegistrationMessageVC(didTapKeyboardReturn formView: ReceiptRegistrationMessageVC)
}

class ReceiptRegistrationMessageVC: ReceiptRegistrationPageVC {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var couponURLTextField: UITextField!
    @IBOutlet weak var couponPriceTextField: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var staff: Staff? {
        didSet {
            messageTextView.text = staff?.lineMessage
        }
    }
    
    var message: String {
        return messageTextView.text ?? ""
    }
    
    var couponURL: String {
        return couponURLTextField.text ?? ""
    }
    
    var couponPrice: Int {
        guard let text = couponPriceTextField.text else { return 0 }
        return Int(text) ?? 0
    }
    
    var receiptRegistrationMessageVCDelegate: ReceiptRegistrationMessageVCDelegate?
    
    override func viewDidLoad() {
        self.page = .message
        configureTextView()
        configureNotification()
        configureButton()
        initStaff()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    func configureTextView() {
        messageTextView.delegate = self
        couponURLTextField.delegate = self
        couponPriceTextField.delegate = self
        messageTextView.layer.cornerRadius = 15.0
        couponURLTextField.layer.cornerRadius = 15.0
        couponPriceTextField.layer.cornerRadius = 15.0
        addReturnKey()
    }
    
    func configureButton() {
        nextPageButton.layer.cornerRadius = 20.0
    }
    
    @IBAction func pressedNextPageButton(_ sender: Any) {
        receiptRegistrationMessageVCDelegate?.receiptRegistrationMessageVC(didTapKeyboardReturn: self)
    }
    
}

extension ReceiptRegistrationMessageVC {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        self.couponPriceTextField.inputAccessoryView = toolbar
        self.couponPriceTextField.keyboardType = .numberPad
    }
    
    @objc func pressedDoneKey(){
        couponPriceTextField.resignFirstResponder()
    }
}
