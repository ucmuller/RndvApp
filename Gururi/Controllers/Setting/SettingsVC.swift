//
//  SettingVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/10/09.
//
import UIKit
import Firebase

class SettingsVC: CustomViewController, ReusableTableViewCellManageable{
    @IBOutlet weak var tableView: UITableView!

    var currentCell: Int?
    private var staff: Staff? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var cellTypes: [UITableViewCell.Type] = [
        SettingsItemCell.self
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        initStaff()
        tableView.isEmptyCellHidden = true
        registerTableViewCells(to: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .floatingInvitationButtonHide, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToContactFormVC" {
            let nextVC = segue.destination as! ContactFormVC
            nextVC.cellIndex = currentCell
            nextVC.email = staff?.email
        }
        if segue.identifier == "goToReferralCreateVC"{
            let nextVC = segue.destination as! ReferralCreateVC
            nextVC.shopId = staff?.shopId
        }
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
    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try AUTH.signOut()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showOnBoardingStoryboard()
            }
        } catch {
            print(error)
        }
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(from: tableView, cellType: SettingsItemCell.self, at: indexPath)
        cell.configureCell(indexPath: indexPath.row)
        cell.settingsItemLabel.text = cell.status?.title
        cell.settingsItemImage.image = cell.status?.icon
        return cell
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = SettingsItemCell()
        cell.configureCell(indexPath: indexPath.row)
        currentCell = cell.currentCellValue
        if let cell = cell.status {
            performSegue(withIdentifier: "\(cell.segueId)", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cell = SettingsItemCell()
        return cell.cellCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
 
}
