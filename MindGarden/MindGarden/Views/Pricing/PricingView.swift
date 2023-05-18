//
//  PricingView.swift
//  MindGarden
//
//  Created by Dante Kim on 10/26/21.
//

import Amplitude
import AppsFlyerLib
import Firebase
import FirebaseFirestore
import MWMPublishingSDK
import OneSignal
//import Purchases
import SwiftUI
import WidgetKit

var fromPage = ""
var userWentPro = false
var fromInfluencer = ""

struct PricingView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @State private var selectedPrice = ""
//    @State private var packagesAvailableForPurchase = [Purchases.Package]()
    @State private var monthlyPrice = 0.0
    @State private var yearlyPrice = 0.0
    @State private var lifePrice = 0.0
    @State private var selectedBox = "Yearly"
    @State private var trialLength = 3
    @State private var ios14 = true
    @State private var showProfile: Bool = false
    @State private var showLoading: Bool = false
    @State private var showLoadingIllusion: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        LoadingView(isShowing: $showLoading) {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                
                ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView(showsIndicators: false) {
                        // HEADER
                        ZStack {
                            if fiftyOff {
                                Img.greenChest
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.35, height: height * 0.15)
                                    .padding()
                            } else {
                                Img.newSun
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.7, height: height * 0.2)
                                    .offset(x: -25)
                            }
                        } //: ZStack
                        .frame(width: g.size.width)
                        .padding(.bottom, -25)
                        .buttonStyle(NeoPress())
                        
                        if fiftyOff || fromInfluencer != "" || fromPage == "garden" || fromPage == "store" {
                            (
                                Text(fiftyOff ? "💎 Claim my 50% off for " : fromInfluencer != "" ? "👋 Hey \(DefaultsManager.standard.value(forKey: .name).stringValue)," : (fromPage == "garden" ? "📸 Add photos from your journal " : (fromPage == "store" ? "💸 Get 2x Coins " : "🍏 Unlock ")))
                                    .font(Font.fredoka(.bold, size: 24))
                                +
                                Text(fromInfluencer == "" ? "with MindGarden Pro" : "\(fromInfluencer)")
                                    .foregroundColor(Clr.brightGreen)
                                    .font(Font.fredoka(.bold, size: 24))
                                +
                                Text(fiftyOff ? "\n(limited time)" : fromInfluencer != "" ? " has unlocked a a gift for you!\n\nHow your free trial works:" : fromPage == "garden" ? "" : " & get 1% happier everyday")
                            )
                            .font(Font.fredoka(.semiBold, size: 24))
                            .foregroundColor(Clr.black2)
                            .multilineTextAlignment(.leading)
                            .frame(width: width * 0.78, alignment: .leading)
                            .padding(15)
                        } else {
                            switch DefaultsManager.standard.value(forKey: .reason1).stringValue {
                            case "Sleep better", "Get more focused", "Improve your focus", "Improve your mood", "Be more present":
                                (
                                    Text("📈 " + DefaultsManager.standard.value(forKey: .reason1).stringValue)
                                        .font(Font.fredoka(.bold, size: 24))
                                    +
                                    Text(" in just 7 days, for Free.")
                                        .foregroundColor(Clr.darkgreen)
                                )
                                .font(Font.fredoka(.semiBold, size: 24))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.leading)
                                .frame(width: width * 0.78, alignment: .leading)
                                .padding(15)
                            case "Managing Stress & Anxiety":
                                (
                                    Text("📉 Reduce your stress & anxiety")
                                    +
                                    Text(" in just 7 days, for Free.")
                                        .foregroundColor(Clr.darkgreen)
                                )
                                .font(Font.fredoka(.semiBold, size: 24))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.leading)
                                .frame(width: width * 0.78, alignment: .leading)
                                .padding(15)
                            default:
                                (
                                    Text("📈 Become more mindful in")
                                    +
                                    Text(" just 7 days for Free.")
                                        .foregroundColor(Clr.darkgreen)
                                )
                                .font(Font.fredoka(.semiBold, size: 24))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.leading)
                                .frame(width: width * 0.78, alignment: .leading)
                                .padding(15)
                            }
                        }

                        if fromPage == "garden" {
                            Img.photoCalendar
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(32)
                                .frame(width: width * 0.8)
                                .padding()
                                .neoShadow()
                        }
                        if selectedBox != "Monthly" {
                            VStack {
                                FreeTrialView(trialLength: $trialLength)
                                    .padding(.vertical, 25)
                            }
                        }
                        // YEARLY BUTTON
                        Button {
                            MGAudio.sharedInstance.playBubbleSound()
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            selectedBox = "Yearly"
                            unlockProMWM()
                        } label: {
                            ZStack {
                                PricingBoxView(title: "Yearly", price: yearlyPrice, selected: $selectedBox, trialLength: $trialLength)
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Most Popular")
                                            .foregroundColor(Color.black.opacity(0.8))
                                            .font(Font.fredoka(.bold, size: 12))
                                            .multilineTextAlignment(.center)
                                            .minimumScaleFactor(0.05)
                                            .lineLimit(1)
                                            .padding(.horizontal, 1)
                                    )
                                    .frame(width: 90, height: 25, alignment: .leading)
                                    .position(x: width * 0.65)
                            } //: ZStack
                        } //: Button
                        .buttonStyle(BonusPress())
                        .frame(width: width * 0.8, height: height * 0.08)
                        .padding(5)
                        // MONTHLY BUTTON
                        Button {
                            withAnimation {
                                MGAudio.sharedInstance.playBubbleSound()
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                selectedBox = "Monthly"
                                unlockProMWM()
                            }
                        } label: {
                            PricingBoxView(title: "Monthly", price: monthlyPrice, selected: $selectedBox, trialLength: $trialLength)
                        } //: Button
                        .buttonStyle(NeumorphicPress())
                        .frame(width: width * 0.8, height: height * 0.08)
                        .padding(5)
                        .padding(.bottom, 32)
                        
                        RegularVsProView(width: width, height: height)
                            .frame(width: width * 0.8, height: height * 0.6)
                            .padding(.vertical)
                        
                        if !ios14 {
                            Text("Don't just take it from us\n⭐️⭐️⭐️⭐️⭐️")
                                .font(Font.fredoka(.bold, size: 22))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.center)
                                .padding(.top)
                            SnapCarousel()
                                .padding(.bottom)
                        }
                        
                        FrequentlyAskedQuestionView(width: width)
                            .padding(.bottom, 25)
                    } //: ScrollView
                    
                    Spacer()
                    
                    // FOOTER VIEW
                    VStack {
                        // ACTION BUTTON
                        Button {
                            MGAudio.sharedInstance.playBubbleSound()
                            unlockProMWM()
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        } label: {
                            HStack {
                                Text(selectedBox == "Yearly" ? fiftyOff ? "👨‍🌾 Unlock MindGarden Pro" : "👨‍🌾 Start your free trial" : "👨‍🌾 Unlock MindGarden Pro")
                                    .foregroundColor(Clr.darkgreen)
                                    .font(Font.fredoka(.bold, size: 18))
                            } //: HStack
                            .frame(width: g.size.width * 0.825, height: 50)
                            .background(Clr.yellow)
                            .cornerRadius(25)
                        } //: Button
                        .buttonStyle(NeumorphicPress())
                        // TERMS AND PRIVACY
                        TermsAndPrivacyView()
                    } //: VStack
                    .padding(10)
                    .padding(.bottom, K.isPad() ? 50 : !K.hasNotch() ? 45 : 0)
