//
//  BorderView.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/22.
//

import CoreGraphics
import UIKit

class BorderView: UIView {
    var radius: CGFloat = 0.0
    var lineWidth: CGFloat = 1.0
    var lineColor: UIColor = UIColor.black
    var linePattern: [CGFloat] = []
    var edgeMode: EdgeMode = .All
    var cornerMode: CornerMode = .All
    var lineCapMode: LineCapMode = .butt
    var clippingMode: ClippingMode = .auto

    var correctedLineCap: CGLineCap {
        if edgeMode != .All && linePattern.count == 0 && lineCapMode == .butt {
            return LineCapMode.square.getCGMode() // to fill the gap on both ends of the stroke
        }
        else {
            return lineCapMode.getCGMode()
        }
    }

    var pathFlatness: CGFloat = 0.6

    // MARK: draw flags for each part of the border

    var drawTop: Bool {
        switch edgeMode {
        case .All, .Top, .TopBottom, .TopTrailing, .TopLeading, .NoTrailing, .NoBottom, .NoLeading:
            return true
        default:
            return false
        }
    }

    var drawTrailing: Bool {
        switch edgeMode {
        case .All, .Trailing, .LeadingTrailing, .TopTrailing, .BottomTrailing, .NoTop, .NoBottom, .NoLeading:
            return true
        default:
            return false
        }
    }

    var drawBottom: Bool {
        switch edgeMode {
        case .All, .Bottom, .TopBottom, .BottomLeading, .BottomTrailing, .NoTop, .NoTrailing, .NoLeading:
            return true
        default:
            return false
        }
    }

    var drawLeading: Bool {
        switch edgeMode {
        case .All, .Leading, .LeadingTrailing, .BottomLeading, .TopLeading, .NoTop, .NoTrailing, .NoBottom:
            return true
        default:
            return false
        }
    }

    // MARK: round-flags for each corner

    var roundTopLeft: Bool {
        switch cornerMode {
        case .All, .Top, .Leading, .BackSlashed, .TopLeft, .NoTopRight, .NoBottomRight, .NoBottomLeft:
            return true
        default:
            return false
        }
    }

    var roundTopRight: Bool {
        switch cornerMode {
        case .All, .Top, .Trailing, .Slashed, .TopRight, .NoTopLeft, .NoBottomRight, .NoBottomLeft:
            return true
        default:
            return false
        }
    }

    var roundBottomRight: Bool {
        switch cornerMode {
        case .All, .Bottom, .Trailing, .BackSlashed, .BottomRight, .NoTopLeft, .NoTopRight, .NoBottomLeft:
            return true
        default:
            return false
        }
    }

    var roundBottomLeft: Bool {
        switch cornerMode {
        case .All, .Bottom, .Leading, .Slashed, .BottomLeft, .NoTopLeft, .NoTopRight, .NoBottomRight:
            return true
        default:
            return false
        }
    }

    var drawTopLeftCorner: Bool {
        return drawLeading && drawTop
    }

    var drawTopRightCorner: Bool {
        return drawTop && drawTrailing
    }

    var drawBottomRightCorner: Bool {
        return drawTrailing && drawBottom
    }

    var drawBottomLeftCorner: Bool {
        return drawBottom && drawLeading
    }

    // MARK: corner radius inherited from parent view

    var _halfLineWidth: CGFloat?
    var halfLineWidth: CGFloat {
        if _halfLineWidth == nil { _halfLineWidth = lineWidth / 2.0 - 0.1 }
        return _halfLineWidth!
    }

    var _correctedRadius: CGFloat?
    var correctedRadius: CGFloat {
        if _correctedRadius == nil { _correctedRadius = max(0, 0, radius - halfLineWidth) }
        return _correctedRadius!
    }

    // MARK: named positions for border drawing

    var borderTopLeftRadius: CGFloat {
        return roundTopLeft ? correctedRadius : 0.0
    }

    var borderTopRightRadius: CGFloat {
        return roundTopRight ? correctedRadius : 0.0
    }

    var borderBottomRightRadius: CGFloat {
        return roundBottomRight ? correctedRadius : 0.0
    }

    var borderBottomLeftRadius: CGFloat {
        return roundBottomLeft ? correctedRadius : 0.0
    }

    var _borderTopLeft: CGPoint?
    var _borderTopRight: CGPoint?
    var _borderBottomRight: CGPoint?
    var _borderBottomLeft: CGPoint?

    var borderTopLeft: CGPoint {
        if _borderTopLeft == nil { _borderTopLeft = CGPoint(x: bounds.origin.x + halfLineWidth, y: bounds.origin.y + halfLineWidth) }
        return _borderTopLeft!
    }

