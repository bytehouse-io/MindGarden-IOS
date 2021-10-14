//
//  OnboardingModal.swift
//  MindGarden
//
//  Created by Dante Kim on 9/17/21.
//

import SwiftUI

struct OnboardingModal: View {
    @Binding var shown: Bool

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        VStack(spacing: 10) {
                            Text("1️⃣ This is Your Overview for a Single Day")
                                .font(Font.mada(.semiBold, size: 20))
                                .foregroundColor(Clr.black2)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.05)
                            Text("👍 That's it for the tutorial! Email team@mindgarden.io for any questions or suggestions")
                                .font(Font.mada(.semiBold, size: 20))
                                .foregroundColor(Clr.black2)
                                .lineLimit(3)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.05)
                                .padding(.vertical)
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    shown = false
                                    Analytics.shared.log(event: .onboarding_finished_single_okay)
                                    UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
                                }
                            } label: {
                                Capsule()
                                    .fill(Clr.brightGreen)
                                    .overlay(
                                        Text("I'm Done!")
                                            .font(Font.mada(.bold, size: 22))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    )
                                    .frame(width: g.size.width * 0.5, height: g.size.height * 0.08)
                                    .padding(.leading)
                            }.buttonStyle(NeumorphicPress())
                        }.frame(width: g.size.width * 0.65, height: g.size.height * 0.45, alignment: .center)
                    }.frame(width: g.size.width * 0.85, height: g.size.height * 0.50, alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(12)
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
