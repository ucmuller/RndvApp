//
//  Colors.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/08/01.
//

import UIKit

enum RndvColor: String {
    case primary
    case danger
    case black
    case lightBlack
    case yellow
    case darkYellow
    case green
    case lightGreen
    case navy
    case lightGray
    case cyaan
    case orange
    case white

    static let primaryColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
    static let dangerColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
    static let blackColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let lightBlackColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3025203339)
    static let yellowColor = #colorLiteral(red: 1, green: 0.862745098, blue: 0.1568627451, alpha: 1)
    static let darkYellowColor = #colorLiteral(red: 0.716353476, green: 0.5731616616, blue: 0.1256732643, alpha: 1)
    static let greenColor = #colorLiteral(red: 0.09411764706, green: 0.7529411765, blue: 0.7568627451, alpha: 1)
    static let lightGreenColor = #colorLiteral(red: 0.137254902, green: 0.9176470588, blue: 0.6431372549, alpha: 0.2)
    static let navyColor = #colorLiteral(red: 0.001340538729, green: 0.1343186498, blue: 0.3178129196, alpha: 1)
    static let lightGrayColor = #colorLiteral(red: 0.4783571362, green: 0.5255054832, blue: 0.6030912399, alpha: 1)
    static let cyaanColor = #colorLiteral(red: 0.09283027798, green: 0.7519178987, blue: 0.7591142654, alpha: 1)
    static let orangeColor = #colorLiteral(red: 1, green: 0.5564371943, blue: 0, alpha: 1)
    static let whiteColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    var uiColor: UIColor {
        switch self {
        case .primary:
            return #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        case .danger:
            return #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .lightBlack:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3025203339)
        case .yellow:
            return #colorLiteral(red: 1, green: 0.862745098, blue: 0.1568627451, alpha: 1)
        case .darkYellow:
            return #colorLiteral(red: 0.716353476, green: 0.5731616616, blue: 0.1256732643, alpha: 1)
        case .green:
            return #colorLiteral(red: 0.09411764706, green: 0.7529411765, blue: 0.7568627451, alpha: 1)
        case .lightGreen:
            return #colorLiteral(red: 0.137254902, green: 0.9176470588, blue: 0.6431372549, alpha: 0.2)
        case .navy:
            return #colorLiteral(red: 0.001340538729, green: 0.1343186498, blue: 0.3178129196, alpha: 1)
        case .lightGray:
            return #colorLiteral(red: 0.4783571362, green: 0.5255054832, blue: 0.6030912399, alpha: 1)
        case .cyaan:
            return #colorLiteral(red: 0.09283027798, green: 0.7519178987, blue: 0.7591142654, alpha: 1)
        case .orange:
            return #colorLiteral(red: 1, green: 0.5564371943, blue: 0, alpha: 1)
        case .white:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

    init?(name: String) {
        self.init(rawValue: name)
    }
}

