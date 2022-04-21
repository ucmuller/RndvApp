//
//  UIVIew+Extensions.swift
//  Gururi
//
//  Created by Naoki Muroya on 2020/03/30.
//

import UIKit

extension UIView {
    func anchorEdges(to view: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom),
        ])
    }

    func anchorEdges(to view: UIView, top: CGFloat = 0, safeAreaTop: Bool = false, left: CGFloat = 0, safeAreaLeft: Bool = false, bottom: CGFloat = 0, safeAreaBottom: Bool = false, right: CGFloat = 0, safeAreaRight: Bool = false) {
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                (safeAreaLeft ? self.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: left) : self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left)),
                (safeAreaRight ? self.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: right) : self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right)),
                (safeAreaTop ? self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: top) : self.topAnchor.constraint(equalTo: view.topAnchor, constant: top)),
                (safeAreaBottom ? self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottom) : self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)),
            ])
        }
        else {
            anchorEdges(to: view, top: top, left: left, bottom: bottom, right: right)
        }
    }

    func anchorEdges(to view: UIView, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
        var constraints = [NSLayoutConstraint]()

        if let left = left {
            constraints.append(leftAnchor.constraint(equalTo: view.leftAnchor, constant: left))
        }
        if let right = right {
            constraints.append(rightAnchor.constraint(equalTo: view.rightAnchor, constant: right))
        }
        if let top = top {
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: top))
        }
        if let bottom = bottom {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom))
        }
        if let width = width {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        NSLayoutConstraint.activate(constraints)
    }
}
