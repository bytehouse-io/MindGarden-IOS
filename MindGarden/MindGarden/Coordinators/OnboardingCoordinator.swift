//
//  OnboardingCoordinator.swift
//  MindGarden
//
//  Created by Dante Kim on 6/6/21.
//

import Foundation
import SwiftUI

import Stinsen

class OnboardingCoordinator: NavigationCoordinatable {
    var navigationStack = NavigationStack()

    enum Route: NavigationRoute {
    }

    func resolveRoute(route: Route) -> Transition {
    }

    @ViewBuilder func start() -> some View {
        OnboardingScene()
    }

    init() { }


}
