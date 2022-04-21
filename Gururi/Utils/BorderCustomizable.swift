//
//  BorderCustomizable.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/22.
//

import UIKit

protocol BorderCustomizable: class {
    var borderView: BorderView? { get set }

    var cornerRadius: CGFloat { get set }
    var cornerModeName: String { get set }
    var cornerMode: CornerMode { get }
    var borderWidth: CGFloat { get set }
    var borderColorName: String { get set }
    var borderColor: UIColor { get }
    var edgeModeName: String { get set }
    var edgeMode: EdgeMode { get }
    var borderPatternName: String { get set }
    var borderPattern: BorderPattern { get }

    func generateBorderView()
}

// specify which corner(s) to braw
enum CornerMode: String {
    case All
    case None

    case Top
    case Trailing
    case Bottom
    case Leading

    case Slashed
    case BackSlashed

    case TopLeft
    case TopRight
    case BottomRight
    case BottomLeft

    case NoTopLeft
    case NoTopRight
    case NoBottomRight
    case NoBottomLeft

    init?(name: String) {
        self.init(rawValue: name)
    }
}

enum EdgeMode: String {
    case All
    case None

    case Top
    case Trailing
    case Bottom
    case Leading

    case TopBottom
    case LeadingTrailing

    case TopTrailing
    case BottomLeading
    case TopLeading
    case BottomTrailing

    case NoTop
    case NoTrailing
    case NoBottom
    case NoLeading

    init? (name: String) {
        self.init(rawValue: name)
    }
}

enum BorderPattern: String {
    case Solid
    case Dotted
    case Dashed
    case LongDashed

    init? (name: String) {
        self.init(rawValue: name)
    }

    var patternArray: [CGFloat] {
        return type(of: self).arrayByBorderPattern[self]!
    }

    fileprivate static let arrayByBorderPattern: [BorderPattern: [CGFloat]] = [
        .Solid: [],
        .Dotted: [1, 1],
        .Dashed: [2, 2],
        .LongDashed: [0.0, 4.0],
    ]

    fileprivate static let borderPatternByName: [String: BorderPattern] = [
        "Solid": .Solid,
        "Dotted": .Dotted,
        "Dashed": .Dashed,
        "Custom": .LongDashed,
    ]
}

// to specify draw mode for border line's endpoint
// see more details on the reference page for 'UIBezierPath'

enum LineCapMode {
    case butt
    case round
    case square

    func getCGMode() -> CGLineCap {
        switch self {
        case .butt:
            return CGLineCap.butt
        case .round:
            return CGLineCap.round
        case .square:
            return CGLineCap.square
        }
    }
}
