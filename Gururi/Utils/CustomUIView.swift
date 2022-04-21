//
//  CustomUIView.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/22.
//

import UIKit

class CustomUIView: UIView, BorderCustomizable {
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
            generateBorderView()
        }
    }

    @IBInspectable var cornerModeName: String = CornerMode.All.rawValue {
        didSet {
            generateBorderView()
        }
    }

    var cornerMode: CornerMode {
        return cornerRadius == 0 ? .None : CornerMode(name: cornerModeName) ?? .All
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            generateBorderView()
        }
    }

    @IBInspectable var borderColorName: String = "Gray" {
        didSet {
            borderColor = RndvColor(name: borderColorName)?.uiColor ?? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            generateBorderView()
        }
    }

    @IBInspectable var borderColorLiteral: UIColor? {
        didSet {
            borderColor = borderColorLiteral ?? .clear
            generateBorderView()
        }
    }

    var borderColor: UIColor = .clear

    @IBInspectable var edgeModeName: String = "None" {
        didSet {
            edgeMode = EdgeMode(name: edgeModeName) ?? .None
            generateBorderView()
        }
    }

    var edgeMode: EdgeMode = .None

    @IBInspectable var borderPatternName: String = "Solid" {
        didSet {
            generateBorderView()
        }
    }

    var borderPattern: BorderPattern {
        return BorderPattern(name: borderPatternName) ?? .Solid
    }

    @IBInspectable var clippingModeName: String = "auto" {
        didSet {
            generateBorderView()
        }
    }

    var clippingMode: ClippingMode {
        return ClippingMode(rawValue: clippingModeName) ?? .auto
    }

    override var bounds: CGRect {
        didSet {
            generateBorderView()
        }
    }

    func generateBorderView() {
        borderView = BorderView(
            width: borderWidth,
            color: borderColor,
            radius: cornerRadius,
            pattern: borderPattern,
            lineCapMode: .butt,
            edgeMode: edgeMode,
            cornerMode: cornerMode,
            clippingMode: clippingMode
        )
    }
}

enum ClippingMode: String {
    case forceEnabled
    case forceDisabled
    case auto
}
