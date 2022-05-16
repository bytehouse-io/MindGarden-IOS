//
//  SceneDelegate.swift
//  MindGarden
//
//  Created by Dante Kim on 5/25/21.
//

import UIKit
import SwiftUI
import AppsFlyerLib
import FirebaseDynamicLinks
import Firebase
import Foundation
import OneSignal
import Storyly

var numberOfMeds = 0
var storylyViewProgrammatic = StorylyView()
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    static let userModel = UserViewModel()
    static let gardenModel = GardenViewModel()
    static let bonusModel = BonusViewModel(userModel: userModel, gardenModel: gardenModel)
    let router = ViewRouter()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        return formatter
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // Create the SwiftUI view that provides the window contents.
//        UserDefaults.standard.setValue(false, forKey: "tappedRate")
        UserDefaults.standard.setValue("meditate", forKey: K.defaults.onboarding)
        let launchNum = UserDefaults.standard.integer(forKey: "launchNumber")

//        UserDefaults.standard.setValue(["Bijan 8", "Quote 1", "Tale 2", "New Users"], forKey: "oldSegments")
        if launchNum == 0 {
            UserDefaults.standard.setValue(["New Users", "Bijan 1", "Quote 1", "Tale 1", "Tip New Users", "trees for the future"], forKey: "oldSegments")
            UserDefaults.standard.setValue(["New Users", "Bijan 1", "Quote 1", "Tale 1", "Tip New Users", "trees for the future"] , forKey: "storySegments")
            UserDefaults.standard.setValue(formatter.string(from: Date()), forKey: "userDate")
            UserDefaults.standard.setValue(["White Daisy"], forKey: K.defaults.plants)
            UserDefaults.standard.setValue("White Daisy", forKey: K.defaults.selectedPlant)
            UserDefaults.standard.setValue("432hz", forKey: "sound")
            UserDefaults.standard.setValue(50, forKey: "coins")
            UserDefaults.standard.setValue(2, forKey: "frequency")
            UserDefaults.standard.setValue(["gratitude", "smiling", "loving", "breathing", "present"], forKey: "notifTypes")
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd,yyyy"
            UserDefaults.standard.setValue(formatter.string(from: Date()), forKey: "joinDate")
            UserDefaults.standard.setValue(true, forKey: "newUser")
            UserDefaults.standard.setValue(1, forKey: "launchNumber")
        }
        UserDefaults.standard.removeObject(forKey: K.defaults.referred)
        Analytics.shared.log(event: .launchedApp)

        let medModel = MeditationViewModel()

        let profileModel = ProfileViewModel()
        let authModel =  AuthenticationViewModel(userModel:  SceneDelegate.userModel, viewRouter: router)
        medModel.updateSelf()
        SceneDelegate.userModel.updateSelf()
        SceneDelegate.gardenModel.updateSelf()
        FirebaseAPI.fetchMeditations(meditationModel: medModel)
        FirebaseAPI.fetchCourses()

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
                                            .environmentObject(SceneDelegate.gardenModel))
        
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = rootHost
            storylyViewProgrammatic.rootViewController = rootHost
            self.window = window
            window.makeKeyAndVisible()
        }
        // Get URL components from the incoming user activity.
            if let userActivity = connectionOptions.userActivities.first {
                  processUserActivity(userActivity)
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
        numberOfMeds = Int.random(in: 785..<811)
        launchedApp = true
        Analytics.shared.log(event: .sceneDidBecomeActive)
        SceneDelegate.bonusModel.updateBonus()
        SceneDelegate.userModel.updateSelf()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if let _ = UserDefaults.standard.array(forKey: "oldSegments") as? [String] {} else {
            UserDefaults.standard.setValue(["Bijan 1", "Quote 1", "Tale 1", "trees for the future", "tip potion shop"], forKey: "oldSegments")
            UserDefaults.standard.setValue(["Bijan 1", "Quote 1", "Tale 1", "trees for the future", "tip potion shop"], forKey: "oldSegments")
        }
        
        if UserDefaults.standard.bool(forKey: "reddit") && !UserDefaults.standard.bool(forKey: "redditOne") {
            SceneDelegate.userModel.willBuyPlant = Plant.badgePlants.first(where: { p in
                p.title == "Apples"
            })
            SceneDelegate.userModel.buyPlant(unlockedStrawberry: true)
            SceneDelegate.userModel.showPlantAnimation = true
            UserDefaults.standard.setValue(true, forKey: "redditOne")
        }

        
        StorylyManager.updateStories()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.  
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // use this to add friends
        // Get URL components from the incoming user activity.
        processUserActivity(userActivity)
 
        if let incomingUrl = userActivity.webpageURL {
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl) { (dynamicLink, error) in
                guard error == nil else {
                    print("Found an error \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handlIncomingDynamicLink(dynamicLink)
                }
            }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            if context.url.scheme == "christmas" {
                UserDefaults.standard.setValue(true, forKey: "christmasLink")
            } else if context.url.scheme == "intro" || context.url.host == "intro"  {
                UserDefaults.standard.setValue(true, forKey: "introLink")
            } else if context.url.scheme == "happiness" || context.url.host == "happiness" {
                UserDefaults.standard.setValue(true, forKey: "happinessLink")
            } else if context.url.scheme == "gratitude" || context.url.host == "gratitude" {
                NotificationCenter.default.post(name: Notification.Name("gratitude"), object: nil)
            } else if context.url.scheme == "meditate" || context.url.host == "meditate" {
                NotificationCenter.default.post(name: Notification.Name("meditate"), object: nil)
            } else if context.url.scheme == "mood" || context.url.host == "mood" {
                NotificationCenter.default.post(name: Notification.Name("mood"), object: nil)
            } else if context.url.scheme == "pro" || context.url.host == "pro" {
                NotificationCenter.default.post(name: Notification.Name("pro"), object: nil)
            } else if context.url.scheme == "garden" || context.url.host == "garden" {
                NotificationCenter.default.post(name: Notification.Name("garden"), object: nil)
            }
        }
        if let url = URLContexts.first?.url {
            AppsFlyerLib.shared().handleOpen(url, options: nil)
        }
    }

    func handlIncomingDynamicLink(_ dynamicLink: DynamicLink?) {
      guard let dynamicLink = dynamicLink else { return }
      guard let deepLink = dynamicLink.url else { return }
      let queryItems = URLComponents(url: deepLink, resolvingAgainstBaseURL: true)?.queryItems
      let invitedBy = queryItems?.filter({(item) in item.name == "referral"}).first?.value
      let user = Auth.auth().currentUser
      // If the user isn't signed in and the app was opened via an invitation
      // link, sign in the user anonymously and record the referrer UID in the
      // user's RTDB record.
      if user == nil && invitedBy != nil {
          Analytics.shared.log(event: .onboarding_came_from_referral)
          UserDefaults.standard.setValue(invitedBy, forKey: K.defaults.referred)
          if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" && UserDefaults.standard.bool(forKey: K.defaults.loggedIn) {
                        self.router.currentPage = .authentication
          }
      }
    }
}

