//
//  Sound.swift
//  MindGarden
//
//  Created by Dante Kim on 8/8/21.
//

import SwiftUI

enum Sound {
    case rain
    case night
    case nature
    case fire
    case beach
    case fourThirtyTwo
    case fourteen
    case eleven
    case six
    case flute
    case guitar
    case music
    case piano1
    case piano2
    case noSound

    var img: Image {
        switch self {
        case .rain:
            return Image(systemName: "cloud.rain")
        case .night:
            return Image(systemName: "moon.stars")
        case .nature:
            return Image(systemName: "leaf")
        case .beach:
            return Image("beach")
        case .fire:
            return Image(systemName: "flame")
        case .fourThirtyTwo:
            return Img.fourThirtyTwo
        case .fourteen:
            return Img.fourteen
        case .eleven:
            return Img.eleven
        case .six:
            return Img.six
        case .flute:
            return Img.fluteNotes
        case .guitar:
            return Img.guitar
        case .piano1:
            return Img.piano1
        case .piano2:
            return Img.piano2
        case .music:
            return Img.music
        case .noSound:
            return Image("beach")
        }
    }
    
    var title: String {
        switch self {
        case .rain:
            return "rain"
        case .night:
            return "night"
        case .nature:
            return "nature"
        case .beach:
            return "beach"
        case .fire:
            return "fire"
        case .fourThirtyTwo:
            return "432hz"
        case .fourteen:
            return "14hz"
        case .eleven:
            return "11hz"
        case .six:
            return "6hz"
        case .piano1:
            return "piano1"
        case .piano2:
            return "piano2"
        case .flute:
            return "flute"
        case .guitar:
            return "guitar"
        case .music:
            return "music"
        
        case .noSound:
            return "noSound"
        }
    }

    static func getSound(str: String) -> Sound {
        switch str {
        case "rain":
            return .rain
        case "night":
            return .night
        case "nature":
            return .nature
        case "beach":
            return .beach
        case "fire":
            return .fire
        case "432hz":
            return .fourThirtyTwo
        case "14hz":
            return .fourteen
        case "11hz":
            return .eleven
        case "6hz":
            return .six
        case "piano1":
            return .piano1
        case "piano2":
            return .piano2
        case "flute":
            return .flute
        case "guitar":
            return .guitar
        case "music":
            return .music
        case "noSound":
            return .noSound
        default:
            return .noSound
        }
    }
}
