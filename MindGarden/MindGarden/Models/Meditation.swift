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

    func returnEventName() -> String {
        return self.title.replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "&", with: "").replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "_")
            .lowercased()
    }

    static var allMeditations = [
//        Meditation(title: "Open-Ended Meditation", description: "Unguided meditation with no time limit, with the option to add a gong sounds every couple of minutes.", belongsTo: "none", category: .unguided, img: Img.starfish, type: .course, id: 1, duration: 0, reward: 0),

        Meditation(title: "Timed Meditation", description: "Timed unguided (no talking) meditation, with the option to turn on background noises such as rain. A bell will signal the end of your session.", belongsTo: "none", category: .unguided, img: Img.chatBubble, type: .course, id: 2, duration: 0, reward: 0),
        Meditation(title: "1 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 3, duration: 60, reward: 2),
        Meditation(title: "2 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 4, duration: 120, reward: 4),
        Meditation(title: "5 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 5, duration: 300, reward: 6),
        Meditation(title: "10 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 28, duration: 600, reward: 10),
        Meditation(title: "15 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 29, duration: 900, reward: 14),
        Meditation(title: "20 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 30, duration: 1200, reward: 17),
        Meditation(title: "25 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 31, duration: 1500, reward: 20),
        Meditation(title: "30 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 32, duration: 1800, reward: 22),
        Meditation(title: "45 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 33, duration: 2700, reward: 25),
        Meditation(title: "1 Hour Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 34, duration: 3600, reward: 30),
        Meditation(title: "2 Hour Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy3, type: .lesson, id: 35, duration: 7200, reward: 35),


        // Beginners Course
        Meditation(title: "Intro to Meditation", description: "Learn how to meditate and why making it a habit can drastically improve happiness, focus and so much more", belongsTo: "none", category: .courses, img: Img.juiceBoxes, type: .course, id: 6, duration: 0, reward: 0),
        Meditation(title: "Why Meditate?", description: "Learn why millions of people around the world use this daily practice.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 7, duration: 320, reward: 8),
        Meditation(title: "Create Your Anchor", description: "Learn how to create an anchor that can help ground you during your most busy and stormy seasons.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 8, duration: 322, reward: 8),
        Meditation(title: "Tuning Into Your Body", description: "Discover how to use the body scan meditation to become more aware of your bodily experiences and the emotions tied to them.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 9, duration: 429, reward: 8),
        Meditation(title: "Gaining Clarity", description: "Learn how meditating can help you think and observe much more clearly.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 10, duration: 292, reward: 8),
        Meditation(title: "Stress Antidote", description: "Learn how daily meditation can be the perfect cure and preventer of stress and anxiety", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 12, duration: 365, reward: 8),
        Meditation(title: "Compassion & Self-Love", description: "Discover how meditating can create boundless amounts of love & compassion for yourself & the people around you", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 13, duration: 314, reward: 8),
        Meditation(title: "Joy on demand", description: "Discover how meditating can help you create the super power of generating happiness on demand.", belongsTo: "Intro to Meditation", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 11, duration: 324, reward: 8),

        //Intermediate Course
        Meditation(title: "7 Days to Happiness", description: "A 7 day series, where we use meditation to become focused, happier and motivated.", belongsTo: "7 Days to Happiness", category: .courses, img: Img.morningSun, type: .course, id: 14, duration: 0, reward: 0),
        Meditation(title: "Clearing the Mind", description: "Learn the fundamentals of clearing all the noise in your head so you can finally learn to listen the right signals.", belongsTo: "7 Days to Happiness", category: .courses, img: Img.morningSun, type: .single_and_lesson, id: 15, duration: 0, reward: 0),
        Meditation(title: "Cultivate Self Love", description: "Do you constantly put your self down? Learn the basics of loving yourself and accepting who you are.", belongsTo: "7 Days to Happiness", category: .courses, img: Img.morningSun, type: .single_and_lesson, id: 16, duration: 0, reward: 0),
        Meditation(title: "Enhance Creativity", description: "Do you constantly feel stuck? Learn how to break-through and unleash the creativity hidden inside you", belongsTo: "7 Days to Happiness", category: .courses, img: Img.morningSun, type: .single_and_lesson, id: 17, duration: 0, reward: 0),
        Meditation(title: "Sustain Focus & Increase Motivation", description: "Build the discipline of laser like focus and rock solid motivation through some breath work and simple observation", belongsTo: "7 Days to Happiness", category: .courses, img: Img.morningSun, type: .single_and_lesson, id: 18, duration: 0, reward: 0),
        Meditation(title: "The Basics", description: "A simple 10 minute guided meditaiton you can do anywhere at anytime, empty the mind, get relaxed and receive clarity.", belongsTo: "7 Days to Happiness", category: .courses, img: Img.morningSun, type: .single_and_lesson, id: 19, duration: 0, reward: 0),
        Meditation(title: "Thankful Meditaiton for Gratitude", description: "Gratitude is the easiest thing you can do to become happier, learn to truly be thankful when having a clear focused mind.", belongsTo: "7 Days to Happiness", category: .courses, img: Img.morningSun, type: .single_and_lesson, id: 20, duration: 0, reward: 0),
        Meditation(title: "Life is Beautiful", description: "When you have no agenda, and simply observe you come to realize just how breath taking life truly is.", belongsTo: "7 Days to Happiness", category: .courses, img: Img.morningSun, type: .single_and_lesson, id: 21, duration: 0, reward: 0),

        // Singles
        Meditation(title: "30 Second Meditation", description: "A super quick, 30 second breath work session.", belongsTo: "none", category: .all, img: Img.strawberryMilk, type: .single, id: 22, duration: 37, reward: 1),
        Meditation(title: "Basic Guided Meditation", description: "A 5 minute guided meditation to help you start or end the day in a mindful matter.", belongsTo: "none", category: .all, img: Img.starfish, type: .single, id: 23, duration: 304, reward: 5),
        Meditation(title: "Semi-Guided Meditation", description: "A 10 minute semi-guided meditation for more advanced meditators looking to start or end their day present, focused, and calm.", belongsTo: "none", category: .all, img: Img.bonfire, type: .single, id: 24, duration: 601, reward: 10),
        Meditation(title: "Meditation for Focus", description: "A simple 5 minute guided meditation to help you calm your mind, and enter a relaxed focused state.", belongsTo: "none", category: .focus, img: Img.magnifyingGlass, type: .single, id: 25, duration: 341, reward: 5),
//        Meditation(title: "Anxiety & Stress", description: "A simple 5 minute guided meditation to help you let go and minimize anxiety & stress.", belongsTo: "none", category: .anxiety, img: Img.morningSun, type: .single, id: 26, duration: 300, reward: 5),
        Meditation(title: "Body Scan", description: "A short guided meditation to help you tune into your body, reconnect to your physical self and notice any sensations without any judgement. ", belongsTo: "none", category: .all, img: Img.heart, type: .single, id: 25, duration: 300, reward: 5),
        Meditation(title: "Better Faster Sleep", description: "A 5 minute guided meditation to help you relax, let go and fall into a deep restful sleep.", belongsTo: "none", category: .sleep, img: Img.moon, type: .single, id: 27, duration: 341, reward: 5),
    ]
}

enum MeditationType {
    case single
    case lesson
    case course
    case single_and_lesson
}
