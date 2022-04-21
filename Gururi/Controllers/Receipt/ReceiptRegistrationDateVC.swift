//
//  ReceiptRegistrationDateVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2020/03/22.
//

import UIKit

protocol ReceiptRegistrationDateVCDelegate {
    func receiptRegistrationDateVC(didTapKeyboardReturn formView: ReceiptRegistrationDateVC)
}

class ReceiptRegistrationDateVC: ReceiptRegistrationPageVC {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateTextField: PickerTextField!
    @IBOutlet weak var timeTextField: PickerTextField!
    @IBOutlet weak var nextPageButton: UIButton!
    
    var timeList = ["", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00", "22:30", "23:00", "24:00", "24:30", "25:00", "25:30", "26:00", "26:30", "27:00", "27:30", "28:00"]
    
    var receiptRegistrationDateVCDelegate: ReceiptRegistrationDateVCDelegate?
    
    var dateSelectionVC: DateSelectionVC?
    
    var date: String {
        return dateTextField.text ?? ""
    }
    
    var time: String {
        return timeTextField.text ?? ""
    }
    
    override func viewDidLoad() {
        self.page = .date
        timeTextField.pickerTextFieldDelegate = self
        configureTextFields()
        configureButtons()
        configureNotification()
        dateSelectionVC = UIStoryboard(name: "InvitationCreate", bundle: nil).instantiateViewController(withIdentifier: "DateSelectionVC") as? DateSelectionVC
    }
    
    func configureTextFields(){
        dateTextField.delegate = self
        timeTextField.delegate = self
        dateTextField.layer.cornerRadius = 15.0
        timeTextField.layer.cornerRadius = 15.0
        timeTextField.setup(dataList: timeList)
    }
    
    func configureButtons() {
        nextPageButton.layer.cornerRadius = 20.0
    }
    
    func updateDateTextField() {
        if let date = dateSelectionVC?.date {
            dateTextField.text = date
        }
    }
    
    @IBAction func pressedNextPageButton(_ sender: Any) {
        receiptRegistrationDateVCDelegate?.receiptRegistrationDateVC(didTapKeyboardReturn: self)
    }
    
}

extension ReceiptRegistrationDateVC {
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dateTextField {
            if let calendarPopupVC = dateSelectionVC {
                calendarPopupVC.delegate = self
                calendarPopupVC.modalPresentationStyle = .pageSheet
                present(calendarPopupVC, animated: true, completion: nil)
            }
        }
        return textField != dateTextField
    }
}

extension ReceiptRegistrationDateVC: DateSelectionVCDelegate, PickerTextFieldDelegate {
    func pickerTextField(didTapDoneButton pickerTextField: PickerTextField) {
        receiptRegistrationDateVCDelegate?.receiptRegistrationDateVC(didTapKeyboardReturn: self)
    }
    
    func dateSelection(willDisappear dateSelectionVC: DateSelectionVC) {
        updateDateTextField()
        timeTextField.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
}
