//
//  AppDelegate.swift
//  MindGarden
//
//  Created by Dante Kim on 5/25/21.
//

import Amplitude
import AppsFlyerLib
import AVFoundation
import Firebase
import FirebaseDynamicLinks
import GoogleSignIn
import MWMPublishingSDK
import NukeRemoteImageLoader
import OneSignal
//import Purchases
import UIKit
// import Paywall
import WidgetKit
import SwiftUI

var player: AVAudioPlayer?

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @objc func sendLaunch() {
        AppsFlyerLib.shared().start()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MWM.setRemoteImageLoader(NukeRemoteImageLoader())

        let placements = MWMModel.DynamicScreenPlacement.allCases.map {
            PlacementRequest(placementKey: $0.rawValue, orientation: .portrait)
        }
        let uiElementsIDs = MWMModel.DynamicEmbeddedUIElements.allCases.map { $0.rawValue }
  
        MWM.initWithLaunchInfo(
            launchOptions,
            legacyFeatures: nil,
            verbose: true,
            uiElementsProvider: self,
            uiElementsIDs: uiElementsIDs,
            capabilities: nil,
            placements: placements,
            transactionDelegate: nil
        )

        playSound(soundName: "background")
        // Override point for customization after application launch.

        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "mindgarden.page.link"
        FirebaseApp.configure()

        let installationId = MWM.installationId()
        Crashlytics.crashlytics().setUserID(installationId)

        // Appsflyer
        AppsFlyerLib.shared().appsFlyerDevKey = "MuYPR9jvHqxu7TzZCrTNcn"
        AppsFlyerLib.shared().appleAppID = "1588582890"
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().isDebug = true

        Amplitude.instance().trackingSessionEvents = true
        // Initialize SDK
        // Set userId
        // Log an event

        // TODO: test amplitude match up with revenuecat
        sendLaunch()
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        // OneSignal initialization
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("7f964cf0-550e-426f-831e-468b9a02f012")

//        Purchases.logLevel = .debug
//        Purchases.automaticAppleSearchAdsAttributionCollection = true
//        Purchases.configure(withAPIKey: "wuPOzKiCUvKWUtiHEFRRPJoksAdxJMLG")
//        Amplitude.instance().initializeApiKey("76399802bdea5c85e4908f0a1b922bda", userId: Purchases.shared.appUserID)
//        Purchases.shared.collectDeviceIdentifiers()

        if let onesignalId = OneSignal.getDeviceState().userId {
//            Purchases.shared.setOnesignalID(onesignalId)
        }
//        Purchases.shared.setAttributes(["$amplitudeDeviceId": Amplitude.instance().deviceId])
//        Purchases.shared.delegate = self
        // Set the Appsflyer Id
//        Purchases.shared.setAppsflyerID(AppsFlyerLib.shared().getAppsFlyerUID())
        // enables debug logs
//        PaywallService.initPaywall()
        // promptForPushNotifications will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)

        // Add state change listener for Firebase Authentication
        
        Auth.auth().addStateDidChangeListener { _, user in
            if let uid = user?.email {
                // identify Purchases SDK with new Firebase user
//                Purchases.shared.logIn(uid) { _, _, error in
//                    if let e = error {
//                        print("Sign in error: \(e.localizedDescription)")
//                    } else {
//                        print("User \(uid) signed in")
//                    }
//                }
            }
        }

        application.beginReceivingRemoteControlEvents()
        UNUserNotificationCenter.current().delegate = self
        
        let isFirstLaunch = UserDefaults.isFirstLaunch()
        print(isFirstLaunch, "isFirstLaunch")

        if isFirstLaunch {
            UserDefaults.deleteAll()
            do {
                try Auth.auth().signOut()
            } catch { print("already logged out") }
        }

<<<<<<< Updated upstream
        if UserDefaults.standard.value(forKey: "vibrationMode") == nil {
            UserDefaults.standard.set(true, forKey: "vibrationMode")
        }

        if UserDefaults.standard.value(forKey: "backgroundAnimation") == nil {
            UserDefaults.standard.set(true, forKey: "backgroundAnimation")
=======
        if DefaultsManager.standard.value(forKey: .vibrationMode).isNil
//            DefaultsManager.standard.value(forKey: "vibrationMode") == nil
        {
            DefaultsManager.standard.set(value: true, forKey: .vibrationMode)
//            UserDefaults.standard.set(true, forKey: "vibrationMode")
        }

        if DefaultsManager.standard.value(forKey: .backgroundAnimation).isNil
//            DefaultsManager.standard.value(forKey: "backgroundAnimation") == nil
        {
            DefaultsManager.standard.set(value: true, forKey: .backgroundAnimation)
//            UserDefaults.standard.set(true, forKey: "backgroundAnimation")
>>>>>>> Stashed changes
        }

        return true
    }

    func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player?.volume = 0.1
            player?.numberOfLoops = -1

            guard let player = player else { return }
            if UserDefaults.standard.bool(forKey: "isPlayMusic") {
                player.play()
            }

        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func handlIncomingDynamicLink(_ dynamicLink: DynamicLink?) -> Bool {
        guard let dynamicLink = dynamicLink else { return false }
        guard let deepLink = dynamicLink.url else { return false }
        let queryItems = URLComponents(url: deepLink, resolvingAgainstBaseURL: true)?.queryItems
        let invitedBy = queryItems?.filter { item in item.name == "invitedby" }.first?.value
        let user = Auth.auth().currentUser
        // If the user isn't signed in and the app was opened via an invitation
        // link, sign in the user anonymously and record the referrer UID in the
        // user's RTDB record.
        if user == nil && invitedBy != nil {
            Auth.auth().signInAnonymously { _, _ in
//          if let user = user {
//            let userRecord = Database.database().reference().child("users").child(user.uid)
//            userRecord.child("referred_by").setValue(invitedBy)
//            if dynamicLink.matchConfidence == .weak {e
//              // If the Dynamic Link has a weak match confidence, it is possible
//              // that the current device isn't the same device on which the invitation
//              // link was originally opened. The way you handle this situation
//              // depends on your app, but in general, you should avoid exposing
//              // personal information, such as the referrer's email address, to
//              // the user.
//            }
//          }
            }
        }
        return true
    }

//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//       print("excalibur")
//    }
//
    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        let deepLink = url.valueOf("deep_link_id") ?? ""
        if deepLink != "" {
            guard let urlComponents = URLComponents(string: deepLink), let queryItems = urlComponents.queryItems else { return false }
            for item in queryItems {
                if item.name == "referral" {
                    Analytics.shared.log(event: .onboarding_came_from_referral)
                    UserDefaults.standard.setValue(item.value ?? "", forKey: K.defaults.referred)
                }
            }
        }
        return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_: UIApplication, continue _: NSUserActivity,
                     restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        return false
    }
}

