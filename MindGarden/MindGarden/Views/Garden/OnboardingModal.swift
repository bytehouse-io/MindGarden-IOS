//
//  OnboardingModal.swift
//  MindGarden
//
//  Created by Dante Kim on 9/17/21.
//

import SwiftUI

struct OnboardingModal: View {
    @Binding var shown: Bool
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    var isUnlocked: Bool = false

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        VStack(spacing: 10) {
                            if isUnlocked {
                                Text("🍓 Congrats, you just unlocked the strawberry plant!")
                                    .font(Font.fredoka(.semiBold, size: 26))
                                    .foregroundColor(Color.black)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.05)
                            } else {
                                Text("1️⃣ This is Your Overview for a Single Day")
                                    .font(Font.fredoka(.semiBold, size: 24))
                                    .foregroundColor(Clr.black2)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.05)
                                (Text("Watch the intro video for a secret present").font(Font.fredoka(.semiBold, size: 18)))
//                                    + Text("limited time").font(Font.fredoka(.bold, size: 18)))
//                                    .foregroundColor(Clr.black2)
//                                    .lineLimit(4)
//                                    .multilineTextAlignment(.center)
//                                    .minimumScaleFactor(0.05)
//                                    .padding(.top, 5)
                            }

//                            Img.strawberryPacket
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: g.size.height * 0.3)
//                                .padding()
                            HStack(spacing: 10) {
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        shown = false
                                        // Analytics.shared.log(event: .onboarding_finished_single_okay)
                                        DefaultsManager.standard.set(value: DefaultsManager.OnboardingScreens.done.rawValue, forKey: .onboarding)
                                    }
                                } label: {
                                    Capsule()
                                        .fill(Color.gray)
                                        .overlay(
                                            Text("Not now")
                                                .font(Font.fredoka(.bold, size: 18))
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                        )
                                        .frame(width: g.size.width * 0.3, height: g.size.height * 0.06)
                                }
                                .buttonStyle(NeumorphicPress())
                                
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        shown = false
                                        // Analytics.shared.log(event: .onboarding_single_go_to_home)
                                        viewRouter.currentPage = .meditate
                                    }
                                } label: {
                                    Capsule()
                                        .fill(Clr.brightGreen)
                                        .overlay(
                                            Text("Go to home")
                                                .font(Font.fredoka(.bold, size: 18))
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                        )
                                        .frame(width: g.size.width * 0.4, height: g.size.height * 0.06)
                                }
                                .buttonStyle(NeumorphicPress())
                            }
                        }
                        .frame(width: g.size.width * 0.65, height: g.size.height * (isUnlocked ? 0.55 : 0.75), alignment: .center)
                    }
                    .frame(width: g.size.width * 0.85, height: g.size.height * (isUnlocked ? 0.6 : 0.80), alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(12)
                    Spacer()
                }
                if isUnlocked {
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct OnboardingModal_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingModal(shown: .constant(true))
    }
}
