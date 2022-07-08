//
//  DiscoverModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 26/05/22.
//

import SwiftUI

enum TopTabType: String {
    case journey,quickStart, learn, store, badge, realTree
}

var discoverTabList = [
    MenuItem(tabName: .journey),
    MenuItem(tabName: .quickStart),
    MenuItem(tabName: .learn)
]
var storeTabList = [
    MenuItem(tabName: .store),
    MenuItem(tabName: .badge),
    MenuItem(tabName: .realTree)
]


struct MenuItem: Identifiable {
    var id = UUID()
    var tabName: TopTabType
    
    var name: String {
        switch self.tabName {
        case .journey: return "Journey"
        case .quickStart: return "Quick Start"
        case .learn: return "Learn"
        case .store: return "Store"
        case .badge: return "Badge"
        case .realTree: return "Real Tree"
        }
    }
}
