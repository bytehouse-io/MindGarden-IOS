//
//  Util.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI
import Foundation


struct K {
    static var userPreferences = "userPreferences"
    static func getMoodImage(mood: Mood) -> Image {
        switch mood {
        case .happy:
            return Img.happy
        case .sad:
            return Img.sad
        case .angry:
            return Img.angry
        case .okay:
            return Img.okay
        default:
            return Img.okay
        }
    }
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }

    static func isIpod() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH <= 568.0
    }

    static func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    static func hasNotch() -> Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