    var borderTopRight: CGPoint {
        if _borderTopRight == nil { _borderTopRight = CGPoint(x: bounds.width - halfLineWidth, y: bounds.origin.y + halfLineWidth) }
        return _borderTopRight!
    }

    var borderBottomRight: CGPoint {
        if _borderBottomRight == nil { _borderBottomRight = CGPoint(x: bounds.width - halfLineWidth, y: bounds.height - halfLineWidth) }
        return _borderBottomRight!
    }

    var borderBottomLeft: CGPoint {
        if _borderBottomLeft == nil { _borderBottomLeft = CGPoint(x: bounds.origin.x + halfLineWidth, y: bounds.height - halfLineWidth) }
        return _borderBottomLeft!
    }

    var borderTopLeftCornerEntry: CGPoint { return CGPoint(x: borderTopLeft.x, y: borderTopLeft.y + borderTopLeftRadius) }
    var borderTopLeftCornerExit: CGPoint { return CGPoint(x: borderTopLeft.x + borderTopLeftRadius, y: borderTopLeft.y) }
    var borderTopLeftCornerCenter: CGPoint { return CGPoint(x: borderTopLeft.x + borderTopLeftRadius, y: borderTopLeft.y + borderTopLeftRadius) }

    var borderTopRightCornerEntry: CGPoint { return CGPoint(x: borderTopRight.x - borderTopRightRadius, y: borderTopRight.y) }
    var borderTopRightCornerExit: CGPoint { return CGPoint(x: borderTopRight.x, y: borderTopRight.y + borderTopRightRadius) }
    var borderTopRightCornerCenter: CGPoint { return CGPoint(x: borderTopRight.x - borderTopRightRadius, y: borderTopRight.y + borderTopRightRadius) }

    var borderBottomRightCornerEntry: CGPoint { return CGPoint(x: borderBottomRight.x, y: borderBottomRight.y - borderBottomRightRadius) }
    var borderBottomRightCornerExit: CGPoint { return CGPoint(x: borderBottomRight.x - borderBottomRightRadius, y: borderBottomRight.y) }
    var borderBottomRightCornerCenter: CGPoint { return CGPoint(x: borderBottomRight.x - borderBottomRightRadius, y: borderBottomRight.y - borderBottomRightRadius) }

    var borderBottomLeftCornerEntry: CGPoint { return CGPoint(x: borderBottomLeft.x + borderBottomLeftRadius, y: borderBottomLeft.y) }
    var borderBottomLeftCornerExit: CGPoint { return CGPoint(x: borderBottomLeft.x, y: borderBottomLeft.y - borderBottomLeftRadius) }
    var borderBottomLeftCornerCenter: CGPoint { return CGPoint(x: borderBottomLeft.x + borderBottomLeftRadius, y: borderBottomLeft.y - borderBottomLeftRadius) }

    // MARK: named positions for masking

    var maskTopLeftRadius: CGFloat {
        return roundTopLeft ? radius : 0.0
    }
    var maskTopRightRadius: CGFloat {
        return roundTopRight ? radius : 0.0
    }
    var maskBottomRightRadius: CGFloat {
        return roundBottomRight ? radius : 0.0
    }
    var maskBottomLeftRadius: CGFloat {
        return roundBottomLeft ? radius : 0.0
    }

    var maskTopLeft: CGPoint { return CGPoint(x: bounds.origin.x, y: bounds.origin.y) }
    var maskTopRight: CGPoint { return CGPoint(x: bounds.width, y: bounds.origin.y) }
    var maskBottomRight: CGPoint { return CGPoint(x: bounds.width, y: bounds.height) }
    var maskBottomLeft: CGPoint { return CGPoint(x: bounds.origin.x, y: bounds.height) }

    var maskTopLeftCornerEntry: CGPoint { return CGPoint(x: maskTopLeft.x, y: maskTopLeft.y + maskTopLeftRadius) }
    var maskTopLeftCornerExit: CGPoint { return CGPoint(x: maskTopLeft.x + maskTopLeftRadius, y: maskTopLeft.y) }
    var maskTopLeftCornerCenter: CGPoint { return CGPoint(x: maskTopLeft.x + maskTopLeftRadius, y: maskTopLeft.y + maskTopLeftRadius) }

    var maskTopRightCornerEntry: CGPoint { return CGPoint(x: maskTopRight.x - maskTopRightRadius, y: maskTopRight.y) }
    var maskTopRightCornerExit: CGPoint { return CGPoint(x: maskTopRight.x, y: maskTopRight.y + maskTopRightRadius) }
    var maskTopRightCornerCenter: CGPoint { return CGPoint(x: maskTopRight.x - maskTopRightRadius, y: maskTopRight.y + maskTopRightRadius) }

