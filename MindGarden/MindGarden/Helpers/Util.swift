//
//  Util.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI
import Foundation


struct K {
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
    static var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
