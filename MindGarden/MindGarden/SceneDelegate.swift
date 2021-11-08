//
//  SceneDelegate.swift
//  MindGarden
//
//  Created by Dante Kim on 5/25/21.
//

import UIKit
import SwiftUI
var numberOfMeds = 0
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    static let userModel = UserViewModel()
    static let bonusModel = BonusViewModel(userModel: userModel)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // Create the SwiftUI view that provides the window contents.
        numberOfMeds = Int.random(in: 60..<83)
//        UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
        if !UserDefaults.standard.bool(forKey: "showedNotif") {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    Analytics.shared.log(event: .onboarding_notification_on)
                    NotificationHelper.addOneDay()
                    NotificationHelper.addThreeDay()
                } else {
                    Analytics.shared.log(event: .onboarding_notification_off)
                }
                UserDefaults.standard.setValue(true, forKey: "showedNotif")
            }
        }
        var launchNum = UserDefaults.standard.integer(forKey: "launchNumber")
        launchNum += 1
        UserDefaults.standard.setValue(launchNum, forKey: "launchNumber")

        let router = ViewRouter()
        let medModel = MeditationViewModel()

        let gardenModel = GardenViewModel()
        let profileModel = ProfileViewModel()
        let authModel =  AuthenticationViewModel(userModel:  SceneDelegate.userModel, viewRouter: router)
        let userModel = UserViewModel()
        medModel.updateSelf()
        SceneDelegate.userModel.updateSelf()
        gardenModel.updateSelf()
        SceneDelegate.bonusModel.updateBonus()

        if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "done" {
            SceneDelegate.bonusModel.totalBonuses = 1
            SceneDelegate.bonusModel.sevenDayProgress = 0.1
            SceneDelegate.bonusModel.thirtyDayProgress = 0.08
        }

        let contentView = ContentView(bonusModel:  SceneDelegate.bonusModel, profileModel: profileModel, authModel: authModel)

        // Use a UIHostingController as window root view controller.
        let rootHost = UIHostingController(rootView: contentView
                                            .environmentObject(router)
                                            .environmentObject(medModel)
                                            .environmentObject(SceneDelegate.userModel)
                                            .environmentObject(gardenModel))
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = rootHost
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        SceneDelegate.bonusModel.updateBonus()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

