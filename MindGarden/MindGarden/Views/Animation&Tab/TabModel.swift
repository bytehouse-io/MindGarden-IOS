//
//  TabModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 22/02/22.
//

import SwiftUI

enum TabType: String {
    case garden
    case meditate
    case shop
    case profile
}

var tabList = [
    TabMenuItem(image: Img.plantIcon, tabName: .garden, color: .red),
    TabMenuItem(image: Img.meditateIcon, tabName: .meditate, color: .purple),
    TabMenuItem(image: Img.shopIcon, tabName: .shop, color: .blue),
    TabMenuItem(image: Img.profileIcon, tabName: .profile, color: .orange)
]

struct TabMenuItem: Identifiable {
    var id = UUID()
    var image: Image
    var tabName: TabType
    var color: Color
}




