//
//  UIApplicationScene.swift
//  MindGarden
//
//  Created by apple on 25/04/23.
//

import Foundation
import UIKit.UIApplication

extension UIApplication {
    var activeScene: UIWindowScene? {
        connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
    
    var window: UIWindow? {
        (activeScene?.delegate as? SceneDelegate)?.window
    }
}
