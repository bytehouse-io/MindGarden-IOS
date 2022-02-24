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
    case learn
}

var tabList = [
    TabMenuItem(image: Img.plantIcon, tabName: .garden, color: .white),
    TabMenuItem(image: Img.meditateIcon, tabName: .meditate, color: .white),
    TabMenuItem(image: Img.pencilIcon, tabName: .learn, color: .white),
    TabMenuItem(image: Img.shopIcon, tabName: .shop, color: .white)
]

struct TabMenuItem: Identifiable {
    var id = UUID()
    var image: Image
    var tabName: TabType
    var color: Color
}




