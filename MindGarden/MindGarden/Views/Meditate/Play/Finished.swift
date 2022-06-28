//
//  Finished.swift
//  MindGarden
//
//  Created by Dante Kim on 7/10/21.
//

import SwiftUI
import Photos
import StoreKit
import AppsFlyerLib
import Amplitude
import Firebase
import OneSignal

struct Finished: View {
    var bonusModel: BonusViewModel
    var model: MeditationViewModel
    var userModel: UserViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    var gardenModel: GardenViewModel
    @State private var sharedImage: UIImage?
    @State private var shotting = true
    @State private var isOnboarding = false
    @State private var animateViews = false
    @State private var favorited = false
    @State private var showUnlockedModal = false
    @State private var reward : Int = 0
    @State private var hideConfetti = false
    @State private var showStreak = false
    @State private var ios14 = true
    @Environment(\.sizeCategory) var sizeCategory

    var minsMed: Int {
        if model.selectedMeditation?.duration == -1 {
            return Int((model.secondsRemaining/60.0).rounded())
        } else {
            if Int(model.selectedMeditation?.duration ?? 0)/60 == 0 {
                return 1
            } else {
                return Int(model.selectedMeditation?.duration ?? 0)/60
            }
        }
    }

    init(bonusModel: BonusViewModel, model: MeditationViewModel, userModel: UserViewModel, gardenModel: GardenViewModel) {
        self.bonusModel = bonusModel
        self.model = model
        self.userModel = userModel
        self.gardenModel = gardenModel
    }

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { g in
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .fill(Clr.finishedGreen)
                                    .frame(width: g.size
                                            .width/1, height: g.size.height/2)
                                    .offset(y: -g.size.height/6)
                                Img.greenBlob
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: g.size.width/1, height: g.size.height/2)
                                    .offset(x: g.size.width/6, y: -g.size.height/6)
                                LottieView(fileName: "confetti")
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                                    .opacity(hideConfetti ? 0 : 1)
                                HStack(alignment: .center) {
                                    VStack {
                                        Text("Minutes Meditated")
                                            .font(Font.fredoka(.semiBold, size: 28))
                                            .foregroundColor(.white)
                                            .onTapGesture {
                                                withAnimation {
                                                    viewRouter.currentPage  = .garden
                                                }
                                            }
                                            .font(Font.fredoka(.bold, size: 70))
                                            .foregroundColor(.white)
                                            .animation(.easeInOut(duration: 1.5))
                                            .opacity(animateViews ? 0 : 1)
                                            .offset(x: animateViews ? 500 : 0)
                                        Text(String(minsMed))
                                            .font(Font.fredoka(.bold, size: 70))
                                            .foregroundColor(.white)
                                            .animation(.easeInOut(duration: 1.5))
                                            .opacity(animateViews ? 0 : 1)
                                            .offset(x: animateViews ? 500 : 0)
                                        VStack {
                                            HStack {
                                                Text("You received:")
                                                    .font(Font.fredoka(.semiBold, size: 24))
                                                    .foregroundColor(.white)
                                                Img.coin
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(height: 25)
                                                Text("+\(reward)!")
                                                    .font(Font.fredoka(.bold, size: 24))
                                                    .foregroundColor(.white)
                                                    .offset(x: -3)
                                                if userModel.isPotion || userModel.isChest {
                                                    Img.sunshinepotion
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(height: 30)
                                                        .rotationEffect(.degrees(30))
                                                }
                                            }.offset(y: sizeCategory > .large ? -60 : -25)
                                            if !isOnboarding {
                                                HStack {
                                                    Button {
                                                    } label: {
                                                        HStack {
                                                            Img.happy.padding([.top, .leading, .bottom])
                                                            Text("Log Mood")
                                                                .foregroundColor(.black)
                                                                .font(Font.fredoka(.semiBold, size: 16))
                                                                .padding(.trailing)
                                                                .lineLimit(1)
                                                                .minimumScaleFactor(0.05)
                                                        }.frame(width: g.size.width * 0.4, height: 45)
                                                            .background(Clr.yellow)
                                                            .cornerRadius(25)
                                                            .onTapGesture {
                                                                withAnimation {
                                                                    hideConfetti = true
                                                                    Analytics.shared.log(event: .home_tapped_categories)
                                                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                                                    impact.impactOccurred()
                                                                    NotificationCenter.default.post(name: Notification.Name("mood"), object: nil)
                                                                }
                                                            }
                                                    }
                                                    .buttonStyle(BonusPress())
                                                    Button { } label: {
                                                        HStack {
                                                            Img.hands
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .padding([.leading])
                                                                .padding(.vertical, 5)
                                                            Text("Gratitude")
                                                                .foregroundColor(.black)
                                                                .font(Font.fredoka(.semiBold, size: 16))
                                                                .padding(.trailing)
                                                                .lineLimit(1)
                                                                .minimumScaleFactor(0.05)
                                                        }.frame(width: g.size.width * 0.4, height: 45)
                                                            .background(Clr.yellow)
                                                            .cornerRadius(25)
                                                            .onTapGesture {
                                                                withAnimation {
                                                                    hideConfetti = true
                                                                    Analytics.shared.log(event: .home_tapped_categories)
                                                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                                                    impact.impactOccurred()
                                                                    NotificationCenter.default.post(name: Notification.Name("gratitude"), object: nil)
                                                                }
                                                            }
                                                    }
                                                    .buttonStyle(BonusPress())
                                                }.frame(width: g.size.width, height: 45)
                                                .padding(.top, 10)
                                                .zIndex(100)
                                                .offset(y: sizeCategory > .large ? -60 : K.isSmall() ? -15 : 0)
                                            }
                                        }.offset(y: !isOnboarding ? 0 : -25)
                                    }.offset(y: !isOnboarding ? 15 : -50)
                                }.padding(.top, ios14 && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "done" ? 50 : 0)
                            }
                  
                            HStack(alignment: .center) {
                                Spacer()
                                VStack(alignment: .center, spacing: 10) {
                                    if !UserDefaults.standard.bool(forKey: "isNotifOn") {
                                        ReminderView()
                                            .frame(width:UIScreen.screenWidth*0.85, height: 250, alignment: .center)
                                            .padding(.top,50)
                                            .padding()
                                            .offset(y: !isOnboarding ? -25 : -100)
                                        Spacer()
                                    }
                                    VStack {
                                        Text("You completed your \(gardenModel.allTimeSessions.ordinal)  session!")
                                            .font(Font.fredoka(.regular, size: 20))
                                            .foregroundColor(Clr.black2)
                                            .padding([.horizontal])
                                        Text("With patience and mindfulness you were able to grow \(userModel.modTitle())!")
                                            .font(Font.fredoka(.bold, size: 22))
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.05)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Clr.black1)
                                            .frame(height: g.size.height/14)
                                            .padding([.horizontal], 15)
                                        userModel.selectedPlant?.badge
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: g.size.height/2.75)
                                            .padding(.top, 10)
                                            .animation(.easeInOut(duration: 2.0))
                                    }.frame(width: g.size.width * 0.85, height: g.size.height/2.25)
                                }
                                Spacer()
                            }.offset(y: !isOnboarding ? -20 : -75)
                        
                        }.offset(y: -g.size.height/6)
                    }.frame(width: g.size.width)
                    HStack {
                        LikeButton(isLiked: favorited, size:25.0) {
                            Analytics.shared.log(event: .finished_tapped_favorite)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            if let med = model.selectedMeditation {
                                model.favorite(selectMeditation: med)
                            }
                            favorited.toggle()
                        }
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Clr.black1)
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                PHPhotoLibrary.requestAuthorization { (status) in
                                    // No crash
                                }
                                let snap = self.takeScreenshot(origin: g.frame(in: .global).origin, size: g.size)
                                let myURL = URL(string: "https://mindgarden.io")
                                let objectToshare = [snap, myURL!] as [Any]
                                let activityVC = UIActivityViewController(activityItems: objectToshare, applicationActivities: nil)
                                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                            }
                        Spacer()
                        Button {
                        } label: {
                            Capsule()
                                .fill(Clr.yellow)
                                .padding(.horizontal)
                                .overlay(
                                    HStack {
                                        Text("Finished")
                                            .foregroundColor(Color.black)
                                            .font(Font.fredoka(.bold, size: 22))
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 22, weight: .bold))
                                    }
                                )
                            // TODO -> change not now in saveProgress modal to trigger showStreak
                                .onTapGesture {
                                    Analytics.shared.log(event: .finished_tapped_finished)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        if UserDefaults.standard.integer(forKey: "numMeds") == 1 {
                                            if UserDefaults.standard.bool(forKey: "review") {
                                                viewRouter.currentPage = .garden
                                            } else {
                                                if updatedStreak && model.shouldStreakUpdate {
                                                    showStreak.toggle()
                                                    updatedStreak = false
                                                } else {
                                                    viewRouter.currentPage = .garden
                                                }
                                            }
                                        } else {
                                            if Auth.auth().currentUser?.email == nil && UserDefaults.standard.integer(forKey: "numMeds") >= 3 {
                                                fromPage = "garden"
                                                viewRouter.currentPage = .authentication
                                            } else {
                                                if updatedStreak && model.shouldStreakUpdate {
                                                    showStreak.toggle()
                                                    updatedStreak = false
                                                } else {
                                                    viewRouter.currentPage = .garden
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                        .zIndex(100)
                        .frame(width: g.size.width * 0.6, height: g.size.height/16)
                        .rightShadow()
                    }.frame(width: g.size.width, height: g.size.height/10)
                    .background(!K.isSmall() ? .clear : Clr.darkWhite)
                    .padding()
                    .position(x: g.size.width/2, y: g.size.height - g.size.height/(K.hasNotch() ? ios14 ? 7 : 9 : 4))
                    if showUnlockedModal {
                        Color.black
                            .opacity(0.55)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
                    
//                    OnboardingModal(shown: $showUnlockedModal, isUnlocked: true)
//                        .offset(y: showUnlockedModal ? 0 : g.size.height)
//                        .animation(.default, value: showUnlockedModal)
                }
            }
            .fullScreenCover(isPresented: $showStreak, content: {
                    StreakScene()
                        .environmentObject(bonusModel)
                        .environmentObject(viewRouter)
                        .background(Clr.darkWhite)
            })
            
        }.transition(.move(edge: .trailing))
            .fullScreenCover(isPresented: $showStreak, content: {
                    StreakScene()
                        .environmentObject(bonusModel)
                        .background(Clr.darkWhite)
            })
            .onDisappear {
                model.playImage = Img.seed
                model.lastSeconds = false
                if let oneId = UserDefaults.standard.value(forKey: "oneDayNotif") as? String {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oneId])
                    NotificationHelper.addOneDay()
                }
                if let threeId = UserDefaults.standard.value(forKey: "threeDayNotif") as? String {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [threeId])
                    NotificationHelper.addThreeDay()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.runCounter))
        { _ in }
            .onAppear {
                if UserDefaults.standard.bool(forKey: "isPlayMusic") {
                    if let player = player {
                        player.play()
                    }
                }
                
                DispatchQueue.main.async {
                    if #available(iOS 15.0, *) {
                        ios14 = false
                    }
                }
              
                if !UserDefaults.standard.bool(forKey: "tappedRate") {
                    if UserDefaults.standard.integer(forKey: "launchNumber") == 2 || UserDefaults.standard.integer(forKey: "launchNumber") == 6 {
                        if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
                        }
                    }
                }
                
                var session = [String: String]()
                session[K.defaults.plantSelected] = userModel.selectedPlant?.title
                session[K.defaults.meditationId] = String(model.selectedMeditation?.id ?? 0)
                session[K.defaults.duration] = model.selectedMeditation?.duration == -1 ? String(model.secondsRemaining) : String(model.selectedMeditation?.duration ?? 0)
                let dur = model.selectedMeditation?.duration ?? 0
                if !((model.forwardCounter > 2 && dur <= 120) || (model.forwardCounter > 6) || (model.selectedMeditation?.id == 22 && model.forwardCounter >= 1)) {
                    userModel.finishedMeditation(id: String(model.selectedMeditation?.id ?? 0))
                }

                reward = model.getReward()
                if userModel.isPotion || userModel.isChest {
                    reward = reward * 3
                }
                
                userModel.coins += reward
                gardenModel.save(key: "sessions", saveValue: session, coins: userModel.coins) {
                    if model.shouldStreakUpdate {
                        bonusModel.updateStreak()
                    }
                    if !userModel.ownedPlants.contains(where: { plt in  plt.title == "Cherry Blossoms"}) && UserDefaults.standard.bool(forKey: "unlockedCherry") {
                        userModel.willBuyPlant = Plant.badgePlants.first(where: { p in
                            p.title == "Cherry Blossoms"
                        })
                        userModel.buyPlant(unlockedStrawberry: true)

                    }
                }
                //num times med
                var num = UserDefaults.standard.integer(forKey: "numMeds")
                num += 1
                UserDefaults.standard.setValue(num, forKey: "numMeds")
                
                let identify = AMPIdentify()
                    .set("meditation_sessions", value: NSNumber(value: num))
                Amplitude.instance().identify(identify ?? AMPIdentify())
                

                favorited = model.isFavorited
                // onboarding
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                    Analytics.shared.log(event: .onboarding_finished_meditation)
                    UserDefaults.standard.setValue("meditate", forKey: K.defaults.onboarding)
                    isOnboarding = true
                } else {
                    OneSignal.sendTag("firstMeditation", value: "true")
                }
                
         
             

                //Log Analytics
                #if !targetEnvironment(simulator)
                 Firebase.Analytics.logEvent("finished_\(model.selectedMeditation?.returnEventName() ?? "")", parameters: [:])
                 AppsFlyerLib.shared().logEvent("finished_\(model.selectedMeditation?.returnEventName() ?? "")", withValues: [AFEventParamContent: "true"])
                Amplitude.instance().logEvent("finished_meditation", withEventProperties: ["meditation": model.selectedMeditation?.returnEventName() ?? ""])
                #endif
                 print("logging, \("finished_\(model.selectedMeditation?.returnEventName() ?? "")")")
            }
            .onAppearAnalytics(event: .screen_load_finished)

    }


}

struct Finished_Previews: PreviewProvider {
    static var previews: some View {
        Finished(bonusModel: BonusViewModel(userModel: UserViewModel(), gardenModel: GardenViewModel()), model: MeditationViewModel(), userModel: UserViewModel(), gardenModel: GardenViewModel())
    }
}

extension Int {

    var ordinal: String {
        var suffix: String
        let ones: Int = self % 10
        let tens: Int = (self/10) % 10
        if tens == 1 {
            suffix = "th"
        } else if ones == 1 {
            suffix = "st"
        } else if ones == 2 {
            suffix = "nd"
        } else if ones == 3 {
            suffix = "rd"
        } else {
            suffix = "th"
        }
        return "\(self)\(suffix)"
    }

}
