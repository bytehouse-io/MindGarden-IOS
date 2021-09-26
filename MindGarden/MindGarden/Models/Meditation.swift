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

    static var allMeditations = [
        Meditation(title: "Open-Ended Meditation", description: "Unguided meditation with no time limit, with the option to add a gong sounds every couple of minutes.", belongsTo: "none", category: .unguided, img: Img.starfish, type: .course, id: 1, duration: 0, reward: 0),

        Meditation(title: "Timed Meditation", description: "Timed unguided (no talking) meditation, with the option to turn on background noises such as rain. A bell will signal the end of your session.", belongsTo: "none", category: .unguided, img: Img.daisy, type: .course, id: 2, duration: 0, reward: 0),
        Meditation(title: "1 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy, type: .lesson, id: 3, duration: 5, reward: 2),
        Meditation(title: "2 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy, type: .lesson, id: 4, duration: 120, reward: 4),
        Meditation(title: "5 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy, type: .lesson, id: 5, duration: 300, reward: 6),

        // Beginners Course
        Meditation(title: "Intro to Meditation", description: "Learn how to meditate and why making it a habit can drastically improve happiness, focus and so much more", belongsTo: "none", category: .courses, img: Img.juiceBoxes, type: .course, id: 6, duration: 300, reward: 0),
        Meditation(title: "Why Meditate?", description: "Learn why millions of people around the world use this daily practice.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 7, duration: 300, reward: 8),
        Meditation(title: "Power of breathing", description: "Discover the amazing power of the breath, and how you can use it to become present and calm in every situation.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 8, duration: 5, reward: 8),
        Meditation(title: "Concentration Muscle", description: "Discover how meditating can help you exercise one the most important muscles in the brain.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 9, duration: 300, reward: 8),
        Meditation(title: "Gaining Clarity", description: "Learn how meditating can help you think and observe much more clearly.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 10, duration: 300, reward: 8),
        Meditation(title: "Joy on demand", description: "Discover how meditating can help you create the super power of generating happiness on demand.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 11, duration: 5, reward: 8),
        Meditation(title: "No Agenda", description: "Learn how meditation can help you let go, and help you become a person with no hidden motives.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 12, duration: 300, reward: 8),
        Meditation(title: "Create Your Safe Place", description: "Discover how meditating can create a safe haven you acccess at a moments notice.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 13, duration: 300, reward: 8),

        //Intermediate Course
        Meditation(title: "Guided Meditation", description: "A 7 day series, where we focus on the breath and try to become present and grateful.", belongsTo: "none", category: .courses, img: Img.morningSun, type: .lesson, id: 14, duration: 0, reward: 0),
        Meditation(title: "Day 1", description: "Day 1 of the 7 day guided meditation series, where we focus on the breath and try to become present and grateful.", belongsTo: "none", category: .courses, img: Img.morningSun, type: .lesson, id: 15, duration: 0, reward: 0),
        Meditation(title: "Day 2", description: "Day 2 of the 7 day guided meditation series, where we focus on the breath and try to become present and grateful.", belongsTo: "none", category: .courses, img: Img.morningSun, type: .lesson, id: 16, duration: 0, reward: 0),
        Meditation(title: "Day 3", description: "Day 3 of the 7 day guided meditation series, where we focus on the breath and try to become present and grateful.", belongsTo: "none", category: .courses, img: Img.morningSun, type: .lesson, id: 17, duration: 0, reward: 0),
        Meditation(title: "Day 4", description: "Day 4 of the 7 day guided meditation series, where we focus on the breath and try to become present and grateful.", belongsTo: "none", category: .courses, img: Img.morningSun, type: .lesson, id: 18, duration: 0, reward: 0),
        Meditation(title: "Day 5", description: "Day 5 of the 7 day guided meditation series, where we focus on the breath and try to become present and grateful.", belongsTo: "none", category: .courses, img: Img.morningSun, type: .lesson, id: 19, duration: 0, reward: 0),
        Meditation(title: "Day 6", description: "Day 6 of the 7 day guided meditation series, where we focus on the breath and try to become present and grateful.", belongsTo: "none", category: .courses, img: Img.morningSun, type: .lesson, id: 20, duration: 0, reward: 0),
        Meditation(title: "Day 7", description: "Day 7 of the 7 day guided meditation series, where we focus on the breath and try to become present and grateful.", belongsTo: "none", category: .courses, img: Img.morningSun, type: .lesson, id: 21, duration: 0, reward: 0),

        // Singles
        Meditation(title: "30 Second  Meditation", description: "A super quick, 30 second breath work session.", belongsTo: "none", category: .all, img: Img.morningSun, type: .single, id: 22, duration: 30, reward: 3),

    ]
}

enum MeditationType {
    case single
    case lesson
    case course
}
