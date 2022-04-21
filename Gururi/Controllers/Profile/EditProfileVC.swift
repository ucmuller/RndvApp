//
//  EditProfileViewController.swift
//  Gururi
//
//  Created by Yu on 2019/10/18.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditProfileVC: CustomViewController, ReusableTableViewCellManageable {
    @IBOutlet weak var tableView: UITableView!
        
    private var editedProfileItems: [String:String] = [:]
    
    private var staff: Staff? {
        didSet{
            initEditableStaffData()
        }
    }
    
    private var editableStaffData: (titles: [String], bodies: [String]) = ([], []) {
        didSet {
            tableView.reloadData()
        }
    }
    
    var cellTypes: [UITableViewCell.Type] = [
        EditProfileCell.self,
        EditProfileHeaderCell.self
    ]
    
    var headerCellTypes: [UITableViewHeaderFooterView.Type] = [
        ProfileItemHeaderView.self
    ]
    
    var headerView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initStaff()
        registerAllTableViewCells(to: tableView)
        tableView.isEmptyCellHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initStaff() {
        Staff.getCurrentStaffData { (staff, errorMessage) in
            if let staff = staff {
                self.staff = staff
            } else {
                guard let errorMessage = errorMessage else {return}
                self.showAlert(message: errorMessage)
            }
        }
    }
    
    func initEditableStaffData() {
        if let staff = self.staff {
            self.editableStaffData.titles = staff.editableItems.map { $0.title }
            self.editableStaffData.bodies = staff.editableItems.map { $0.body }
            staff.editableItems.forEach {
                self.editedProfileItems.updateValue($0.body, forKey: $0.title)
            }
        }
    }
    
    @IBAction func saveEditedProfileData(_ sender: Any) {
        if let staff = staff {
            STAFF_REF.document(staff.id).setData(
                [
                "display_name" : editedProfileItems["ユーザー名"] as Any,
                "shop_tel" : editedProfileItems["店鋪電話番号"] as Any,
                "tel" : editedProfileItems["電話番号"] as Any
                ], merge: true)
        } else {
            showAlert(message: "プロフィール情報がありません。")
        }
        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
    }
    
}

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource, EditProfileCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editableStaffData.titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = dequeueReusableHeaderFooterView(from: tableView, viewType: ProfileItemHeaderView.self)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(from: tableView, cellType: EditProfileCell.self, at: indexPath)
        cell.delegate = self
        cell.kind = self.editableStaffData.titles[indexPath.row]
        cell.editProfileTitleLabel?.text = self.editableStaffData.titles[indexPath.row]
        cell.editProfileTextfield?.text = self.editableStaffData.bodies[indexPath.row]
        return cell
//        if indexPath.section == 0 {
//            let cell = dequeueReusableCell(from: tableView, cellType: EditProfileHeaderCell.self, at: indexPath)
//            return cell
//        } else {
//            let cell = dequeueReusableCell(from: tableView, cellType: EditProfileCell.self, at: indexPath)
//            cell.delegate = self
//            cell.kind = self.editableStaffData.titles[indexPath.row]
//            cell.editProfileTitleLabel?.text = self.editableStaffData.titles[indexPath.row]
//            cell.editProfileTextfield?.text = self.editableStaffData.bodies[indexPath.row]
//            return cell
//        }
    }
    
    func textFieldEditingChanged(cell: EditProfileCell, value: String) {
        if let key = cell.kind {
            editedProfileItems.updateValue(value, forKey: key)
        }
        print(editedProfileItems)
    }
    
}

