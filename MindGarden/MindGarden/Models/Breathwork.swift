//
//  Breathwork.swift
//  MindGarden
//
//  Created by Dante Kim on 7/2/22.
//

import SwiftUI

struct Breathwork: Hashable {
    let title: String
    let sequence: [(Int,String)] // i = inhale, h = hold, e = exhale
    let duration: Int // Add up the sequence length
    let color: BreathColor
    let description: String
    let category: Category
    let img: Image
    let id: Int
    let instructor: String
    let isNew: Bool
    let tip: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Breathwork, rhs: Breathwork) -> Bool {
        return lhs.id == rhs.id
    }
    
    static var breathworks: [Breathwork] = [
        Breathwork(title: "Waking Up", sequence: [(6, "i"),(0, "h"),(2, "e")], duration: 8,  color: .energy, description: "Waking up was designed to increase energy, alertness, and to start the day ", category: .all, img: Img.sun, id: 0, instructor: "none", isNew: false, tip: "")
    ]
}

enum BreathColor {
    case calm, health, energy, sleep
    
    var primary: Color {
        switch self {
        case .calm: return Clr.calmPrimary
        case .health: return Clr.healthPrimary
        case .energy: return Clr.energyPrimary
        case .sleep: return Clr.sleepPrimary
        }
    }
    
    var secondary: Color {
        switch self {
        case .calm: return Clr.calmsSecondary
        case .health: return Clr.healthSecondary
        case .energy: return Clr.energySecondary
        case .sleep: return Clr.sleepSecondary
        }
    }
    
}
