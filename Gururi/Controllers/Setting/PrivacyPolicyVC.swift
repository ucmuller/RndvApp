//
//  PrivacyPolicyVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/12/26.
//

import UIKit

class PrivacyPolicyVC: CustomViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        openURL("https://rndv.jp/privacypolicy")
    }
    
    func openURL(_ link:String) {
        if link.prefix(7) == "http://" || link.prefix(8) == "https://" {

            guard let url = URL(string: link) else {return}

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } else {}
        self.navigationController?.popViewController(animated: true)
    }
}
