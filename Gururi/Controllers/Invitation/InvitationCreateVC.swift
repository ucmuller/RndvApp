//
//  InvitationCreateVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/19.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import FirebaseUI

extension Notification.Name {
    static let didFinishCreateInvitaion = Notification.Name("didFinishCreateInvitaion")
}

class InvitationCreateVC: CustomViewController {
    @IBOutlet var wrapperView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var dateTextField: PickerTextField!
    @IBOutlet weak var timeTextField: PickerTextField!
    @IBOutlet weak var guestNameTextField: UITextField!
    @IBOutlet weak var peopleTextField: PickerTextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var shopNameErrorLabel: UILabel!
    @IBOutlet weak var guestNameErrorLabel: UILabel!
    @IBOutlet weak var telErrorLabel: UILabel!
    @IBOutlet weak var dateErrorLabel: UILabel!
    @IBOutlet weak var timeErrorLabel: UILabel!
    @IBOutlet weak var peopleErrorLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    

    private var isShopNameReady: Bool = false
    private var isGuestNameReady: Bool = false
    private var isTelReady: Bool = false
    private var isDateReady: Bool = false
    private var isTimeReady: Bool = false
    private var isPeopleReady: Bool = false

    private var staff: Staff? {
        didSet {
            configureButtonView()
            congigureMessageTextField()
        }
    }

    private let datePicker = UIPickerView()
    private let timePicker = UIPickerView()