//                            .offset(y: K.hasNotch() ? -30 : 0)
                    Spacer()
                } //: VStack
                .padding(.top, K.hasNotch() ? 30 : 10)
                // CROSS BUTTON FOR DISMISSING
                Button {
                    crossButtonAction()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Clr.darkWhite)
                            .frame(width: 40)
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                            .frame(width: 20)
                    }.frame(width: 40)
                } //: Button
                .position(x: g.size.width - 50, y: 75)
                .buttonStyle(NeoPress())
                } //: ZStack
            } //: GeometryReader
        } //: LoadingView
        .fullScreenCover(isPresented: $showLoadingIllusion) {
            LoadingIllusion()
                .frame(height: UIScreen.screenHeight + 50)
        }
        .onAppear {
            let isUserPremium = MWM.inAppManager().isAnyPremiumFeatureUnlocked()
            print(isUserPremium, "testing")
            if #available(iOS 15.0, *) {
                ios14 = false
            }
            if DefaultsManager.standard.value(forKey: .onboarding).onboardingValue == .signedUp {
                Analytics.shared.log(event: .screen_load_pricing_onboarding)
            }
            purchasesOffering()
        }
        .onAppearAnalytics(event: fiftyOff ? .screen_load_50pricing : fromInfluencer != "" ? .screen_load_14pricing : .screen_load_pricing)
    }
}

