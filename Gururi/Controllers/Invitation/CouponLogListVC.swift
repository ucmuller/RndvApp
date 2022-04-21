//
//  CouponLogVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2020/06/08.
//

import UIKit
import SVProgressHUD

class CouponLogListVC: CustomViewController, ReusableTableViewCellManageable {
    
    @IBOutlet weak var tableView: UITableView!
    
    var couponLogs: [[String: Any]]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var cellTypes: [UITableViewCell.Type] = [
        CouponLogItemCell.self
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEmptyCellHidden = true
        registerAllTableViewCells(to: tableView)
    }
}

extension CouponLogListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let couponLogs = couponLogs else { return 0}
        return couponLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(from: tableView, cellType: CouponLogItemCell.self, at: indexPath)
        guard let couponLogs = couponLogs else { return cell }
        cell.couponLog = couponLogs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
