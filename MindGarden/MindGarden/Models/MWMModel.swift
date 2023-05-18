//
//  MWMModel.swift
//  MindGarden
//
//  Created by Dante Kim on 2/19/23.
//

import Foundation

final class MWMModel {
    static var shared = MWMModel()
    enum DynamicScreenPlacement: String, CaseIterable {
        case onboarding = "PUBSBX#app_launch#native_onboarding"
        case store = "PUBSBX#anywhere#store"
    }
    
    enum DynamicEmbeddedUIElements: String, CaseIterable {
        case nativeOnboardingSlide = "native_onboarding_slide"
    }
}
