//
//  Int+Extension.swift
//  MindGarden
//
//  Created by apple on 23/10/23.
//

import Foundation

extension Int {
    static func getRandom(in from: Range<Int>) -> Int {
        if from.lowerBound == from.upperBound {
            return from.lowerBound
        } else {
            return self.random(in: from)
        }
    }
}