struct PricingView_Previews: PreviewProvider {
    static var previews: some View {
        PricingView()
    }
}

extension PricingView {
    
    // MARK: - Helper Functions
    
    private func crossButtonAction() {
        MGAudio.sharedInstance.playBubbleSound()
        if DefaultsManager.standard.value(forKey: .onboarding).onboardingValue == .signedUp {
            withAnimation {
                showLoadingIllusion.toggle()
            }
            return
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation {
            switch fromPage {
            case "home": viewRouter.currentPage = .meditate
            case "profile": viewRouter.currentPage = .meditate
            case "onboarding": viewRouter.currentPage = .middle
            case "store": viewRouter.currentPage = .shop
            case "onboarding2": viewRouter.currentPage = .meditate
            case "lockedMeditation": viewRouter.currentPage = .categories
            case "lockedHome": viewRouter.currentPage = .meditate
            case "middle": viewRouter.currentPage = .middle
            case "widget": viewRouter.currentPage = .meditate
            case "discover": viewRouter.currentPage = .learn
            case "journal": viewRouter.currentPage = .learn
            case "garden": viewRouter.currentPage = .garden
            default: viewRouter.currentPage = viewRouter.previousPage
            }
        }
    }
    
    private func userIsPro() {
//        viewRouter.currentPage = .meditate
        OneSignal.sendTag("userIsPro", value: "true")
        if !userModel.ownedPlants.contains(Plant.badgePlants.first(where: { plant in plant.title == "Bonsai Tree" }) ?? Plant.badgePlants[0]) {
            userModel.willBuyPlant = Plant.badgePlants.first(where: { plant in plant.title == "Bonsai Tree" })
            userModel.buyPlant(unlockedStrawberry: true)
            userModel.triggerAnimation = true
        }
        if !fiftyOff {
            DefaultsManager.standard.set(value: true, forKey: .freeTrial)
        }
        DefaultsManager.standard.set(value: true, forKey: .bonsai)
        DefaultsManager.standard.set(value: true, forKey: .isPro)
        UserDefaults(suiteName: K.widgetDefault)?.setValue(true, forKey: "isPro")
        WidgetCenter.shared.reloadAllTimelines()
        userWentPro = true
        if fromPage != "onboarding2" {
            if let _ = Auth.auth().currentUser?.email {
                if let email = Auth.auth().currentUser?.email {
                    Firestore.firestore().collection(K.userPreferences).document(email).updateData([
                        "isPro": true,
                    ]) { error in
                        if let e = error {
                            print("There was a issue saving data to firestore \(e) ")
                        } else {
                            print("Succesfully saved from pricing page")
                        }
                    }
                }
            }
        }
        crossButtonAction()
    }
    
    private func purchasesOffering() {
//        Purchases.shared.offerings { [self] offerings, _ in
//            if let offerings = offerings {
//                let offer = offerings.current
//                let packages = offer?.availablePackages
//                guard packages != nil else {
//                    return
//                }
//                for i in 0 ... packages!.count - 1 {
//                    let package = packages![i]
//                    self.packagesAvailableForPurchase.append(package)
//                    let product = package.product
//                    let price = product.price
//                    if let period = product.introductoryPrice?.subscriptionPeriod {
//                        if fiftyOff {
//                            trialLength = 0
//                        } else {
//                            if product.productIdentifier == "io.mindgarden.pro.yearly" {
//                                trialLength = period.numberOfUnits
//                            } else if product.productIdentifier == "io.mindgarden.pro.yearly14" && fromInfluencer != "" {
//                                trialLength = period.numberOfUnits
//                            }
//                        }
//                    }
//                    let name = product.productIdentifier
//
//                    if name == "io.mindgarden.pro.monthly" {
//                        monthlyPrice = round(100 * Double(truncating: price)) / 100
//                    } else if name == "io.mindgarden.pro.yearly" {
//                        yearlyPrice = round(100 * Double(truncating: price)) / 100
//                    } else if name == "io.mindgarden.pro.lifetime" {
//                        lifePrice = round(100 * Double(truncating: price)) / 100
//                    } else if name == "yearly_pro_14" && fiftyOff {
//                        yearlyPrice = round(100 * Double(truncating: price)) / 100
//                    } else if name == "io.mindgarden.pro.yearly14" && fromInfluencer != "" {
//                        yearlyPrice = round(100 * Double(truncating: price)) / 100
//                    }
//                }
//            }
//        }
    }
    
    private func unlockProMWM() {
        var price = 0.0
        var event2 = "_Started_From_All"
        var event3 = "cancelled_"
        
        var iap = ""
        
        switch selectedBox {
        case "Yearly":
            if fiftyOff {
                price = yearlyPrice
                event2 = "Yearly50" + event2
                event3 += "yearly50"
            } else if fromInfluencer != "" {
                price = yearlyPrice
                event2 = "Yearly14" + event2
                event3 += "yearly14"
            } else {
                price = yearlyPrice
                event2 = "Yearly" + event2
                event3 += "yearly"
            }
            iap = "appstore.io.bytehouse.mindgarden.subscription.yearly"
        case "Lifetime":
            price = lifePrice
            event2 = "Lifetime" + event2
            event3 += "lifetime"
        case "Monthly":
            price = monthlyPrice
            if fiftyOff {
                event2 = "Monthly50" + event2
                event3 += "monthly50"
            } else {
                event2 = "Monthly" + event2
                event3 += "monthly"
            }
            iap = "appstore.io.bytehouse.mindgarden.subscription.monthly"
        default: break
        }
        
        showLoading = true
        
        MWM.inAppManager().purchaseIAP(iap) { success, error in
            showLoading = false
            if success {
                // Start delivering the consumable product to your user from here
                onMainThread {
                    userIsPro()
                }
            } else {
                // Handle error
                Amplitude.instance().logEvent(event3)
            }
        }

    }
    
    private func unlockPro() {
//        var price = 0.0
//        var package: Purchases.Package?
//        if packagesAvailableForPurchase.indices.contains(0) {
//            package = packagesAvailableForPurchase[0]
//        }
//        var event2 = "_Started_From_All"
//        var event3 = "cancelled_"
//        switch selectedBox {
//        case "Yearly":
//            if fiftyOff {
//                package = packagesAvailableForPurchase.last { package -> Bool in
//                    package.product.productIdentifier == "yearly_pro_14"
//                }
//                price = yearlyPrice
//                event2 = "Yearly50" + event2
//                event3 += "yearly50"
//            } else if fromInfluencer != "" {
//                package = packagesAvailableForPurchase.last { package -> Bool in
//                    package.product.productIdentifier == "io.mindgarden.pro.yearly14"
//                }
//                price = yearlyPrice
//                event2 = "Yearly14" + event2
//                event3 += "yearly14"
//            } else {
//                package = packagesAvailableForPurchase.last { package -> Bool in
//                    package.product.productIdentifier == "io.mindgarden.pro.yearly"
//                }
//                price = yearlyPrice
//                event2 = "Yearly" + event2
//                event3 += "yearly"
//            }
//
//        case "Lifetime":
//            package = packagesAvailableForPurchase.last { package -> Bool in
//                package.product.productIdentifier == "io.mindgarden.pro.lifetime"
//            }
//            price = lifePrice
//            event2 = "Lifetime" + event2
//            event3 += "lifetime"
//        case "Monthly":
//            package = packagesAvailableForPurchase.last { package -> Bool in
//                package.product.productIdentifier == "io.mindgarden.pro.monthly"
//            }
//            price = monthlyPrice
//            if fiftyOff {
//                event2 = "Monthly50" + event2
//                event3 += "monthly50"
//            } else {
//                event2 = "Monthly" + event2
//                event3 += "monthly"
//            }
//
//        default: break
//        }

//        showLoading = true
//        guard let package = package else { return }
//        Purchases.shared.purchasePackage(package) { [self] _, purchaserInfo, _, userCancelled in
//            showLoading = false
//            if purchaserInfo?.entitlements.all["isPro"]?.isActive == true {
//                let event = logEvent()
//                let revenue = AMPRevenue().setProductIdentifier(event)
//                revenue?.setPrice(NSNumber(value: price))
//                if !event.contains("yearly") {
//                    AppsFlyerLib.shared().logEvent(name: event, values:
//                        [
//                            AFEventParamRevenue: price,
//                            AFEventParamCurrency: "\(String(describing: Locale.current.currencyCode))",
//                        ])
//                    Amplitude.instance().logEvent(event2, withEventProperties: ["revenue": "\(price)"])
//                    Amplitude.instance().logEvent(event, withEventProperties: ["revenue": "\(price)"])
//                    let identify = AMPIdentify()
//                        .set("plan_type", value: NSString(utf8String: "monthly"))
//                    Amplitude.instance().identify(identify ?? AMPIdentify())
//                } else {
//                    AppsFlyerLib.shared().logEvent(name: event, values:
//                        [
//                            AFEventParamContent: "true",
//                        ])
//                    Amplitude.instance().logEvent(event2, withEventProperties: ["revenue": "\(price)"])
//                    Amplitude.instance().logEvent(event, withEventProperties: ["revenue": "\(price)"])
//
//                    let identify = AMPIdentify()
//                        .set("plan_type", value: NSString(utf8String: "yearly"))
//                    Amplitude.instance().identify(identify ?? AMPIdentify())
//                }
//                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "signedUp" {
//                    if let reason = UserDefaults.standard.string(forKey: "reason1") {
//                        Amplitude.instance().logEvent("onboarding_conversion_from", withEventProperties: ["reason": "\(reason)"])
//                    }
//                }
//                AppsFlyerLib.shared().logEvent(name: event2, values:
//                    [
//                        AFEventParamContent: "true",
//                    ])
//                userIsPro()
//            } else if userCancelled {
//                AppsFlyerLib.shared().logEvent(name: event3, values:
//                    [
//                        AFEventParamContent: "true",
//                    ])
//                Amplitude.instance().logEvent(event3)
//            }
//        }
    }
    
    private func logEvent(cancelled: Bool = false) -> String {
        var event = ""

        switch selectedBox {
        case "Yearly":
            event = "yearly_started_from_"
        case "Lifetime":
            event = "lifetime_started_from_"
        case "Monthly":
            event = "monthly_started_from_"
        default: break
        }

        if cancelled {
            event = "cancelled_" + event
        }
        if fromPage == "onboarding" {
            event = event + "onboarding"
        } else if fromPage == "onboarding2" {
            event = event + "onboarding2"
        } else if fromPage == "profile" {
            event = event + "profile"
        } else if fromPage == "home" {
            event = event + "from_Home"
        } else if fromPage == "plusMeditation" {
            event = event + "Plus_Meditations"
        } else if fromPage == "plusMood" {
            event = event + "Plus_Mood"
        } else if fromPage == "plus_Gratitude" {
            event = event + "PlusGratitude"
        } else if fromPage == "lockedMeditation" {
            event = event + "Locked_Meditation"
        } else if fromPage == "middle" {
            event = event + "Middle_Locked"
        } else if fromPage == "store" {
            event = event + "fromStore"
        } else if fromPage == "widget" {
            event = event + "fromWidget"
        } else if fromPage == "lockedHome" {
            event = event + "lockedHome"
        } else if fromPage == "journal" {
            event = event + "journal"
        } else if fromPage == "streak" {
            event = event + "streak"
        } else if fromPage == "garden" {
            event = event + "garden"
        }
        return event
    }
}
