//
//  PlusMenu.swift
//  MindGarden
//
//  Created by Dante Kim on 6/28/21.
//

import SwiftUI

struct PlusMenu: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditateModel: MeditationViewModel
    @Binding var showPopUp: Bool
    @Binding var addMood: Bool
    @Binding var addGratitude: Bool
    var isOnboarding: Bool
    
    let width: CGFloat
    var body: some View {
        ZStack {
            VStack {
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if UserDefaults.standard.integer(forKey: "numMoods") >= 30 && !UserDefaults.standard.bool(forKey: "isPro") {
                        withAnimation {
                            Analytics.shared.log(event: .plus_tapped_mood_to_pricing)
                            fromPage = "plusMood"
                            viewRouter.currentPage = .pricing
                        }
                    } else {
                        Analytics.shared.log(event: .plus_tapped_mood)
                        withAnimation {
                            showPopUp = false
                            addMood = true
                        }
                    }
                } label: {
                    MenuChoice(title: "Mood Check", img: Image(systemName: "face.smiling"),  isOnboarding: false, disabled: isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "signedUp")
                        .frame(width: width/2.25, height: width/10)
                }.disabled(isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "signedUp")
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if UserDefaults.standard.integer(forKey: "numGrads") >= 30 && !UserDefaults.standard.bool(forKey: "isPro") {
                        Analytics.shared.log(event: .plus_tapped_gratitude_to_pricing)
                        withAnimation {
                            fromPage = "plusGratitude"
                            viewRouter.currentPage = .pricing
                        }
                    } else {
                        Analytics.shared.log(event: .plus_tapped_gratitude)
                        if isOnboarding {
                            Analytics.shared.log(event: .onboarding_finished_meditation)
                        }
                        withAnimation {
                            showPopUp = false
                            addGratitude = true
                        }
                    }
                } label: {
                    MenuChoice(title: "Gratitude", img: Image(systemName: "square.and.pencil"), isOnboarding: isOnboarding, disabled: isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "mood")
                        .frame(width: width/2.25, height: width/10)
                }.disabled(isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "mood")
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if UserDefaults.standard.integer(forKey: "numMeds") >= 30 && !UserDefaults.standard.bool(forKey: "isPro") {
                        withAnimation {
                            fromPage = "plusMeditation"
                            viewRouter.currentPage = .pricing
                        }
                    } else {
                        Analytics.shared.log(event: .plus_tapped_meditate)
                        withAnimation {
                            showPopUp = false
                        }

                        if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                            Analytics.shared.log(event: .onboarding_finished_gratitude)
                            meditateModel.selectedMeditation = Meditation.allMeditations.first(where: { med in
                                med.id == 22
                            })
                            viewRouter.currentPage = .play
                        } else {
                            meditateModel.selectedMeditation = meditateModel.featuredMeditation
                            if meditateModel.selectedMeditation?.type == .course {
                                viewRouter.currentPage = .middle
                            } else {
                                viewRouter.currentPage = .play
                            }
                        }
                    }
                } label: {
                    MenuChoice(title: "Meditate", img: Image(systemName: "play"),  isOnboarding: isOnboarding, disabled: isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude")
                        .frame(width: width/2.25, height: width/10)
                }.disabled(isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude")
            }
        }
        .frame(width: width/2, height: width/2.25)
        .transition(.scale)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Clr.black1.opacity(0.5), radius: 4, x: 0, y: -8)
        .zIndex(-10)
    }

    struct MenuChoice: View {
        let title: String
        let img: Image
        let isOnboarding: Bool
        let disabled: Bool

        var body: some View {
            ZStack {
                Capsule()
                    .fill(Clr.brightGreen)
                HStack {
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .padding(3)
                    Text(title)
                        .font(Font.mada(.medium, size: 20))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.white)
                }
                .padding(5)
            }
            .opacity(disabled ? 0.3 : 1)
            .neoShadow()
        }
    }
}
