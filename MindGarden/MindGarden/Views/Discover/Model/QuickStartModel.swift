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
    QuickStartMenuItem(title: .newMeditations),
    QuickStartMenuItem(title: .minutes3),
    QuickStartMenuItem(title: .minutes5),
    QuickStartMenuItem(title: .minutes10),
    QuickStartMenuItem(title: .minutes20),
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
        case .newMeditations: return Image("")
        case .minutes3: return Img.min3
        case .minutes5: return Img.min5
        case .minutes10: return Img.min10
        case .minutes20: return Img.min15
        case .popular: return Img.popular
        case .morning: return Img.morning
        case .anxiety: return Img.tired
        case .unguided: return Img.alarmClock
        case .sleep: return Img.moon
        case .courses: return Img.educatedRacoon
        }
    }
    
}
