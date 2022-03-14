//
//  Array+Extensions.swift
//  MindGarden
//
//  Created by Dante Kim on 2/9/22.
//

import Foundation
import SwiftUI

extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}
