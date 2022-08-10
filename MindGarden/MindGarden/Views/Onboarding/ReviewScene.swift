//
//  ReviewScene.swift
//  MindGarden
//
//  Created by Dante Kim on 12/6/21.
//

import SwiftUI
import Paywall
import Amplitude
import OneSignal

var tappedTurnOn = false
struct ReviewScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var experience: (Image, String) =  (Img.moon, "")
    @State private var aim = (Img.redTulips3, "gook")
    @State private var aim2 = (Img.redTulips3, "")
    @State private var aim3 = (Img.redTulips3, "")
    @State private var notifications = ""
    @State private var showLoading = false
    var displayedTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }
    @State private var showPaywall = false
    @State private var showNotification = false
    
    var body: some View {
        ZStack {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(spacing: 0) {
                        HStack {
                            Img.topBranch
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWidth * 0.6)
                                .padding(.leading, -20)
                                .offset(y: -10)
                            Spacer()
                        }.edgesIgnoringSafeArea(.all)
                        Spacer()
                        Text("So, to recap \(UserDefaults.standard.string( forKey: "name") ?? "")")
                            .font(Font.fredoka(.bold, size: 30))
                            .foregroundColor(Clr.black2)
                            .padding()
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                        ZStack {
                            
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .frame(width: width * 0.75, height: width * (arr.count == 1 ? 0.22 : arr.count == 2 ? 0.4 : arr.count == 3 ? 0.55 : 0.5))
                            
                                .neoShadow()
                            VStack(alignment: .leading, spacing: -15){
                                HStack {
                                    aim.0
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: width * 0.15, height: width * 0.15)
                                        .padding(10)
                                    VStack(alignment: .leading) {
                                        Text("Your aim is to")
                                            .foregroundColor(.gray)
                                            .font(Font.fredoka(.regular, size: 20))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.05)
                                        Text("\(aim.1)")
                                            .foregroundColor(Clr.black1)
                                            .font(Font.fredoka(.semiBold, size: 20))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.05)
                                    }.frame(width: width * 0.5, alignment: .leading)
                                }
                                if arr.count > 1 {
                                    HStack {
                                        aim2.0
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: width * (arr.count == 1 ? 0.2 : 0.15), height: width * (arr.count == 1 ? 0.2 : 0.15))
                                            .padding(10)
                                        Text("\(aim2.1)")
                                            .foregroundColor(Clr.black1)
                                            .font(Font.fredoka(.semiBold, size: 20))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.05)
                                    }
                                }
                                if arr.count > 2 {
                                    HStack {
                                        aim3.0
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: width * (arr.count == 1 ? 0.2 : 0.15), height: width * (arr.count == 1 ? 0.2 : 0.15))
                                            .padding(10)
                                        Text("\(aim3.1)")
                                            .foregroundColor(Clr.black1)
                                            .font(Font.fredoka(.semiBold, size: 20))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.05)
                                    }
                                }
                            }
                        }
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .frame(width: width * 0.75, height: width * 0.22)
                                .neoShadow()
                            HStack(spacing: -10) {
                                experience.0
                                    .resizable() 
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.175, height: width * 0.175)
                                    .padding()
                                VStack(alignment: .leading) {
                                    Text("Your experience level")
                                        .foregroundColor(.gray)
                                        .font(Font.fredoka(.regular, size: 20))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                    Text("\(experience.1)")
                                        .foregroundColor(Clr.black1)
                                        .font(Font.fredoka(.semiBold, size: 22))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                }.frame(width: width * 0.5, alignment: .leading)
                            }
                        }.padding(.top, 15)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .frame(width: width * 0.75, height: width * 0.22)
                                .neoShadow()
                            HStack(spacing: -10){
                                Img.bell
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.15, height: width * 0.2)
                                    .padding()
                                    .padding(.trailing)
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Your notifcations are")
                                        .foregroundColor(.gray)
                                        .font(Font.fredoka(.regular, size: 20))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                    HStack {
                                        Text("\(notifications)")
                                            .foregroundColor(Clr.black1)
                                            .font(Font.fredoka(.semiBold, size: 22))
                                        if notifications == "Off" {
                                            Button {
                                                MGAudio.sharedInstance.playBubbleSound()
                                                withAnimation {
                                                    showNotification = true
                                                }
                                            } label: {
                                                Capsule()
                                                    .fill(Clr.yellow)
                                                    .frame(width: width * 0.2, height: height * 0.03)
                                                    .overlay(
                                                        Text("Turn On")
                                                        
                                                            .foregroundColor(.black)
                                                            .font(.caption)
                                                            .lineLimit(1)
                                                            .minimumScaleFactor(0.05)
                                                    )
                                                    .neoShadow()
                                            }
                                        }
                                    }
                                }.frame(width: width * 0.5, alignment: .leading)
                            }
                        }
                        Spacer()
                        Button {
                            MGAudio.sharedInstance.playBubbleSound()
                            Analytics.shared.log(event: .review_tapped_tutorial)
                            fromOnboarding = true
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            fromPage = "onboarding2"
                            UserDefaults.standard.setValue("signedUp", forKey: K.defaults.onboarding)
                            UserDefaults.standard.setValue(true, forKey: "onboarded")
                            withAnimation {
                                viewRouter.progressValue = 1
                                if fromInfluencer != "" {
                                    Analytics.shared.log(event: .user_from_influencer)
                                    viewRouter.currentPage = .pricing
                                } else {
                                    showLoading = true
//
//                                    Paywall.present { info in
//                                        Analytics.shared.log(event: .screen_load_superwall)
//                                    } onDismiss: {  didPurchase, productId, paywallInfo in
//                                        switch productId {
//                                        case "io.mindgarden.pro.monthly": Analytics.shared.log(event: .monthly_started_from_superwall)
//                                            UserDefaults.standard.setValue(true, forKey: "isPro")
//                                        case "io.mindgarden.pro.yearly":
//                                            Analytics.shared.log(event: .yearly_started_from_superwall)
//                                            UserDefaults.standard.setValue(true, forKey: "freeTrial")
//                                            UserDefaults.standard.setValue(true, forKey: "isPro")
//                                            if UserDefaults.standard.bool(forKey: "isNotifOn") {
//                                                NotificationHelper.freeTrial()
//                                            }
//                                        default: break
//                                        }
//                                        viewRouter.currentPage = .meditate
//                                    } onFail: { error in
//                                        viewRouter.currentPage = .pricing
//                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text("Finish  👉🏻")
                                    .foregroundColor(Clr.darkgreen)
                                    .font(Font.fredoka(.semiBold, size: 18))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }.frame(width: g.size.width * 0.75, height: g.size.height/16)
                                .background(Clr.yellow)
                                .cornerRadius(24)
                                .addBorder(.black, width: 1.5,  cornerRadius: 24)
                        }.padding()
                            .buttonStyle(NeumorphicPress())
                     
//                        Button {
//
//                        } label: {
//                                Text("Skip (Not Recommended)")
//                                    .underline()
//                                    .font(Font.fredoka(.regular, size: 18))
//                                    .foregroundColor(.gray)
//                                    .padding(.top, 35)
//                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showLoading)  {
            LoadingIllusion()
                .frame(height: UIScreen.screenHeight + 50)
        }
        .alert(isPresented: $showNotification) {
                Alert(
                    title: Text("You'll need to turn on Push"),
                    message: Text("In order to fully experience MindGarden you'll need to turn on notifications"),
                    primaryButton: Alert.Button.default(Text("Not now"), action: {
                        Analytics.shared.log(event: .review_notification_off)
                    }),
                    secondaryButton: .default(Text("Ok"), action: {
                        Analytics.shared.log(event: .experience_tapped_okay_push)
                        OneSignal.promptForPushNotifications(userResponse: { accepted in
                            if accepted {
                                notifications = "On"
                                Analytics.shared.log(event: .review_notification_on)
                                NotificationHelper.addOneDay()
                                NotificationHelper.addThreeDay()
                                NotificationHelper.addOnboarding()
                            } else {
                                notifications = "Off"
                                Analytics.shared.log(event: .review_notification_off)
                                promptNotification()
                            }
                        })
                    })
                )
        }
        .transition(.move(edge: .trailing))
        .onAppearAnalytics(event: .screen_load_review)
            .onAppear {
                for (idx,str) in arr.enumerated() {
                    switch str {
                        case "Sleep better":
                            if idx == 0 { aim = (Img.moon, "Sleep better") }
                            else if idx == 1 { aim2 = (Img.moon, "Sleep better") }
                            else if idx == 2 { aim3 = (Img.moon, "Sleep better") }
                        case "Get more focused":
                            if idx == 0 {  aim = (Img.target, "Increase focus") }
                            else if idx == 1 { aim2 = (Img.target, "Increase focus") }
                            else if idx == 2 { aim3 = (Img.target, "Increase focus") }
                        case "Managing Stress & Anxiety":
                            if idx == 0 {  aim = (Img.heart, "Control anxiety") }
                            else if idx == 1 { aim2 = (Img.heart, "Control anxiety") }
                            else if idx == 2 { aim3 = (Img.heart, "Control anxiety") }
                        case "Just trying it out":
                            if idx == 0 {  aim = (Img.magnifyingGlass, "Just trying it out") }
                            else if idx == 1 { aim2 = (Img.magnifyingGlass, "Just trying it out") }
                            else if idx == 2 { aim3 = (Img.magnifyingGlass, "Just trying it out") }
                        default: break
                    }
                }

                if UserDefaults.standard.string(forKey: "experience") != nil {
                switch UserDefaults.standard.string(forKey: "experience") {
                    case "Meditate often":
                        experience = (Img.redTulips3, "is high")
                    case "Have tried to meditate":
                        experience = (Img.redTulips2, "is low")
                    case "Have never meditated":
                        experience = (Img.redTulips1, "is none")
                    default: break
                }
                }
                if UserDefaults.standard.value(forKey: K.defaults.meditationReminder) != nil {
                    notifications = "On"
                } else {
                    notifications = "Off"
                }
            }
    }
    private func promptNotification() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                Analytics.shared.log(event: .review_notification_on)
                let identify = AMPIdentify()
                    .set("reminder_set", value: NSNumber(1))
                Amplitude.instance().identify(identify ?? AMPIdentify())
                
                UserDefaults.standard.setValue(true, forKey: "isNotifOn")
