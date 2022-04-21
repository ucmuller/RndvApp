//
//  InvitationEditVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/26.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit

class InvitationEditVC: UIViewController {

    // MARK: properties
    @IBOutlet weak var dateTextField: PickerTextField!
    @IBOutlet weak var timeTextField: PickerTextField!
    @IBOutlet weak var guestNameTextField: UITextField!
    @IBOutlet weak var peopleTextField: PickerTextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    // prepare invitation property
    var invitation: Invitation?
    
    // prepare lists for picker view
    var timeList : [String] = ["18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00", "22:30", "23:00"]
    var peopleList : [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var dateList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // validation check
        addTargets()
        
        // button layout
        doneButton.isEnabled = false
        doneButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        doneButton.layer.cornerRadius = 15.0
        cancelButton.layer.cornerRadius = 15.0
        
        // configure text field and picker view
        configureTextFields()
        configurePickerViews()
    }
    
    // MARK: button actions
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        updateData()
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
    }
    
    // MARK: functions
    func updateData() {
        
        guard
            let date = dateTextField.text,
            let time = timeTextField.text,
            let guestName = guestNameTextField.text,
            let people = peopleTextField.text,
            let tel = telTextField.text,
            let invitationId = invitation?.id else {return}
        
        DB.collection("invite").document(invitationId).updateData([
            "date": date,
            "time": time,
            "guestName": guestName,
            "people": people,
            "tel": tel,
        ])
        
    }
    // configure textFields
    func configureTextFields() {
        guard let invitation = self.invitation else {return}
        guestNameTextField.text = invitation.guestName
        peopleTextField.text = String(invitation.people)
        dateTextField.text = invitation.date
        timeTextField.text = invitation.time
        telTextField.text = invitation.guestTel
    }

    // configure PickerViews
    func configurePickerViews() {
        // prepare date picker
        prepareDateList()
        dateTextField.setup(dataList: dateList)
        // prepare time picker views
        timeTextField.setup(dataList: timeList)
        // prepare people picker view
        peopleTextField.setup(dataList: peopleList)
    }
    
    // prepare for date picker view
    func prepareDateList() {
        
        let today = Date()
        let tomorrow = today + 60*60*24
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        let todayString = "\(formatter.string(from: today))"
        let tomorrowString = "\(formatter.string(from: tomorrow))"
        
        dateList = [todayString, tomorrowString]
    }
    
    // add targets for validation check
    func addTargets() {
        dateTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        timeTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        guestNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        peopleTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        telTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
    }
    
    // validation check
    @objc func formValidation() {
        
        guard
            dateTextField.hasText,
            timeTextField.hasText,
            guestNameTextField.hasText,
            peopleTextField.hasText,
            telTextField.hasText else {
                // handle case for above conditions not met
                doneButton.isEnabled = false
                doneButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
        }
        
        // handle case for conditions were met
        doneButton.isEnabled = true
        doneButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
    }
}
