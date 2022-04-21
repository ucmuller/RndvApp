//
//  AfterContactVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/12/26.
//

import UIKit

class AfterContactVC: CustomViewController {

    
    @IBOutlet weak var messageLabel: UILabel!
    var currentUserEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabel()
    }
    
    func configureLabel() {
        if let email = currentUserEmail {
            messageLabel.text = "お問い合わせありがとうございました。\n３営業日以内に、担当者より\nメール（\(email)）に\nご連絡いたします。"
        }
    }


}
