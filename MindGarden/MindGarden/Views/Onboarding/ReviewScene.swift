//
//  ReviewScene.swift
//  MindGarden
//
//  Created by Dante Kim on 12/6/21.
//

import Amplitude
import OneSignal
//import Paywall
import SwiftUI

var tappedTurnOn = false

struct ReviewScene: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var experience: (Image, String) = (Img.moon, "")
    @State private var aim = (Img.redTulips3, "")
    @State private var aim2 = (Img.redTulips3, "")
    @State private var aim3 = (Img.redTulips3, "")
    @State private var notifications = ""
    @State private var showLoading = false
    @State private var showPaywall = false
    var displayedTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }

    var onReviewCompletion: (() -> Void)? = nil

    init(onReviewCompletion: (() -> Void)?) {
        self.onReviewCompletion = onReviewCompletion
    }

    // MARK: - Body
    
    var body: some View {
        ZStack {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(spacing: 5) {
                        HStack {
                            if !K.isSmall() && K.hasNotch() {
                                Img.topBranch
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.screenWidth * 0.6)
                                    .padding(.leading, -20)
                                    .offset(y: -10)
                            }
                            Spacer()
                        } //: HStack
                        .edgesIgnoringSafeArea(.all)
                        Spacer()
                        Text("So, to recap \(DefaultsManager.standard.value(forKey: .name).stringValue)")
                            .font(Font.fredoka(.bold, size: 30))
                            .foregroundColor(Clr.black2)
                            .padding()
                            .lineLimit(2)
                            .minimumScaleFactor(0.05)
                            .frame(width: width * 0.75)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .frame(width: width * 0.75, height: width * (arr.count == 1 ? 0.22 : arr.count == 2 ? 0.4 : arr.count == 3 ? 0.55 : 0.5))
                                .neoShadow()
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(zip(arr.indices, arr)), id: \.0) { idx, item in
                                    HStack {
                                        ReasonItem.getImage(str: item)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: width * 0.125, height: width * 0.125)
                                            .padding(10)
                                        VStack(alignment: .leading) {
                                            if idx == 0 {
                                                Text("Your aim is to")
                                                    .foregroundColor(.gray)
                                                    .font(Font.fredoka(.regular, size: 20))
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.05)
                                            }
                                            Text(item == "Managing Stress & Anxiety" ? " stress/anxiety" : item)
                                                .foregroundColor(Clr.black1)
                                                .font(Font.fredoka(.semiBold, size: 20))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                            
                                        } //: VStack
                                        .frame(width: width * 0.5, alignment: .leading)
                                    } //: HStack
                                } //: ForEach Loop
                            } //: VStack
                        } //: ZStack
                        
                        ReviewBase(
                            width: width,
                            title: "Your experience level",
                            image: {
                                LeadingImage(image: experience.0, width: width)
                            },
                            description: {
                                Text("\(experience.1)")
                                    .foregroundColor(Clr.black1)
                                    .font(Font.fredoka(.semiBold, size: 20))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                        ) //: ReviewBase for experience level
                        .padding(.top, 15)
                        
                        ReviewBase(
                            width: width,
                            title: "Your notifcations are",
                            image: {
                                Img.bell
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.125, height: width * 0.175)
                                    .padding()
                                    .padding(.trailing)
                            },
                            description: {
                                HStack {
                                    Text("\(notifications)")
                                        .foregroundColor(Clr.black1)
                                        .font(Font.fredoka(.semiBold, size: 20))
                                    if notifications == "Off" {
                                        Button {
                                            MGAudio.sharedInstance.playBubbleSound()
                                            withAnimation {
                                                tappedTurnOn = true
                                                viewRouter.currentPage = .notification
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
                                        } //: Button
                                    }
                                } //: HStack
                            }
                        )
                        
                        ReviewBase(
                            width: width,
                            title: "Your meditation goal is",
                            image: {
                                LeadingImage(image: Img.meditatingTurtle, width: width)
                            },
                            description: {
                                Text("\(UserDefaults.standard.string(forKey: "meditationGoal") ?? "")")
                                .foregroundColor(Clr.black1)
                                .font(Font.fredoka(.semiBold, size: 20))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                            }
                        ) //: ReviewBase
                        
                        Spacer()
                        Button(
                            action: {
                                showLoading = true
                                MGAudio.sharedInstance.playBubbleSound()
                                // Analytics.shared.log(event: .review_tapped_tutorial)
                                fromOnboarding = true
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                fromPage = "onboarding2"
                                DefaultsManager.standard.set(value: DefaultsManager.OnboardingScreens.signedUp.rawValue, forKey: .onboarding)
                                DefaultsManager.standard.set(value: true, forKey: .onboarded)
                                DefaultsManager.standard.set(value: true, forKey: .review)
                                let data: [String: Any] = [
                                    "name": DefaultsManager.standard.value(forKey: .name).stringValue
                                ]
                                 Analytics.shared.logActual(event: .onboarding_completed, with: data) // "Triggered when the user has completed the action at a certain step of the onboarding (click ""next"", enter name, enter information, etc).
                                withAnimation {
                                    viewRouter.progressValue = 1
                                    if onReviewCompletion != nil {
                                        onReviewCompletion?()
                                         Analytics.shared.log(event: .app_entered) // Triggers when the user passes the paywall. Must be sent only once, when user has passed the paywall.
                                    } else {
                                        // goto home screen now
                                        viewRouter.currentPage = .meditate
                                        if fromInfluencer != "" {
                                            // Analytics.shared.log(event: .user_from_influencer)
                                            fromPage = "home"
                                            viewRouter.currentPage = .pricing
                                        } else {
                                            fromPage = "home"
                                            viewRouter.currentPage = .pricing
                                        }
                                    }
                                }
                            },
                            label: {
                                HStack {
                                    Text("Let's Go! 🏃‍♂️")
                                        .foregroundColor(Clr.darkgreen)
                                        .font(Font.fredoka(.semiBold, size: 16))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                } //: HStack
                                .frame(width: g.size.width * 0.75, height: g.size.height / 16)
                                .background(Clr.yellow)
                                .cornerRadius(24)
                                .addBorder(.black, width: 1.5, cornerRadius: 24)
                            }
                        ) //: Button
//                        .triggerPaywall(
//                            forEvent: "review_tapped_tutorial",
//                            withParams: ["reason": 17],
//                            shouldPresent: $showPaywall,
//                            onPresent: { paywallInfo in
//                                print("paywall info is", paywallInfo)
//                                // Analytics.shared.log(event: .screen_load_superwall)
//                            },
//                            onDismiss: { result in
//                                switch result.state {
//                                case .closed:
//                                    print("User dismissed the paywall.")
//                                case let .purchased(productId: productId):
//                                    switch productId {
//                                    case "io.mindgarden.pro.monthly": // Analytics.shared.log(event: .monthly_started_from_superwall)
//                                        DefaultsManager.standard.set(value: true, forKey: "isPro")
//                                    case "io.mindgarden.pro.yearly":
//                                        // Analytics.shared.log(event: .yearly_started_from_superwall)
//                                        DefaultsManager.standard.set(value: true, forKey: "freeTrial")
//                                        DefaultsManager.standard.set(value: true, forKey: "isPro")
//                                        if UserDefaults.standard.bool(forKey: "isNotifOn") {
//                                            NotificationHelper.freeTrial()
//                                        }
//                                    default: break
//                                    }
//                                case .restored:
//                                    print("Restored purchases, then dismissed.")
//                                }
//                                showLoading = true
//                            },
//                            onFail: { error in
//                                print("did fail", error)
//                                viewRouter.currentPage = .pricing
//                            }
//                        )
//                        .padding(20)
//                        .buttonStyle(NeumorphicPress())

//                        Button {
//                            // Analytics.shared.log(event: .review_tapped_explore)
//                            UIImpactFeedbackGenerator(style: .light).impactOccurred()

//                            if let segments = UserDefaults.standard.array(forKey: "storySegments") as? [String] {
//                                var newArr = segments
//                                newArr.append("non-tutorial")
//                                storySegments = Set(newArr)
//                                StorylyManager.refresh()
//                            }

//                            DefaultsManager.standard.set(value: true, forKey: "review")
//                            DefaultsManager.standard.set(value: "meditate", forKey: K.defaults.onboarding)
//                            withAnimation {
//                                viewRouter.progressValue = 1
//                                if fromInfluencer != "" {
//                                    // Analytics.shared.log(event: .user_from_influencer)
//                                    viewRouter.currentPage = .pricing
//                                } else {
//                                    Paywall.present { info in
//                                        // Analytics.shared.log(event: .screen_load_superwall)
//                                    } onDismiss: {  didPurchase, productId, paywallInfo in
//                                        switch productId {
//                                        case "io.mindgarden.pro.monthly": // Analytics.shared.log(event: .monthly_started_from_superwall)
//                                            DefaultsManager.standard.set(value: true, forKey: "isPro")
//                                        case "io.mindgarden.pro.yearly":
//                                            // Analytics.shared.log(event: .yearly_started_from_superwall)
//                                            DefaultsManager.standard.set(value: true, forKey: "freeTrial")
//                                            DefaultsManager.standard.set(value: true, forKey: "isPro")
//                                            if UserDefaults.standard.bool(forKey: "isNotifOn") {
//                                                NotificationHelper.freeTrial()
//                                            }
//                                        default: break
//                                        }
//                                        showLoading = true
//                                    } onFail: { error in
//                                        viewRouter.currentPage = .pricing
//                                    }
//                                }
//                            }
//                        } label: {
//                                Text("Explore myself")
//                                    .underline()
//                                    .font(Font.fredoka(.regular, size: 16))
//                                    .foregroundColor(.gray)
//                                    .padding(.top, K.isSmall() ? 10 : 20)
//                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showLoading) {
            LoadingIllusion()
                .frame(height: UIScreen.screenHeight + 50)
        }
        .transition(.move(edge: .trailing))
        // .onAppearAnalytics(event: .screen_load_review)
        .onAppear {
            if UserDefaults.standard.string(forKey: "experience") != nil {
                switch UserDefaults.standard.string(forKey: "experience") {
                case Experience.often.title:
                    experience = (Img.redTulips3, "is high")
                case Experience.nowAndThen.title:
                    experience = (Img.redTulips2, "is low")
                case Experience.never.title:
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
}

#if DEBUG
struct ReviewScene_Previews: PreviewProvider {
    static var previews: some View {
        ReviewScene(onReviewCompletion: nil)
    }
}
#endif

struct LeadingImage: View {
    var image: Image
    var width: CGFloat
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width * 0.125, height: width * 0.125, alignment: .leading)
            .padding()
    }
}

struct ReviewBase<ImageContent: View, DesContent: View>: View {
    
    // MARK: - Properties
    
    var width: CGFloat
    var title: String
    
    @ViewBuilder var image: ImageContent
    @ViewBuilder var description: DesContent
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Clr.darkWhite)
                .cornerRadius(14)
                .frame(width: width * 0.75, height: width * 0.22)
                .neoShadow()
            HStack(spacing: -10) {
                image
                VStack(alignment: .leading) {
                    // Title
                    Text(title)
                        .foregroundColor(.gray)
                        .font(Font.fredoka(.regular, size: 16))
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                    description
                } //: VStack
                .frame(width: width * 0.5, alignment: .leading)
            } //: HStack
        } //: ZStack
    }
}
