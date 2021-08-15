//
//  Meditation.swift
//  MindGarden
//
//  Created by Dante Kim on 8/7/21.
//

import SwiftUI

struct Meditation: Hashable {
    let title: String
    let description: String
    let belongsTo: String
    let category: Category
    let img: Image
    let type: MeditationType
    let id: Int
    let duration: Float
    let reward: Int
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Meditation, rhs: Meditation) -> Bool {
        return lhs.title == rhs.title
    }

    static var allMeditations = [Meditation(title: "Open-Ended Meditation", description: "description", belongsTo: "none", category: .unguided, img: Img.daisy, type: .course, id: 1, duration: 0, reward: 0), Meditation(title: "Timed Meditation", description: "Timed unguided (no talking) meditation, with the option to turn on background noises such as rain. A bell will signal the end of your session.", belongsTo: "none", category: .unguided, img: Img.daisy, type: .course, id: 2, duration: 0, reward: 0),  Meditation(title: "1 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy, type: .lesson, id: 3, duration: 15, reward: 3), Meditation(title: "2 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy, type: .lesson, id: 4, duration: 120, reward: 6), Meditation(title: "5 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy, type: .lesson, id: 5, duration: 300, reward: 10)]
}

enum MeditationType {
    case single
    case lesson
    case course
}
