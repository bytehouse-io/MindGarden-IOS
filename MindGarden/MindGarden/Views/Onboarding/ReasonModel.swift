//
//  ReasonModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 22/04/22.
//
import SwiftUI

enum ReasonType: String {
    case sleep
    case focus
    case anxiety
    case trying
}

var reasonList = [
    ReasonItem(type:.sleep),
    ReasonItem(type:.focus),
    ReasonItem(type:.anxiety),
    ReasonItem(type:.trying),
]

struct ReasonItem: Identifiable, Hashable {
    var id = UUID()
    var type: ReasonType
    
    var img: Image {
        switch self.type {
        case .sleep: return Img.moon
        case .focus: return Img.target
        case .anxiety: return Img.heart
        case .trying: return Img.magnifyingGlass
        }
    }
    
    var tag: String {
        switch self.type {
        case .sleep: return "sleepBetter"
        case .focus: return "focused"
        case .anxiety: return "anxiety"
        case .trying: return "trying"
        }
    }
    
    var title: String {
        switch self.type {
        case .sleep: return "Sleep better"
        case .focus: return "Get more focused"
        case .anxiety: return "Managing Stress & Anxiety"
        case .trying: return "Just trying it out"
        }
    }
    

    
    var event: AnalyticEvent {
        switch self.type {
        case .sleep: return .reason_tapped_sleep
        case .focus: return .reason_tapped_focus
        case .anxiety: return .reason_tapped_stress
        case .trying: return .reason_tapped_trying
        }
    }
}
