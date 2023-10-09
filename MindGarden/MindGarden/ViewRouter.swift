//
//  ViewRouter.swift
//  MindGarden
//
//  Created by Dante Kim on 6/7/21.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var previousPage: Page = .meditate
    @Published var currentPage: Page = {
        if DefaultsManager.standard.value(forKey: .loggedIn).boolValue {
            return .meditate
        } else if DefaultsManager.standard.value(forKey: .review).boolValue {
            return .meditate
        } else {
            switch DefaultsManager.standard.value(forKey: .onboarding).onboardingValue {
            case .done: return .meditate
            case .signedUp: return .meditate
            case .mood: return .meditate
            case .gratitude: return .meditate
            case .meditate: return .garden
            case .stats: return .garden
            case .calendar: return .garden
            case .garden: return .meditate
//            case .loadingIllusion: return .loadingIllusion
            default: return .onboarding
            }
        }
    }()

    @Published var progressValue: Float = 0.3
}

enum Page: Equatable {
    case meditate
    case garden
    case shop
    case play
    case categories(incomingCase: CategoryIncomingCase)
    case middle(incomingCase: MiddleIncomingCase)
    case breathMiddle
    case authentication
    case finished
    case onboarding
    case experience
    case reason
    case meditationGoal
    case notification
    case name
    case pricing
    case review
    case learn
    case mood
    case journal
    case meditationCompleted
    case congratulationsOnCompletion
        
    case journey
//    case quickStart
    case quickStart
//    case loadingIllusion
}

enum CategoryIncomingCase: String, Equatable {
    case home
    case quickStart
    case journey
    case discover
}

enum MiddleIncomingCase: Equatable {
    case journeyMiddle
    case homeCategory
    case quickStartCategory
    case journeyCategory
    case discoverCategory
    case home
}
