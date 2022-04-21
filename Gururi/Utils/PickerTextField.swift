//
//  PickerTextField.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/19.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit

protocol PickerTextFieldDelegate {
    func pickerTextField(didTapDoneButton pickerTextField: PickerTextField)
}

class PickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {

    var dataList = [String]()
    
    var pickerTextFieldDelegate: PickerTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(dataList: [String]){
        self.dataList = dataList
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneForPickerView))
        toolbar.setItems([spaceItem, doneItem], animated: false)
        
        self.inputView = picker
        self.inputAccessoryView = toolbar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = dataList[row]
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        guard let text = self.text else { return true }
        if text.isEmpty {
            self.text = dataList.first
        }
        return true
    }
    
    @objc func doneForPickerView() {
        pickerTextFieldDelegate?.pickerTextField(didTapDoneButton: self)
        self.endEditing(true)
        self.resignFirstResponder()
    }
}
