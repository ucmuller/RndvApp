//
//  InvitationListVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/25.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import SVProgressHUD
import FloatingPanel

class InvitationListVC: CustomViewController, ReusableTableViewCellManageable{
    @IBOutlet weak var tableView: UITableView!

    var invitations: [Invitation] = []
    var receipts: [Receipt] = []
    var staff: Staff?

    let headerViewMaxHeight: CGFloat = 200
    let headerViewMinHeight: CGFloat = UIApplication.shared.statusBarFrame.height

    var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initStaff()
        registerAllTableViewCells(to: tableView)
        subscribeNotification()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchInvitations()
        showFloatingButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let fpc = fpc {
            removeFloatingPanel(fpc: fpc)
        }
    }

    func showFloatingButton() {
        if let tabBarController = tabBarController as? CustomTabBarController {
            if tabBarController.isHiddenFloatingInvitationButton == true {
                NotificationCenter.default.post(name: .floatingInvitationButtonAppear, object: nil)
            }
        }
    }

    func subscribeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(floatingInvitationButtonTapped(notification:)),
            name: .floatingInvitationButtonTapped,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFinishCreateInvitaion(notification:)),
            name: .didFinishCreateInvitaion,
            object: nil
        )
    }

    var cellTypes: [UITableViewCell.Type] = [
        SummaryHeaderCell.self,
        ReceiptItemCell.self,
        InvitationTutorialCell.self
    ]

    var headerCellTypes: [UITableViewHeaderFooterView.Type] = [
        InvitationSectionHeaderView.self
    ]
    
    @objc func didFinishCreateInvitaion(notification: Notification) {
        fetchInvitations()
//        fetchReceipts()
    }
    
    func fetchInvitations() {
        SVProgressHUD.show()
        Invitation.getInvitationData(handler: { (invitationList, errorMessage) in
            if let errorMessage = errorMessage {
                self.showAlert(message: errorMessage)
                SVProgressHUD.dismiss()
            }
            guard let invitationList = invitationList else { return }
            self.invitations = invitationList
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        })
    }
    
    func fetchReceipts() {
        SVProgressHUD.show()
        Receipt.getReceiptData(handler: { (receiptList, errorMessage) in
            if let errorMessage = errorMessage {
                self.showAlert(message: errorMessage)
                SVProgressHUD.dismiss()
            }
            guard let receiptList = receiptList else { return }
            self.receipts = receiptList
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

    @objc
    func floatingInvitationButtonTapped(notification: Notification) {
        guard let nvc = UIStoryboard(name: "InvitationCreate", bundle: nil).instantiateInitialViewController() as? UINavigationController else { return }
        guard let vc = nvc.topViewController as? ReceiptRegistrationContainerVC else { return }
        vc.ensureViewIsLoaded()
        prepareFloatingPanel(vc: nvc, scrollView: vc.ReceiptRegistrationContainerVCScrollView, delegate: self)
    }
}

extension InvitationListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitations.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = dequeueReusableHeaderFooterView(from: tableView, viewType: InvitationSectionHeaderView.self)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(from: tableView, cellType: ReceiptItemCell.self, at: indexPath)
        cell.invitations = invitations[safe: indexPath.row]
        return cell
//        if indexPath.section == 0 {
//            let cell = dequeueReusableCell(from: tableView, cellType: SummaryHeaderCell.self, at: indexPath)
//            headerView = cell.contentView
//            cell.apply(invitations: invitations)
//            return cell
//        } else {
//            let cell = dequeueReusableCell(from: tableView, cellType: ReceiptItemCell.self, at: indexPath)
//            cell.invitations = invitations[safe: indexPath.row]
//            return cell
//        }
    }
}

extension InvitationListVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "showInvitaionDetail", sender: invitations[indexPath.row])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InvitationDetailVC {
            vc.ensureViewIsLoaded()
            vc.staff = self.staff
            vc.invitation = sender as? Invitation
        }
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let y: CGFloat = scrollView.contentOffset.y
//        if y >= 0, y <= headerViewMaxHeight {
//            UIView.animate(withDuration: 0.3) {
//                self.headerView.alpha = 1.0 - abs(scrollView.contentOffset.y/self.headerViewMaxHeight)
//            }
//        }
//    }
//
//    private func setPosition(scrollView: UIScrollView) {
//        UIView.animate(withDuration: 0.3) {
//            if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < self.headerViewMaxHeight / 2 {
//                scrollView.contentOffset = .zero
//            } else if scrollView.contentOffset.y >= self.headerViewMaxHeight / 2 && scrollView.contentOffset.y <= self.headerViewMaxHeight {
//                scrollView.contentOffset.y = self.headerViewMaxHeight
//            }
//        }
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        setPosition(scrollView: scrollView)
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            setPosition(scrollView: scrollView)
//        }
//    }
}

extension InvitationListVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return ModalPanelLayout()
    }
}
