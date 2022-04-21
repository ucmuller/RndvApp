//
//  ProfileViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/18.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class ProfileVC: CustomViewController, ProfileHeaderCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var staff: Staff? {
        didSet {
            initStaffData()
        }
    }
    
    private var staffData: (titles: [String], bodies: [String]) = ([], []) {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initStaff()
        NotificationCenter.default.post(name: .floatingInvitationButtonHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCell()
        tableView.isEmptyCellHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func registerCustomCell(){
        tableView.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellReuseIdentifier: "ProfileHeaderCell")
        tableView.register(UINib(nibName: "ProfileItemCell", bundle: nil), forCellReuseIdentifier: "ProfileItemCell")
        tableView.register(UINib(nibName: "ProfileItemHeaderCell", bundle: nil), forCellReuseIdentifier: "ProfileItemHeaderCell")
    }
    
    @IBAction func editProfilePressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEditProfile", sender: nil)
    }
    
    func profileHeaderCell(didTapSettingButton view: ProfileHeaderCell) {
        performSegue(withIdentifier: "goToSetting", sender: nil)
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
    
    func initStaffData() {
        if let staff = self.staff {
            self.staffData.titles = staff.items.map { $0.title }
            self.staffData.bodies = staff.items.map { $0.body }
        }
    }
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "ProfileItemHeaderCell")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : staffData.titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return indexPath.section == 0 ? 200 : 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            cell.delegate = self
            cell.staffNameLabel?.text = staff?.displayName
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemCell", for: indexPath) as! ProfileItemCell
            if !staffData.bodies.isEmpty && !staffData.titles.isEmpty {
                cell.profileItemNameLabel?.text = self.staffData.titles[indexPath.row]
                cell.profileItemDataLabel?.text = self.staffData.bodies[indexPath.row]
            }
            return cell
        }
    }
}