    var maskBottomRightCornerEntry: CGPoint { return CGPoint(x: maskBottomRight.x, y: maskBottomRight.y - maskBottomRightRadius) }
    var maskBottomRightCornerExit: CGPoint { return CGPoint(x: maskBottomRight.x - maskBottomRightRadius, y: maskBottomRight.y) }
    var maskBottomRightCornerCenter: CGPoint { return CGPoint(x: maskBottomRight.x - maskBottomRightRadius, y: maskBottomRight.y - maskBottomRightRadius) }

    var maskBottomLeftCornerEntry: CGPoint { return CGPoint(x: maskBottomLeft.x + maskBottomLeftRadius, y: maskBottomLeft.y) }
    var maskBottomLeftCornerExit: CGPoint { return CGPoint(x: maskBottomLeft.x, y: maskBottomLeft.y - maskBottomLeftRadius) }
    var maskBottomLeftCornerCenter: CGPoint { return CGPoint(x: maskBottomLeft.x + maskBottomLeftRadius, y: maskBottomLeft.y - maskBottomLeftRadius) }

    // MARK: initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        // clear background with transparent color
        backgroundColor = UIColor.clear
        isOpaque = true

        // use auto layout
        translatesAutoresizingMaskIntoConstraints = false

        // to avoid prevent touch events
        isUserInteractionEnabled = false

