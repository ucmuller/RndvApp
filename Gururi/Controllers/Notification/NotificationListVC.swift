//
//  NotificationVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/10/29.
//

import UIKit
import SVProgressHUD

class NotificationListVC: CustomViewController, ReusableTableViewCellManageable {
    
    var notifications: [Notifications] = []
    var staff: Staff?
    
    @IBOutlet weak var tableView: UITableView!

    private let notificationItemImageNames: [String] =  ["ceo_img"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells(to: tableView)
        tableView.isEmptyCellHidden = true
        initStaff()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotifications()
        NotificationCenter.default.post(name: .floatingInvitationButtonHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchNotifications() {
        SVProgressHUD.show()
        Notifications.getNotificationData(handler: { (notifications, error) in
            if let error = error {
                self.showAlert(message: error)
            }
            
            guard let notifications = notifications else { return }
            self.notifications = notifications
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        })
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
    
    var cellTypes: [UITableViewCell.Type] = [
        NotificationItemCell.self
    ]
    
}

extension NotificationListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(from: tableView, cellType: NotificationItemCell.self, at: indexPath)
        cell.notificationImage.image = UIImage(named: "\(notificationItemImageNames[indexPath.row])")
        cell.notificationTitle.text = notifications[indexPath.row].title
        cell.notificationCreatedAt.text = dateFormat(dateValue: notifications[indexPath.row].createdAt)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let staff = self.staff{
            let notification = notifications[indexPath.row]
            performSegue(withIdentifier: "showNotificationDetailVC", sender: (notification, staff))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueItem: (notification: Notifications, staff: Staff) = sender as? (Notifications, Staff),
            let vc = segue.destination as? NotificationDetailVC {
            vc.ensureViewIsLoaded()
            vc.notificationData = segueItem
        }
    }
}