extension URL {
 func valueOf(_ queryParamaterName: String) -> String? {
 guard let url = URLComponents(string: self.absoluteString) else { return nil }
 return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value?.removingPercentEncoding?.removingPercentEncoding
 }
}


extension SceneDelegate {
    private func processUserActivity(_ userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let urlToOpen = userActivity.webpageURL else {
                  return
              }
        
        print("Universal Link: \(urlToOpen)")
            processUniversalLinkData(
                pathComponents: getUniversalLinkPathComponentsAndParams(urlToOpen).0,
                queryParams: getUniversalLinkPathComponentsAndParams(urlToOpen).1
            )
        
    }
    
    private func getUniversalLinkPathComponentsAndParams(_ url: URL) -> (
        [String],
        [String: String]
    ){
        let pathComponents = url.pathComponents.filter { component in
            component != "/"
        }
        
        var queryParams = [String: String]()
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let queryItems = urlComponents?.queryItems {
            for queryItem in queryItems {
                if let val = queryItem.value {
                    queryParams[queryItem.name] = val
                }
            }
        }
        
        return (pathComponents, queryParams)
    }

    private func processUniversalLinkData(
        pathComponents: [String],
        queryParams: [String: String]
    ) {
        // Process the data
        print(pathComponents, "pathComponents")
        print(queryParams, "queryParams")
    }
}