        // use auto layout to fill the parent view
        translatesAutoresizingMaskIntoConstraints = false
        if let parent = superview {
            parent.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "|[item]|", options: [], metrics: nil, views: ["item": self])
                    + NSLayoutConstraint.constraints(withVisualFormat: "V:|[item]|", options: [], metrics: nil, views: ["item": self])
            )
        }

        // redraw border on laytout change
        contentMode = .redraw
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(width: CGFloat, color: UIColor) {
        self.init(width: width, color: color, radius: 0.0, pattern: .Solid, lineCapMode: .butt, edgeMode: .All, cornerMode: .All)
    }

    convenience init(width: CGFloat, color: UIColor, radius: CGFloat) {
        self.init(width: width, color: color, radius: radius, pattern: .Solid, lineCapMode: .butt, edgeMode: .All, cornerMode: .All)
    }

    convenience init(width: CGFloat, color: UIColor, pattern: BorderPattern) {
        self.init(width: width, color: color, radius: 0.0, pattern: pattern, lineCapMode: .butt, edgeMode: .All, cornerMode: .All)
    }

    convenience init(width: CGFloat, color: UIColor, radius: CGFloat, pattern: BorderPattern) {
        self.init(width: width, color: color, radius: radius, pattern: pattern, lineCapMode: .butt, edgeMode: .All, cornerMode: .All)
    }

    convenience init(width: CGFloat, color: UIColor, radius: CGFloat, pattern: BorderPattern, lineCapMode: LineCapMode) {
        self.init(width: width, color: color, radius: radius, pattern: pattern, lineCapMode: lineCapMode, edgeMode: .All, cornerMode: .All)
    }

    convenience init(width: CGFloat, color: UIColor, edgeMode: EdgeMode) {
        self.init(width: width, color: color, radius: 0.0, pattern: .Solid, lineCapMode: .butt, edgeMode: edgeMode, cornerMode: .All)
    }

    convenience init(width: CGFloat, color: UIColor, pattern: BorderPattern, edgeMode: EdgeMode) {
        self.init(width: width, color: color, radius: 0.0, pattern: pattern, lineCapMode: .butt, edgeMode: edgeMode, cornerMode: .All)
    }

    convenience init(width: CGFloat, color: UIColor, radius: CGFloat, pattern: BorderPattern, edgeMode: EdgeMode) {
        self.init(width: width, color: color, radius: radius, pattern: pattern, lineCapMode: .butt, edgeMode: edgeMode, cornerMode: .All)
    }

    convenience init(width: CGFloat, color: UIColor, radius: CGFloat, edgeMode: EdgeMode, cornerMode: CornerMode) {
        self.init(width: width, color: color, radius: radius, pattern: .Solid, lineCapMode: .butt, edgeMode: edgeMode, cornerMode: cornerMode)
    }

    convenience init(radius: CGFloat, cornerMode: CornerMode) {
        self.init(width: 0.0, color: UIColor.clear, radius: radius, pattern: .Solid, lineCapMode: .butt, edgeMode: .None, cornerMode: cornerMode)
    }

    convenience init(width: CGFloat, color: UIColor, radius: CGFloat, pattern: BorderPattern, lineCapMode: LineCapMode, edgeMode: EdgeMode, cornerMode: CornerMode, clippingMode: ClippingMode = .auto) {
        self.init()

        lineWidth = width
        lineColor = color
        self.radius = radius
        linePattern = pattern.patternArray
        self.lineCapMode = lineCapMode
        self.edgeMode = edgeMode
        self.cornerMode = cornerMode
        self.clippingMode = clippingMode
    }

    // adding constraints on added to a view

    override func didMoveToSuperview() {
        let views: [String: UIView] = ["item": self]
        if let parent = self.superview {
            parent.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "|[item]|", options: [], metrics: nil, views: views)
                    + NSLayoutConstraint.constraints(withVisualFormat: "V:|[item]|", options: [], metrics: nil, views: views)
            )
        }
    }

    // lines drawer

    override func draw(_ rect: CGRect) {
        if edgeMode != .None {
            drawBorderLines()
        }

        switch clippingMode {
        case .forceEnabled:
            addLayerMask()
        case .auto:
            if edgeMode == .None && cornerMode != .None {
                addLayerMask()
            }
        default: break
        }

        layoutIfNeeded()
    }

    func drawBorderLines() {
        let line = UIBezierPath()
        lineColor.setStroke()
        line.lineWidth = lineWidth
        line.flatness = pathFlatness
        line.setLineDash(linePattern, count: linePattern.count, phase: 0)
        line.lineCapStyle = correctedLineCap

        if drawTopLeftCorner {
            line.move(to: borderTopLeftCornerEntry)
            line.addArc(withCenter: borderTopLeftCornerCenter, radius: borderTopLeftRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        }

        if drawTop {
            if !drawTopLeftCorner { line.move(to: borderTopLeftCornerExit) }
            line.addLine(to: borderTopRightCornerEntry)
        }

        if drawTopRightCorner {
            if !drawTop { line.move(to: borderTopRightCornerEntry) }
            line.addArc(withCenter: borderTopRightCornerCenter, radius: borderTopRightRadius, startAngle: CGFloat(1.5 * Double.pi), endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
        }

        if drawTrailing {
            if !drawTopRightCorner { line.move(to: borderTopRightCornerExit) }
            line.addLine(to: borderBottomRightCornerEntry)
        }

        if drawBottomRightCorner {
            if !drawTrailing { line.move(to: borderBottomRightCornerEntry) }
            line.addArc(withCenter: borderBottomRightCornerCenter, radius: borderBottomRightRadius, startAngle: CGFloat(0.0), endAngle: CGFloat(0.5 * Double.pi), clockwise: true)
        }

        if drawBottom {
            if !drawBottomRightCorner { line.move(to: borderBottomRightCornerExit) }
            line.addLine(to: borderBottomLeftCornerEntry)
        }

        if drawBottomLeftCorner {
            if !drawBottom { line.move(to: borderBottomLeftCornerEntry) }
            line.addArc(withCenter: borderBottomLeftCornerCenter, radius: borderBottomLeftRadius, startAngle: CGFloat(0.5 * Double.pi), endAngle: CGFloat(1.0 * Double.pi), clockwise: true)
        }

        if drawLeading {
            if !drawBottomLeftCorner { line.move(to: borderBottomLeftCornerExit) }
            line.addLine(to: borderTopLeftCornerEntry)
        }

        line.stroke()

        layoutIfNeeded()
    }

    func addLayerMask() {
        if let superview = superview {
            let mask = UIBezierPath()
            mask.flatness = pathFlatness
            let maskLayer = CAShapeLayer()

            // generate clipping mask
            mask.move(to: maskTopLeftCornerEntry)
            mask.addArc(withCenter: maskTopLeftCornerCenter, radius: maskTopLeftRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
            mask.addLine(to: maskTopRightCornerEntry)
            mask.addArc(withCenter: maskTopRightCornerCenter, radius: maskTopRightRadius, startAngle: CGFloat(1.5 * Double.pi), endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
            mask.addLine(to: maskBottomRightCornerEntry)
            mask.addArc(withCenter: maskBottomRightCornerCenter, radius: maskBottomRightRadius, startAngle: CGFloat(0.0), endAngle: CGFloat(0.5 * Double.pi), clockwise: true)
            mask.addLine(to: maskBottomLeftCornerEntry)
            mask.addArc(withCenter: maskBottomLeftCornerCenter, radius: maskBottomLeftRadius, startAngle: CGFloat(0.5 * Double.pi), endAngle: CGFloat(1.0 * Double.pi), clockwise: true)
            mask.addLine(to: maskTopLeftCornerEntry)

            mask.close()

            // layer
            maskLayer.frame = superview.bounds
            maskLayer.path = mask.cgPath
            superview.layer.mask = maskLayer
        }
    }
}
