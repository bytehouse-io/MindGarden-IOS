//
//  ViewRouter.swift
//  MindGarden
//
//  Created by Dante Kim on 6/7/21.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .meditate
//    UserDefaults.standard.bool(forKey: K.defaults.loggedIn) ? .meditate : UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" ? .meditate : .onboarding
    @Published var progressValue: Float = 0.3
}

enum Page {
    case meditate
    case garden
    case shop
    case play
    case categories
    case middle
    case authentication
    case finished
    case onboarding
    case experience
    case reason
    case notification
    case name
    case pricing
    case review
    case learn
}
