//
//  QuickStartModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 28/05/22.
//

import SwiftUI

enum QuickStartType: String {
    case newMeditations,minutes3,minutes5,minutes10,minutes20,popular,morning,anxiety,unguided,courses, sleep
}

var quickStartTabList = [
    QuickStartMenuItem(title: .minutes3),
    QuickStartMenuItem(title: .minutes5),
    QuickStartMenuItem(title: .minutes10),
    QuickStartMenuItem(title: .minutes20),
    QuickStartMenuItem(title: .newMeditations),
    QuickStartMenuItem(title: .courses),
    QuickStartMenuItem(title: .unguided),
    QuickStartMenuItem(title: .popular),
    QuickStartMenuItem(title: .morning),
    QuickStartMenuItem(title: .sleep),
    QuickStartMenuItem(title: .anxiety),
]

struct QuickStartMenuItem: Identifiable {
    var id = UUID()
    var title: QuickStartType
    
    static func getName(str: String) -> QuickStartType {
        switch str {
        case  "New Meditations": return .newMeditations
        case "3 Minutes": return .minutes3
        case "5 Minutes": return .minutes5
        case "10 Minutes": return .minutes10
        case "15-20 Minutes": return .minutes20
        case "Popular": return .popular
        case "Morning": return .morning
        case "Unguided/timed": return .unguided
        case "Anxiety/Stress": return .anxiety
        case "Night/Sleep": return .sleep
        case "Courses": return .courses
        default: return .minutes3
        }
    }
    
    var name: String {
        switch title {
        case .newMeditations: return "New Meditations"
        case .minutes3: return "3 Minutes"
        case .minutes5: return "5 Minutes"
        case .minutes10: return "10 Minutes"
        case .minutes20: return "15-20 Minutes"
        case .popular: return "Popular"
        case .morning: return "Morning"
        case .unguided: return "Unguided/timed"
        case .anxiety: return "Anxiety/Stress"
        case .sleep: return "Night/Sleep"
        case .courses: return "Courses"
        }
    }
    
    var image: Image {
        switch title {
        case .newMeditations: return Img.newMeds
        case .minutes3: return Img.min3
        case .minutes5: return Img.min5
        case .minutes10: return Img.min10
        case .minutes20: return Img.min15
        case .popular: return Img.popular
        case .morning: return Img.morning
        case .anxiety: return Img.tired
        case .unguided: return Img.unguided
        case .sleep: return Img.sleep
        case .courses: return Img.courses
        }
    }
    
}
