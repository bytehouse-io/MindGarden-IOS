//
//  Course.swift
//  MindGarden
//
//  Created by Dante Kim on 2/18/22.
//

struct LearnCourse: Hashable {
    let title: String
    let img: String
    let description: String
    let duration: String
    let category: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    static func == (lhs: LearnCourse, rhs: LearnCourse) -> Bool {
        return lhs.title == rhs.title
    }
    // ADD TO WIDGET
    static var courses: [LearnCourse] = []
}
