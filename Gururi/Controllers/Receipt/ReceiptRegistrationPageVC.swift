//
//  ReceiptRegistrationPageVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2020/03/29.
//

import Foundation

enum ReceiptRegistrationPage: Int, CaseIterable {
    case name
    case date
    case people
    case message
    case confirmation
    
    var index: Int {
        return self.rawValue
    }
}

protocol ReceiptRegistrationPageDelegate: AnyObject {
    func receiptRegistrationPageWillAppear(_ receiptRegistrationPageVC: ReceiptRegistrationPageVC)
}

class ReceiptRegistrationPageVC: CustomViewController {
    weak var delegate: ReceiptRegistrationPageDelegate?

    var page: ReceiptRegistrationPage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.receiptRegistrationPageWillAppear(self)
    }
}
