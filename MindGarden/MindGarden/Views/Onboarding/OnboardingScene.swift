//
//  OnboardingScene.swift
//  MindGarden
//
//  Created by Dante Kim on 6/6/21.
//

import SwiftUI
import Paywall
import OneSignal
import Purchases
import Amplitude
import AppTrackingTransparency

var tappedSignIn = false
struct OnboardingScene: View {
    @State private var index = 0
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var authModel: AuthenticationViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var userModel: UserViewModel

    @State private var showAuth = false
    init() {
        if #available(iOS 14.0, *) {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Clr.gardenGreen)
        } else {
            // Fallback on earlier versions
        }
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    let title = "Not magic."
    let subtitles = "Meditate. Journal. Grow. Thrive with MindGarden & have fun."
    var body: some View {
        NavigationView {
            GeometryReader { g in
                let width = g.size.height
                ZStack(alignment: .center) {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack {
                        HStack(alignment:.top) {
                            Img.onboardingCamelia
                                .offset(x: -60, y: -60)
                            Spacer()
                            Img.onBoardingCalender
                                .neoShadow()
                                .offset(x: 25, y: -25)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        }
                        Spacer()
                        HStack(alignment:.bottom) {
                            Img.onBoardingFlower
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                            Spacer()
                            Img.onboardingApple
                                .offset(x: 40, y: 100)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .ignoresSafeArea()
                    VStack(alignment: .center,spacing:0) {
                        Spacer()
                        Spacer()
                        VStack(spacing:0) {
                            VStack(alignment:.leading) {
                                Text(title)
                                    .font(Font.mada(.bold, size: 32))
                                    .padding(.horizontal)
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.leading)
                                Group {
                                    Text("Just")
                                        .foregroundColor(Clr.black2) +
                                    Text(" Gamification")
                                        .foregroundColor(Clr.brightGreen)
                                }
                                .font(Font.mada(.bold, size: 32))
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom,10)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                Text(subtitles)
                                    .font(Font.mada(.semiBold, size: 20))
                                    .foregroundColor(Clr.black1)
                                    .lineSpacing(10)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                            }.padding()
                            .offset(y: -25)
                            Img.coloredPots
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.4)
                                .padding()
                                .neoShadow()
                        }
                        .padding(.horizontal)
                        
                        Button {
                            MGAudio.sharedInstance.playBubbleSound()
                            Analytics.shared.log(event: .onboarding_tapped_continue)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation(.easeOut(duration: 0.4)) {
                                DispatchQueue.main.async {
                                    viewRouter.progressValue = 0.2
                                    viewRouter.currentPage = .experience
                                }
                            }
                            if let onesignalId = OneSignal.getDeviceState().userId {
                                   Purchases.shared.setOnesignalID(onesignalId)
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.yellow)
                                .overlay(
                                    Text("Start Growing 👉")
                                        .foregroundColor(Clr.darkgreen)
                                        .font(Font.mada(.semiBold, size: 20))
                                )
                        }.frame(width:UIScreen.screenWidth*0.8, height: 50)
                            .padding()
                        .buttonStyle(BonusPress())
                        Button {
                            MGAudio.sharedInstance.playBubbleSound()
                            Analytics.shared.log(event: .onboarding_tapped_sign_in)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            tappedSignIn = true
                            withAnimation {
                                fromPage = "onboarding"
                                tappedSignOut = true
                                authModel.isSignUp = false
                                viewRouter.currentPage = .authentication
                            }
                        } label: {
                            Text("Already have an account")
                                .underline()
                                .font(Font.mada(.semiBold, size: 18))
                                .foregroundColor(.gray)
                        }.frame(height: 30)
                            .padding([.horizontal,.bottom])
                            .offset(y: 25)
                        .buttonStyle(BonusPress())
                        Spacer()
                    }
                }
            }.navigationBarTitle("", displayMode: .inline)
        }.onAppearAnalytics(event: .screen_load_onboarding)
            .onAppear {
                ATTrackingManager.requestTrackingAuthorization { status in
                    DispatchQueue.main.async {
                        switch status {
                        case .authorized:
                            Analytics.shared.log(event: .onboarding_tapped_allowed_att)
                        case .denied:
                            Analytics.shared.log(event: .onboarding_tapped_denied_att)
                        default:
                            Analytics.shared.log(event: .onboarding_tapped_denied_att)

                        }
                    }
                }
                if let num = UserDefaults.standard.value(forKey: "abTest") as? Int {
                    let identify = AMPIdentify()
                        .set("abTest1.53", value: NSNumber(value: num))
                    Amplitude.instance().identify(identify ?? AMPIdentify())
                }
            }
            .sheet(isPresented: $showAuth) {
                if tappedSignOut {
                    
                } else {
                    Authentication(viewModel: authModel)
                        .environmentObject(medModel)
                        .environmentObject(userModel)
                        .environmentObject(gardenModel)
                }
            }
    }
    
}

struct OnboardingScene_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScene()
    }
}
