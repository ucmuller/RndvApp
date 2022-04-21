//
//  UIScrollView+Extensions.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/27.
//

import UIKit

extension UIScrollView {
    // close keyboard by touching elsewhere
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.endEditing(true)
    }
}
