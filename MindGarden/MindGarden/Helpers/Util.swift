//
//  Util.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI
import Foundation


struct K {
    static func getMoodImage(mood: String) -> Image {
        switch mood {
        case "happy":
            return Img.happy
        case "sad":
            return Img.sad
        case "angry":
            return Img.angry
        case "okay":
            return Img.okay
        default:
            return Img.okay
        }
    }
}
