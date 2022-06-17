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

var tappedSignIn = false
struct OnboardingScene: View {
    @State private var index = 0
    @EnvironmentObject var viewRouter: ViewRouter
    
    init() {
        if #available(iOS 14.0, *) {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Clr.gardenGreen)
        } else {
            // Fallback on earlier versions
        }
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    let title = "Not magic."
    let subtitles = "Meditation is hard. But playing a gardening game is easy & fun."
    var body: some View {
        NavigationView {
            GeometryReader { g in
                let width = g.size.height
                ZStack(alignment: .center) {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
//                    ZStack {
//                        Img.sunflower3
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100)
//                            .rotationEffect(Angle(degrees: 45))
//                            .position(x: -10, y: -10)
//                        Img.strawberry3
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100)
//                            .rotationEffect(Angle(degrees: 90))
//                            .position(x: screenWidth/2 - 10, y: -65)
//                        Img.lavender3
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100)
//                            .rotationEffect(Angle(degrees: 20))
//                            .position(x: screenWidth, y: -50)
//                        Img.cherryBlossoms3
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 80)
//                            .rotationEffect(Angle(degrees: -20))
//                            .position(x: screenWidth + 15, y: height/5)
//                        Img.blueberry3
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100)
//                            .rotationEffect(Angle(degrees: -20))
//                            .position(x: 0, y: height/3)
//                        Img.rose3
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100)
//                            .rotationEffect(Angle(degrees: -20))
//                            .position(x: screenWidth + 20, y: height/2)
//                        Img.bonsai3
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 120)
//                            .rotationEffect(Angle(degrees: -20))
//                            .position(x: 15, y: height/1.3)
//                        Img.lily3
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 90)
//                            .rotationEffect(Angle(degrees: 20))
//                            .position(x: screenWidth - 20, y: height/1.3)
//                    }
                    VStack {
                        HStack(alignment:.top) {
                            Img.onBoardingSeedPacket
                            Spacer()
                            Img.onBoardingCalender
                                .neoShadow()
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        }
                        Spacer()
                        HStack(alignment:.bottom) {
                            Img.onBoardingFlower
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                            Spacer()
                            Img.onBoardingAppleSeed
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .ignoresSafeArea()
                    VStack(alignment: .center) {
                        Spacer()
                        Spacer()
                        VStack {
                            VStack(alignment:.leading) {
                                Text(title)
                                    .font(Font.mada(.bold, size: 38))
                                    .padding(.horizontal)
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.leading)
                                Group {
                                    Text("Just")
                                        .foregroundColor(Clr.black2) +
                                    Text(" Gamification")
                                        .foregroundColor(Clr.brightGreen)
                                }
                                .font(Font.mada(.bold, size: 38))
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom,10)
                                Text(subtitles)
                                    .font(Font.mada(.semiBold, size: 20))
                                    .foregroundColor(Clr.black1)
                                    .lineSpacing(10)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                            }.padding()
                            Img.coloredPots
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.4)
                                .padding()
                                .neoShadow()
                        }
                        .padding()
                        
                        Button {
                            Analytics.shared.log(event: .onboarding_tapped_continue)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation(.easeOut(duration: 0.4)) {
                                DispatchQueue.main.async {
                                    viewRouter.progressValue = 0.4
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
                                        .foregroundColor(.black)
                                        .font(Font.mada(.semiBold, size: 20))
                                )
                        }.frame(width:UIScreen.screenWidth*0.8, height: 50)
                            .padding()
                        .buttonStyle(BonusPress())
                        Button {
                            Analytics.shared.log(event: .onboarding_tapped_sign_in)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            tappedSignIn = true
                            withAnimation {
                                viewRouter.currentPage = .authentication
                            }
                        } label: {
                            Text("Already have an account")
                                .underline()
                                .font(Font.mada(.semiBold, size: 18))
                                .foregroundColor(.gray)
                        }.frame(height: 30)
                            .padding([.horizontal,.bottom])
                        .buttonStyle(BonusPress())
                        Spacer()
                    }
                }
            }.navigationBarTitle("", displayMode: .inline)
        }.onAppearAnalytics(event: .screen_load_onboarding)
    }
}

struct OnboardingScene_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScene()
    }
}
