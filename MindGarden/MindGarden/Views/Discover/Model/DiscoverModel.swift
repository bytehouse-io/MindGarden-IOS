//
//  DiscoverModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 26/05/22.
//

import SwiftUI

enum DiscoverTabType: String {
    case journey,quickStart,learn
}

var discoverTabList = [
    DiscoverMenuItem(tabName: .journey),
    DiscoverMenuItem(tabName: .quickStart),
    DiscoverMenuItem(tabName: .learn)
]

struct DiscoverMenuItem: Identifiable {
    var id = UUID()
    var tabName: DiscoverTabType
    
    var name: String {
        switch self.tabName {
        case .journey: return "Journey"
        case .quickStart: return "Quick Start"
        case .learn: return "Learn"
        }
    }
}
