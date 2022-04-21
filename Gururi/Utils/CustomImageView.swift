//
//  CustomImageView.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/22.
//

import UIKit

@IBDesignable
class CustomImageView: UIImageView, BorderCustomizable {
    var borderView: BorderView? {
        didSet {
            if let borderView = borderView {
                if let oldValue = oldValue {
                    insertSubview(borderView, belowSubview: oldValue)
                }
                else {
                    addSubview(borderView)
                }
            }

            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            generateBorderView()
        }
    }

    @IBInspectable var cornerModeName: String = CornerMode.All.rawValue {
        didSet {
            generateBorderView()
        }
    }

    var cornerMode: CornerMode {
        return CornerMode(name: cornerModeName) ?? .All
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            generateBorderView()
        }
    }

    @IBInspectable var borderColorName: String = "Gray" {
        didSet {
            generateBorderView()
        }
    }

    var borderColor: UIColor {
        return RndvColor(name: borderColorName)?.uiColor ?? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

    override var intrinsicContentSize: CGSize {
        return .zero
    }

    @IBInspectable var edgeModeName: String = "None" {
        didSet {
            generateBorderView()
        }
    }

    var edgeMode: EdgeMode {
        return EdgeMode(name: edgeModeName) ?? .None
    }

    @IBInspectable var borderPatternName: String = "Solid" {
        didSet {
            generateBorderView()
        }
    }

    var borderPattern: BorderPattern {
        return BorderPattern(name: borderPatternName) ?? .Solid
    }

    func generateBorderView() {
        borderView = BorderView(
            width: borderWidth,
            color: borderColor,
            radius: cornerRadius,
            pattern: borderPattern,
            lineCapMode: .butt,
            edgeMode: edgeMode,
            cornerMode: cornerMode
        )
    }
}

