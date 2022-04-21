//
//  Array+Extentions.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/11/09.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