//                UserDefaults.standard.setValue(dateTime, forKey: K.defaults.meditationReminder)
                if UserDefaults.standard.value(forKey: "oneDayNotif") == nil {
                    NotificationHelper.addOneDay()
                }
                
                if UserDefaults.standard.value(forKey: "threeDayNotif") == nil {
                    NotificationHelper.addThreeDay()
                }
                if UserDefaults.standard.value(forKey: "onboardingNotif") == nil {
                    NotificationHelper.addOnboarding()
                }

//                if fromSettings && UserDefaults.standard.bool(forKey: "freeTrial")  {
//                    NotificationHelper.freeTrial()
//                }
                
                UserDefaults.standard.setValue(true, forKey: "notifOn")
            case .denied:
                Analytics.shared.log(event: .review_notification_off)
                    Analytics.shared.log(event: .notification_go_to_settings)
                    DispatchQueue.main.async {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                            UIApplication.shared.open(appSettings)
                        }
                    }
            case .notDetermined:
                Analytics.shared.log(event: .review_notification_off)
                    UserDefaults.standard.setValue(false, forKey: "isNotifOn")
                    Analytics.shared.log(event: .notification_go_to_settings)
                    DispatchQueue.main.async {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                            UIApplication.shared.open(appSettings)
                        }
                    }
            default:
                print("Unknow Status")
            }
        })
    }
}

struct ReviewScene_Previews: PreviewProvider {
    static var previews: some View {
        ReviewScene()
    }
}
