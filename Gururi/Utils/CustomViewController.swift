//
//  CustomViewController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/24.
//

import UIKit
import FloatingPanel

class CustomViewController: UIViewController, AutoViewLoadableFromXib, FloatingPanelManageable {
    var fpc: FloatingPanelController?
    
    var selectedTextField: UITextField?
    var selectedTextView: UITextView?
    

    override func loadView() {
        customLoadView()
    }
}

protocol AutoViewLoadableFromXib: class {
    static var xibName: String { get }
    func customLoadView()
    init(loadView _loadViewFlag: Bool)
}

extension AutoViewLoadableFromXib where Self: UIViewController {
    static var xibName: String {
        return String(describing: self)
    }

    func customLoadView() {
        if let v = UINib(nibName: type(of: self).xibName, bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView {
            view = v
        }
    }

    init(loadView _loadViewFlag: Bool = false) {
        if _loadViewFlag {
            self.init(nibName: type(of: self).xibName, bundle: Bundle.main)
            view = view
        }
        else {
            self.init()
        }
    }
}

extension CustomViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextField = textField
        return true
    }
    
    
    func configureNotification() {
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(keyboardWillBeShown(notification:)),
                                                      name: UIResponder.keyboardWillShowNotification,
                                                      object: nil)
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(keyboardWillBeHidden(notification:)),
                                                      name: UIResponder.keyboardWillHideNotification,
                                                      object: nil)
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        if let selectedTextField = selectedTextField {
            let editingTextFieldY: CGFloat = (selectedTextField.frame.origin.y)
            if editingTextFieldY > keyboardY - 60 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)

            }
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
}

