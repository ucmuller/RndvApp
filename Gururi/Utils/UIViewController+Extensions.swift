//
//  UIViewController+Extensions.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/27.
//

import UIKit

extension UIViewController {
    // close keyboard by touching elsewhere
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // create alert
    func showAlert(message: String, completion: (()->Void)? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            completion?()
        }))
        self.present(alert, animated: true)
    }

    func ensureViewIsLoaded() {
        _ = view
    }
    
    func dateFormat(dateValue: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: dateValue)
    }
}
