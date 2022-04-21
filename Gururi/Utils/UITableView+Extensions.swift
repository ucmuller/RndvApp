//
//  UITableView+Extensions.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/27.
//

import UIKit

extension UITableView {
    var isEmptyCellHidden: Bool? {
        get {
            // You cannot use this.
            return nil
        }
        set(b) {
            guard let b = b else {return}
            if b {
                self.tableFooterView = UIView()
            }
        }
    }
}
