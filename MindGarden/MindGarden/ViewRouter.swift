//
//  ViewRouter.swift
//  MindGarden
//
//  Created by Dante Kim on 6/7/21.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = UserDefaults.standard.bool(forKey: K.defaults.loggedIn) ? .meditate : UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" ? .meditate : .onboarding
}

enum Page {
    case meditate
    case garden
    case shop
    case profile
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
}
