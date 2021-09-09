//
//  ViewRouter.swift
//  MindGarden
//
//  Created by Dante Kim on 6/7/21.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = UserDefaults.standard.bool(forKey: K.defaults.loggedIn) ? .meditate : .onboarding
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
    case notification
}
