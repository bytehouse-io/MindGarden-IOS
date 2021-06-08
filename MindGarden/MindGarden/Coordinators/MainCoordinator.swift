//
//  MainCoordinator.swift
//  MindGarden
//
//  Created by Dante Kim on 6/6/21.
//

import Foundation
import SwiftUI

import Stinsen

class MainCoordinator: ViewCoordinatable {
    var children = ViewChild()

    enum Route: ViewRoute {
        case onboarding
        case home
    }

    func resolveRoute(route: Route) -> AnyCoordinatable {
        switch route {
        case .onboarding:
            return AnyCoordinatable(NavigationViewCoordinatable(OnboardingCoordinator()))
        case .home:
            return AnyCoordinatable(OnboardingCoordinator())
        }
    }

    @ViewBuilder func start() -> some View {
        OnboardingScene()
    }
}

