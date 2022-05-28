//
//  QuickStartModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 28/05/22.
//

import SwiftUI

enum QuickStartType: String {
    case newMeditations,minutes3,minutes5,minutes10,minutes20,popular,morning,tired
}

var quickStartTabList = [
    QuickStartMenuItem(title: .newMeditations),
    QuickStartMenuItem(title: .minutes3),
    QuickStartMenuItem(title: .minutes5),
    QuickStartMenuItem(title: .minutes10),
    QuickStartMenuItem(title: .minutes20),
    QuickStartMenuItem(title: .popular),
    QuickStartMenuItem(title: .morning),
    QuickStartMenuItem(title: .tired),
]

struct QuickStartMenuItem: Identifiable {
    var id = UUID()
    var title: QuickStartType
    
    var name: String {
        switch title {
        case .newMeditations: return "New Meditations"
        case .minutes3: return "3 Minutes"
        case .minutes5: return "5 Minutes"
        case .minutes10: return "10 Minutes"
        case .minutes20: return "15-20 Minutes"
        case .popular: return "Popular"
        case .morning: return "Morning"
        case .tired: return "Tired/Burnt out"
        }
    }
    
    var image: Image {
        switch title {
        case .newMeditations: return Img.min15
        case .minutes3: return Img.min15
        case .minutes5: return Img.min15
        case .minutes10: return Img.min15
        case .minutes20: return Img.min15
        case .popular: return Img.min15
        case .morning: return Img.min15
        case .tired: return Img.min15
        }
    }
    
}
