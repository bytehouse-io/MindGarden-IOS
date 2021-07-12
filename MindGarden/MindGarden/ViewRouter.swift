//
//  ViewRouter.swift
//  MindGarden
//
//  Created by Dante Kim on 6/7/21.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .profile
    
}

enum Page {
    case meditate
    case garden
    case shop
    case profile
    case play
}
