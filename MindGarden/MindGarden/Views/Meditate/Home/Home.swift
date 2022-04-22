//
//  Home.swift
//  MindGarden
//
//  Created by Dante Kim on 6/11/21.
//

import SwiftUI
import FirebaseAuth
import StoreKit
import Purchases
import Firebase
import FirebaseFirestore
import AppsFlyerLib
import Paywall

var launchedApp = false

enum Sheet: Identifiable {
    case profile, plant, search
    var id: Int {
        hashValue
    }
}

struct Home: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    @State private var showModal = false
    @State private var showSearch = false
    @State private var showUpdateModal = false
    @State private var showMiddleModal = false
    @State private var showIAP = false
    @State private var wentPro = false
    @State private var ios14 = true
    @State private var coins = 0
    @State private var attempts = 0
    @State var activeSheet: Sheet?

    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                GeometryReader { g in
                    VStack {
                        HomeViewHeader(greeting: userModel.greeting, name: userModel.name, streakNumber: $bonusModel.streakNumber, showSearch: $showSearch, activeSheet: $activeSheet, showIAP: $showIAP)
                        //MARK: - scroll view
                        HomeViewScroll(gardenModel: gardenModel, showModal: $showModal, showMiddleModal: $showMiddleModal, activeSheet: $activeSheet, totalBonuses: $bonusModel.totalBonuses, attempts: attempts, userModel: userModel)
                            .padding(.top, -20)
                    }
                    if showModal || showUpdateModal || showMiddleModal || showIAP {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showModal = false
                                showUpdateModal = false
                                showMiddleModal = false
                                showIAP = false
                            }
                        Spacer()
                    }
                    MiddleModal(shown: $showMiddleModal)
                        .offset(y: showMiddleModal ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showMiddleModal)
                    BonusModal(bonusModel: bonusModel, shown: $showModal, coins: $coins)
                        .offset(y: showModal ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showModal)
                    NewUpdateModal(shown: $showUpdateModal, showSearch: $showSearch)
                        .offset(y: showUpdateModal ? 0 : g.size.height)
                        .animation(.default, value: showUpdateModal)
                    IAPModal(shown: $showIAP, fromPage: "home")
                        .offset(y: showIAP ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showIAP)
                }
            }
            .fullScreenCover(isPresented: $userModel.triggerAnimation) {
                PlantGrowing()
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .profile:
                    ProfileScene(profileModel: profileModel)
                                        .environmentObject(userModel)
                                        .environmentObject(gardenModel)
                                        .environmentObject(viewRouter)
                case .plant:
                    Store(isShop: false)
                case .search:
                    CategoriesScene(isSearch: true, showSearch: $showSearch)
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $wentPro) {
                Alert(title: Text("😎 Welcome to the club."), message: Text("🍀 You're now a MindGarden Pro Member"), dismissButton: .default(Text("Got it!")))
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.runCounter))
        { _ in
            if !onboardingTime {
                runCounter(counter: $attempts, start: 0, end: 3, speed: 1)
            }
        }
        .onAppear {
//            storylyViewProgrammatic.openStory(storyGroupId: 42740)
            userModel.checkIfPro()
            DispatchQueue.main.async {
                if #available(iOS 15.0, *) {
                    ios14 = false
                }
                
                if launchedApp {
                    gardenModel.updateSelf()
                    launchedApp = false
                    var num = UserDefaults.standard.integer(forKey: "shownFive")
                    num += 1
                    UserDefaults.standard.setValue(num, forKey: "shownFive")
                    model.getFeaturedMeditation()
                }
                if userWentPro {
                    wentPro = userWentPro
                    userWentPro = false
                }
                numberOfMeds += Int.random(in: -3 ... 3)
                //handle update modal or deeplink
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" {
                    if UserDefaults.standard.bool(forKey: "introLink") {
                        model.selectedMeditation = Meditation.allMeditations.first(where: {$0.id == 6})
                        viewRouter.currentPage = .middle
                        UserDefaults.standard.setValue(false, forKey: "introLink")
                    } else if UserDefaults.standard.bool(forKey: "happinessLink") {
                        model.selectedMeditation = Meditation.allMeditations.first(where: {$0.id == 14})
                        viewRouter.currentPage = .middle
                        UserDefaults.standard.setValue(false, forKey: "happinessLink")
                    }
                }
                if UserDefaults.standard.integer(forKey: "launchNumber") == 2 && !UserDefaults.standard.bool(forKey: "isPro") && !UserDefaults.standard.bool(forKey: "14DayModal") {
                    showUpdateModal = true
                }
                                
                coins = userCoins
                //             self.runCounter(counter: $coins, start: 0, end: coins, speed: 0.015)
            }
        }
        .onAppearAnalytics(event: .screen_load_home)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("notification")))
           { _ in
               mindfulNotifs = true
               activeSheet = .profile
           }
    }
    
    func runCounter(counter: Binding<Int>, start: Int, end: Int, speed: Double) {
        counter.wrappedValue = start
        
        Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            counter.wrappedValue += 1
            if counter.wrappedValue == end {
                counter.wrappedValue = 0
                timer.invalidate()
            }
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}