// MARK: AppsFlyerLibDelegate

extension AppDelegate: AppsFlyerLibDelegate {
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
//        print("onConversionDataSuccess data:")
//        for (key, value) in installData {
//            print(key, ":", value)
//        }
        if let status = installData["af_status"] as? String {
            if status == "Non-organic" {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"]
                {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                    if "\(sourceID)" == "influencer" {
                        fromInfluencer = "\(campaign)"
                        let identify = AMPIdentify()
                            .set("influencer", value: NSString(utf8String: "\(campaign)"))
                        Amplitude.instance().identify(identify ?? AMPIdentify())
                    }
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool,
               is_first_launch
            {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }

    func onConversionDataFail(_ error: Error) {
        print(error)
    }

    // Handle Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
//        Handle Deep Link Data
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":", value)
        }
    }

    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "oneDay" {
            Analytics.shared.log(event: .notification_tapped_oneDay_reminder)
        } else if response.notification.request.identifier == "introNotif" {
            NotificationCenter.default.post(name: Notification.Name("intro"), object: nil)
            Analytics.shared.log(event: .notification_tapped_oneDay_reminder)
        } else if response.notification.request.identifier == "threeDay" {
            Analytics.shared.log(event: .notification_tapped_threeDay_reminder)
        } else if response.notification.request.identifier == "streakNotStarted" {
            Analytics.shared.log(event: .notification_tapped_streakNotStarted)
        } else if response.notification.request.identifier == "finishOnboarding" {
            Analytics.shared.log(event: .notification_tapped_onboarding)
        } else if response.notification.request.identifier == "⚙️ Widget has been unlocked" {
            Analytics.shared.log(event: .notification_tapped_widget)
            NotificationCenter.default.post(name: Notification.Name("widget"), object: nil)
        } else if response.notification.request.identifier == "🛍 Your Store Page has been unlocked!" {
            Analytics.shared.log(event: .notification_tapped_store)
            NotificationCenter.default.post(name: Notification.Name("store"), object: nil)
        } else if response.notification.request.identifier == "🔑 Learn Page has unlocked!" {
            Analytics.shared.log(event: .notification_tapped_learn)
            NotificationCenter.default.post(name: Notification.Name("learn"), object: nil)
        }
        completionHandler()
    }
}

extension AppDelegate: MWMEmbeddedUIElementsProvider {
    func view(forIdentifier identifier: String, actionsHandler: ActionsHandler?, nextActionCompletion: @escaping () -> Void) -> MWMEmbeddedUIElement {
        switch MWMModel.DynamicEmbeddedUIElements(rawValue: identifier) {
        case .nativeOnboardingSlide:
            return MWMEmbeddedUIElement(
                type: .viewController,
                embeddedUIElement: SetRouteViewControlller(nextActionCompletion)
            )
        case .none:
            return MWMEmbeddedUIElement()
        }
    }
}

class SetRouteViewControlller: UIViewController {
    var closure: (() -> Void)?
    let router = ViewRouter()
    lazy var authModel = AuthenticationViewModel(userModel: SceneDelegate.userModel, viewRouter: router)

    init(_ closure: @escaping (() -> Void)) {
        super.init(nibName: nil, bundle: nil)
        self.closure = closure
        setClosureValue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setClosureValue() {
        closure = { [weak self] in
            guard let self = self else { return }
            print("SetRouteViewControlller setClosureValue")
            let contentView = ContentView(bonusModel: SceneDelegate.bonusModel, profileModel: SceneDelegate.profileModel, authModel: self.authModel)

            // Use a UIHostingController as window root view controller.
            let rootHost = UIHostingController(rootView: contentView
                .environmentObject(self.router)
                .environmentObject(SceneDelegate.medModel)
                .environmentObject(SceneDelegate.userModel)
                .environmentObject(SceneDelegate.gardenModel))
            
        }
    }
}
