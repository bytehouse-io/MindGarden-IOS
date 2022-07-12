//
//  PromptsModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 30/06/22.
//

import SwiftUI

enum PromptsTabType: String {
    case gratitude,mentalHealth,night,morning
}

var promptsTabList = [
    PromptsMenuItem(tabName: .gratitude),
    PromptsMenuItem(tabName: .mentalHealth),
    PromptsMenuItem(tabName: .night),
    PromptsMenuItem(tabName: .morning)
]

struct PromptsMenuItem: Identifiable {
    var id = UUID()
    var tabName: PromptsTabType
    
    var name: String {
        switch self.tabName {
        case .gratitude:
            return "Gratitude"
        case .mentalHealth:
            return "Mental Health"
        case .night:
            return "Night"
        case .morning:
            return "Morning"
        }
    }
}
