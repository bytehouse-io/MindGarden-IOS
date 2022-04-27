//
//  RererralsModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 27/04/22.
//


import SwiftUI

enum ReferralType: String {
    case ref1
    case ref2
    case ref3
}

var referralList = [
    ReferralItem(tabName:.ref1),
    ReferralItem(tabName:.ref2),
    ReferralItem(tabName:.ref3)
]

struct ReferralItem: Identifiable {
    var id = UUID()
    var tabName: ReferralType
    
    var image: Image {
        switch self.tabName {
        case .ref1: return Img.books
        case .ref2: return Img.brain
        case .ref3: return Img.candle
        }
    }
    
    var title : String {
        switch self.tabName {
        case .ref1: return "Enter monthly $150 rare plants giveaway!"
        case .ref2: return "Enter monthly $150 rare plants giveaway!"
        case .ref3: return "Enter monthly $150 rare plants giveaway!"
        }
    }
    
    var subTitle: String {
        switch self.tabName {
        case .ref1: return "share your flora garden with friends enter to win up to $150 worth of rare plants every month!"
        case .ref2: return "share your flora garden with friends enter to win up to $150 worth of rare plants every month!"
        case .ref3: return "share your flora garden with friends enter to win up to $150 worth of rare plants every month!"
        }
    }
}
