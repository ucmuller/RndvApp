//
//  String+Extentions.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/11/09.
//

import Foundation

extension String {
    func matches(pattern: String) -> [NSTextCheckingResult] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        return regex.matches(in: self, range: NSRange(location: 0, length: count))
    }

    func isMatch(pattern: String) -> Bool {
        return matches(pattern: pattern).count > 0
    }

    func isValidEmail() -> Bool {
        return isMatch(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }

    func isValidPasswordPattern() -> Bool {
        let passwordRegex = "^(?=.*[a-zA-Z0-9]).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

    func isNumeric() -> Bool{
        return isMatch(pattern: "(^$)|(^\\d*$)")
    }
    
    func isTelNumber() -> Bool {
        return isMatch(pattern: "^\\d{10,11}$")
    }
}
