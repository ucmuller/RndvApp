//
//  StaffSignupView.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/11/07.
//

import UIKit

protocol StaffSignupViewDelegate {
    func passindDataFromStaffSignupView(didTapKeyboardReturn formView: StaffSignupView)
}

class StaffSignupView: AutoLoadableView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet var view: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var shopTelTextField: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var employmentStatusTextField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var shopNameErrorLabel: UILabel!
    @IBOutlet weak var shopTelErrorLabel: UILabel!
    @IBOutlet weak var employmentStatusErrorLabel: UILabel!
    
    
    var pickerView = UIPickerView()
    var pickerList:[String] = []
    private var selectedTextField: UITextField?

    var delegate: StaffSignupViewDelegate?

    var name: String {
        return nameTextField.text ?? ""
    }

    var shopName: String {
        return shopNameTextField.text ?? ""
    }

    var shopTel: String {
        return shopTelTextField.text ?? ""
    }

    var employmentStatus: Int?
    
    private var isNameReady: Bool = false
    private var isShopNameReady: Bool = true
    private var isShopTelReady: Bool = true
    private var isEmploymentStatusReady: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetting()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.employmentStatusTextField.delegate = self
    }
    
    func initialSetting() {
        configureTextField()
        configureButton()
        configurePickerView()
        configureNotification()
    }

    func configureTextField() {
        configureTextFieldValidation()
        nameTextField.delegate = self
        shopNameTextField.delegate = self
        shopTelTextField.delegate = self
        nameTextField.layer.cornerRadius = 10
        shopNameTextField.layer.cornerRadius = 10
        shopTelTextField.layer.cornerRadius = 10
        employmentStatusTextField.layer.cornerRadius = 10
        employmentStatusTextField.inputView = pickerView
    }
    
    func configureButton() {
        nextPageButton.layer.cornerRadius = 10
        disableButton()
    }
    
    func configurePickerView() {
        pickerList = Staff.Role.allCases.map({ $0.roleName })
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        employmentStatusTextField.inputAccessoryView = toolBar
    }
    
    func configureTextFieldValidation() {
        nameTextField.addTarget(self, action: #selector(nameStringValidation), for: .editingDidEnd)
        shopNameTextField.addTarget(self, action: #selector(shopNameStringValidation), for: .editingDidEnd)
        shopTelTextField.addTarget(self, action: #selector(shopTelStringValidation), for: .editingDidEnd)
        employmentStatusTextField.addTarget(self, action: #selector(employmentStatusValidation), for: .editingDidEnd)
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
    
    @objc func nameStringValidation() {
        isNameReady = !name.isEmpty
        nameErrorLabel.text = isNameReady ? "" : "未入力です。"
        isNameReady ? enableButton(isNameReady: isNameReady, isShopNameReady: isShopNameReady, isShopTelReady: isShopTelReady, isEmploymentStatusReady: isEmploymentStatusReady) : disableButton()
    }
    
    @objc func shopNameStringValidation() {
        isShopNameReady = !shopName.isEmpty
        shopNameErrorLabel.text = isShopNameReady ? "" : "未入力です。"
        isShopNameReady ? enableButton(isNameReady: isNameReady, isShopNameReady: isShopNameReady, isShopTelReady: isShopTelReady, isEmploymentStatusReady: isEmploymentStatusReady) : disableButton()
    }
    
    @objc func shopTelStringValidation() {
        guard
        shopTelTextField.hasText,
            let shopTelString = shopTelTextField.text else {
                disableButton()
                return
        }
        isShopTelReady = shopTelString.isTelNumber()
        shopTelErrorLabel.text = isShopTelReady ? "" : "入力として正しくありません。"
        isShopTelReady ? enableButton(isNameReady: isNameReady, isShopNameReady: isShopNameReady, isShopTelReady: isShopTelReady, isEmploymentStatusReady: isEmploymentStatusReady) : disableButton()
    }

    @objc func employmentStatusValidation() {
        isEmploymentStatusReady = employmentStatusTextField.hasText
        if !isEmploymentStatusReady {
            employmentStatusTextField.text = pickerList[0]
            employmentStatus = 0
            isEmploymentStatusReady = true
        }
        employmentStatusErrorLabel.text = isEmploymentStatusReady ? "" : "未入力です。"
        isEmploymentStatusReady ? enableButton(isNameReady: isNameReady, isShopNameReady: isShopNameReady, isShopTelReady: isShopTelReady, isEmploymentStatusReady: isEmploymentStatusReady) : disableButton()
    }
    
    func enableButton(isNameReady: Bool, isShopNameReady: Bool, isShopTelReady: Bool, isEmploymentStatusReady: Bool) {
        if isNameReady && isShopNameReady && isShopTelReady && isEmploymentStatusReady{
            nextPageButton.isEnabled = true
            nextPageButton.backgroundColor = RndvColor.yellowColor
        }
    }
    
    func disableButton() {
        nextPageButton.isEnabled = false
        nextPageButton.backgroundColor = RndvColor.darkYellowColor
    }
    
    @IBAction func nextPageButonPressed(_ sender: Any) {
        delegate?.passindDataFromStaffSignupView(didTapKeyboardReturn: self)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        employmentStatusTextField.text = self.pickerList[row]
        employmentStatus = row
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }

    @objc func cancelPressed() {
        view.endEditing(true)
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