    private var timeList : [String] = ["17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00", "22:30", "23:00", "24:00", "24:30", "25:00", "25:30", "26:00", "26:30", "27:00", "27:30", "28:00"]
    private var peopleList : [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    private var dateList : [String] = []
    
    private var dateSelectionVC: DateSelectionVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkValidation()
        configurePickerViews()
        initStaff()
        dateSelectionVC = UIStoryboard(name: "InvitationCreate", bundle: nil).instantiateViewController(withIdentifier: "DateSelectionVC") as? DateSelectionVC
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeShown(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
    
    func congigureMessageTextField() {
        messageTextField.text = staff?.lineMessage
        shopNameTextField.text = staff?.shopName
        telTextField.text = staff?.tel
        checkTelValidation()
        checkShopNameValidation()
    }

    func configureButtonView() {
        disableButton()
        sendButton.layer.cornerRadius = 10.0
        confirmButton.layer.cornerRadius = 10.0
    }
    
    func updateDateTextField() {
        if let date = dateSelectionVC?.date {
            dateTextField.text = date
            checkDateValidation()
        }
    }
    

    func enableButton(isShopNameReady: Bool, isGuestNameReady: Bool, isTelReady: Bool, isDateReady: Bool, isTimeReady: Bool, isPeopleReady: Bool) {
        if isShopNameReady && isGuestNameReady && isTelReady && isDateReady && isTimeReady && isPeopleReady {
            sendButton.isEnabled = true
            sendButton.backgroundColor = RndvColor.yellowColor
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = RndvColor.yellowColor
        }
    }

    func disableButton() {
        sendButton.isEnabled = false
        confirmButton.isEnabled = false
        sendButton.backgroundColor = UIColor(red: 100/255, green: 83/255, blue: 16/255, alpha: 1)
        confirmButton.backgroundColor = UIColor(red: 100/255, green: 83/255, blue: 16/255, alpha: 1)
    }

    @objc func checkShopNameValidation() {
        isShopNameReady = shopNameTextField.hasText
        shopNameErrorLabel.text = shopNameTextField.hasText ? "" : "未入力です。"
        shopNameTextField.hasText ? enableButton(isShopNameReady: isShopNameReady, isGuestNameReady: isGuestNameReady, isTelReady: isTelReady, isDateReady: isDateReady, isTimeReady: isTimeReady, isPeopleReady: isPeopleReady) : disableButton()
    }

    
    @objc func checkGuestNameValidation() {
        isGuestNameReady = guestNameTextField.hasText
        guestNameErrorLabel.text = guestNameTextField.hasText ? "" : "未入力です。"
        guestNameTextField.hasText ? enableButton(isShopNameReady: isShopNameReady, isGuestNameReady: isGuestNameReady, isTelReady: isTelReady, isDateReady: isDateReady, isTimeReady: isTimeReady, isPeopleReady: isPeopleReady) : disableButton()
    }
    
    
    @objc func checkDateValidation() {
        isDateReady = dateTextField.hasText
        dateErrorLabel.text = dateTextField.hasText ? "" : "未入力です。"
        dateTextField.hasText ? enableButton(isShopNameReady: isShopNameReady, isGuestNameReady: isGuestNameReady, isTelReady: isTelReady, isDateReady: isDateReady, isTimeReady: isTimeReady, isPeopleReady: isPeopleReady) : disableButton()
    }
    
    @objc func checkTimeValidation() {
        isTimeReady = timeTextField.hasText
        timeErrorLabel.text = timeTextField.hasText ? "" : "未入力です。"
        timeTextField.hasText ? enableButton(isShopNameReady: isShopNameReady, isGuestNameReady: isGuestNameReady, isTelReady: isTelReady, isDateReady: isDateReady, isTimeReady: isTimeReady, isPeopleReady: isPeopleReady) : disableButton()
    }
    
    @objc func checkPeopleValidation() {
        isPeopleReady = peopleTextField.hasText
        peopleErrorLabel.text = peopleTextField.hasText ? "" : "未入力です。"
        peopleTextField.hasText ? enableButton(isShopNameReady: isShopNameReady, isGuestNameReady: isGuestNameReady, isTelReady: isTelReady, isDateReady: isDateReady, isTimeReady: isTimeReady, isPeopleReady: isPeopleReady) : disableButton()
    }

    @objc func checkTelValidation() {
        guard
            telTextField.hasText,
            let telString = telTextField.text else {
                telErrorLabel.text = "未入力です。"
                disableButton()
                return
        }
        
        isTelReady = telString.isNumeric()
        telErrorLabel.text =  telString.isNumeric() ? "" : "電話番号の入力として正しくありません。"
        telString.isNumeric() ? enableButton(isShopNameReady: isShopNameReady, isGuestNameReady: isGuestNameReady, isTelReady: isTelReady, isDateReady: isDateReady, isTimeReady: isTimeReady, isPeopleReady: isPeopleReady) : disableButton()
    }

    func configurePickerViews() {
        prepareDateList()
//        dateTextField.setup(dataList: dateList)
        timeTextField.setup(dataList: timeList)
        peopleTextField.setup(dataList: peopleList)
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func prepareDateList() {
        let today = Date()
        let tomorrow = today + 60*60*24
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        let todayString = "\(formatter.string(from: today))"
        let tomorrowString = "\(formatter.string(from: tomorrow))"
        dateList = [todayString, tomorrowString]
    }

    func checkValidation() {
        shopNameTextField.addTarget(self, action: #selector(checkShopNameValidation), for: .editingDidEnd)
        guestNameTextField.addTarget(self, action: #selector(checkGuestNameValidation), for: .editingDidEnd)
        telTextField.addTarget(self, action: #selector(checkTelValidation), for: .editingDidEnd)
        dateTextField.addTarget(self, action: #selector(checkDateValidation), for: .editingDidEnd)
        timeTextField.addTarget(self, action: #selector(checkTimeValidation), for: .editingDidEnd)
        peopleTextField.addTarget(self, action: #selector(checkPeopleValidation), for: .editingDidEnd)
    }
        
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let staff = self.staff else {return}
        guard
            let shopName = shopNameTextField.text,
            let date = dateTextField.text,
            let time = timeTextField.text,
            let guestName = guestNameTextField.text,
            let lineMessage = messageTextField.text,
            let people = Int(peopleTextField.text!),
            let tel = telTextField.text else {return}

        let uid = staff.id
        let name = staff.displayName
        let shopAddress = staff.shopAddress
        let shopInfo = staff.shopInfo
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yMdkHms"
        let timestamp = Date()
        let documentName = uid + dateFormatter.string(from: timestamp)
    
        let activityItem = ["\(lineMessage)\n【予約代行完了|ランデブ】https://guest.rndv-vip.com/\(documentName)"]
        let activityVC = UIActivityViewController(activityItems:  activityItem, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                INVITATION_REF.document(documentName).setData([
                    "created_at" : FieldValue.serverTimestamp(),
                    "date" : date,
                    "guest_name" : guestName,
                    "guest_tel" : "",
                    "guest_uid" : "",
                    "is_approved" : false,
                    "is_reservation" : false,
                    "is_paid" : false,
                    "line_message": lineMessage,
                    "people" : people,
                    "receipt_image_title": "",
                    "staff_name": name,
                    "staff_tel" : tel,
                    "staff_uid" : uid,
                    "shop_name" : shopName,
                    "shop_address" : shopAddress ?? "",
                    "shop_info" : shopInfo ?? "",
                    "time" : time,
                    "unapproved_reason" : 0,
                    "updated_at" : FieldValue.serverTimestamp()
                ]) { error in
                    if let error = error {
                        self.showAlert(message: error.localizedDescription)
                        return
                    }
                    self.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: .didFinishCreateInvitaion, object: nil)
                        return
                    })
                }
                
                STAFF_REF.document(uid).updateData([
                    "line_message" : lineMessage
                    ], completion: { error in
                        if error == nil {
                            self.textFields.forEach({$0.text = ""})
                        }
                })

            } else {
                self.showAlert(message: "キャンセル")
            }
            if let shareError = error {
                self.showAlert(message: "\(shareError.localizedDescription)")
            }
        }
    }
    @IBAction func confirmButtonPressed(_ sender: Any) {
        guard let staff = self.staff else {return}
        guard
            let shopName = shopNameTextField.text,
            let date = dateTextField.text,
            let time = timeTextField.text,
            let guestName = guestNameTextField.text,
            let lineMessage = messageTextField.text,
            let people = Int(peopleTextField.text!),
            let tel = telTextField.text else {return}

        let uid = staff.id
        let name = staff.displayName
        let shopAddress = staff.shopAddress
        let shopInfo = staff.shopInfo
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yMdkHms"
        let timestamp = Date()
        let documentName = uid + dateFormatter.string(from: timestamp)
    INVITATION_REF.document(documentName).setData([
            "created_at" : FieldValue.serverTimestamp(),
            "date" : date,
            "guest_name" : guestName,
            "guest_tel" : tel,
            "guest_uid" : "",
            "is_approved" : false,
            "is_reservation" : true,
            "is_paid" : false,
            "line_message": lineMessage,
            "people" : people,
            "receipt_image_title": "",
            "staff_name": name,
            "staff_tel" : tel,
            "staff_uid" : uid,
            "shop_name" : shopName,
            "shop_address" : shopAddress ?? "",
            "shop_info" : shopInfo ?? "",
            "time" : time,
            "unapproved_reason" : 0,
            "updated_at" : FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: .didFinishCreateInvitaion, object: nil)
                return
            })
        }
        
        STAFF_REF.document(uid).updateData([
            "line_message" : lineMessage
            ], completion: { error in
                if error == nil {
                    self.textFields.forEach({$0.text = ""})
                }
        })
    }
    
}

extension InvitationCreateVC {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
}

extension InvitationCreateVC: DateSelectionVCDelegate {
    func dateSelection(willDisappear dateSelectionVC: DateSelectionVC) {
        updateDateTextField()
        view.endEditing(true)
    }
}
