//
//  CongratulationsOnCompletion.swift
//  MindGarden
//
//  Created by apple on 20/04/23.
//

import SwiftUI

struct CongratulationsOnCompletion: View {
    
    // MARK: - Properties
    
    var model: MeditationViewModel
    var userModel: UserViewModel
    var gardenModel: GardenViewModel
    var bonusModel: BonusViewModel
    var onDismiss: Page
    
    @State private var showStreak = false
    @State private var isOnboarding = false
    @State private var hideConfetti = false
    
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var viewRouter: ViewRouter

    // MARK: - Body
    
    var body: some View {
        GeometryReader { g in
            let width = g.size.width
            let height = g.size.height
            
            ZStack {
                LottieView(fileName: "confetti")
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    .opacity(hideConfetti ? 0 : 1)
                
                VStack {
                    Spacer()
                        .frame(height: 80)
                    // GLOBE PLANT IMAGE
                    withAnimation(.easeInOut(duration: 2.0)) {
                        userModel.selectedPlant?.badge
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: g.size.height / 2.75)
                    }
                    
                    Spacer()
                    VStack(alignment: .leading) {
                        
                        // TITLE
                        Text("Congratulations!")
                            .font(Font.fredoka(.bold, size: 28))
                            .foregroundColor(Clr.darkgreen)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)
                        
                        Text("You just grew a White Daisy")
                            .font(Font.fredoka(.bold, size: 22))
                            .lineLimit(2)
                            .minimumScaleFactor(0.05)
                            .foregroundColor(Clr.black1)
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                        
                        Text("Your flower has been added to\nyour garden")
                            .font(Font.fredoka(.medium, size: 20))
                            .lineLimit(2)
                            .minimumScaleFactor(0.05)
                            .foregroundColor(Clr.lightTextGray)
                            .padding(.horizontal)
                        
//                        if !isOnboarding {
//                            HStack {
//                                Button {} label: {
//                                    HStack {
//                                        Img.veryGood
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 50)
//                                            .padding(.vertical, 5)
//                                        Text("Log Mood")
//                                            .foregroundColor(.black)
//                                            .font(Font.fredoka(.semiBold, size: 16))
//                                            .padding(.trailing)
//                                            .lineLimit(1)
//                                            .minimumScaleFactor(0.05)
//                                    } //: HStack
//                                    .frame(width: width * 0.4, height: 45)
//                                    .background(Clr.yellow)
//                                    .cornerRadius(24)
//                                    .addBorder(.black, width: 1.5, cornerRadius: 24)
//                                    .onTapGesture {
//                                        moodFromFinished = true
//                                        withAnimation(.easeOut) {
//                                            hideConfetti = true
//                                            Analytics.shared.log(event: .home_tapped_categories)
//                                            let impact = UIImpactFeedbackGenerator(style: .light)
//                                            impact.impactOccurred()
//                                            NotificationCenter.default.post(name: Notification.Name("mood"), object: nil)
//                                        }
//                                    }
//                                } //: Button
//                                .buttonStyle(BonusPress())
//                                Button {} label: {
//                                    HStack {
//                                        Img.streakPencil
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .padding([.leading])
//                                            .padding(.vertical, 5)
//                                        Text("Journal")
//                                            .foregroundColor(.black)
//                                            .font(Font.fredoka(.semiBold, size: 16))
//                                            .padding(.trailing)
//                                            .lineLimit(1)
//                                            .minimumScaleFactor(0.05)
//                                    } //: HStack
//                                    .frame(width: width * 0.4, height: 45)
//                                    .background(Clr.yellow)
//                                    .cornerRadius(24)
//                                    .addBorder(.black, width: 1.5, cornerRadius: 24)
//                                    .onTapGesture {
//                                        withAnimation {
//                                            hideConfetti = true
//                                            Analytics.shared.log(event: .home_tapped_categories)
//                                            let impact = UIImpactFeedbackGenerator(style: .light)
//                                            impact.impactOccurred()
//                                            viewRouter.previousPage = .meditationCompleted
//                                            viewRouter.currentPage = .journal
//                                        }
//                                    }
//                                } //: Button
//                                .buttonStyle(BonusPress())
//                            } //: HStack
//                            .frame(width: width, height: 45)
//                            .padding(.top, 10)
//                            .zIndex(100)
//                            .offset(y: sizeCategory > .large ? -60 : K.isSmall() ? -15 : 0)
//                        }

                        Spacer()
                        
                        ShareAndContinueFooter(
                            model: model,
                            userModel: userModel,
                            gardenModel: gardenModel,
                            bonusModel: bonusModel,
                            onDismiss: onDismiss,
                            viewRouter: _viewRouter
                        ) //: ShareAndContinueFooter
                        Spacer()
                    } //: VStack
                } //: VStack
                .padding(.all, 24)
            } //: ZStack
        } //: GeometryReader
        .onAppear {
    
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                Analytics.shared.log(event: .onboarding_finished_meditation)
                UserDefaults.standard.setValue("garden", forKey: K.defaults.onboarding)
                isOnboarding = true
            }
            if model.shouldStreakUpdate {
                bonusModel.updateStreak()
            }

            if !userModel.ownedPlants.contains(where: { plt in plt.title == "Cherry Blossoms" }) && UserDefaults.standard.bool(forKey: "unlockedCherry") {
                userModel.willBuyPlant = Plant.badgePlants.first(where: { p in
                    p.title == "Cherry Blossoms"
                })
                userModel.buyPlant(unlockedStrawberry: true)
            }
            

        }
    }
}
//
//struct CongratulationsOnCompletion_Previews: PreviewProvider {
//    static var previews: some View {
//        CongratulationsOnCompletion()
//    }
//}
