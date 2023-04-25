//
//  MeditationCompleted.swift
//  MindGarden
//
//  Created by apple on 20/04/23.
//

import SwiftUI
import Photos
import StoreKit

struct MeditationCompleted: View {
    
    // MARK: - Properties
    var model: MeditationViewModel
    var userModel: UserViewModel
    var gardenModel: GardenViewModel
    var bonusModel: BonusViewModel
    var onDismiss: Page
    @State private var playEntryAnimation = false
    @State private var playAnim = false


    @EnvironmentObject var viewRouter: ViewRouter

    @State private var reward: Int = 0
    
    var minsMed: Int {
        if model.selectedMeditation?.duration == -1 {
            return Int((model.secondsRemaining / 60.0).rounded())
        } else {
            if Int(model.selectedMeditation?.duration ?? 0) / 60 == 0 {
                return 1
            } else {
                return Int(model.selectedMeditation?.duration ?? 0) / 60
            }
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { g in
            VStack {
                Spacer()
                    .frame(height: 50)
                // MEDITATING TURLE IMAGE
                if model.selectedMeditation?.imgURL != "" {
                    UrlImageView(urlString: model.selectedMeditation?.imgURL ?? "")
                        .scaledToFit()
                        .frame(height: 150)
                        .padding(.vertical, 20)
                } else {
                    model.selectedMeditation?.img
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding(.vertical, 20)
                }

                VStack(alignment: .leading) {
                    // TITLE

                    Text("\(model.selectedMeditation?.title ?? "")\nCompleted")
                        .font(Font.fredoka(.bold, size: 28))
                        .foregroundColor(Clr.darkgreen)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
//                    Text("")
//                        .font(Font.fredoka(.bold, size: 28))
//                        .foregroundColor(Clr.darkgreen)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .padding(.horizontal)
                    
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(colors: [Clr.brightGreen.opacity(0.8), Clr.yellow], startPoint: .leading, endPoint: .trailing))
                            .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                            .font(Font.fredoka(.medium, size: 24))
                            .overlay(CustomLottieAnimationView(filename: "party", loopMode: .playOnce, isPlaying: $playAnim)
                                .scaleEffect(2))                    
                        VStack(alignment: .leading, spacing: 0) {
                            
                            // TIME MEDITATED
                            (
                                Text(model.totalBreaths > 0 ? "Total Breaths meditated: " : "Time meditated: ")
                                    .font(Font.fredoka(.semiBold, size: 24))
                                    .foregroundColor(Clr.black2)
                                +
                                Text(model.totalBreaths > 0 ? String(model.totalBreaths) : "\(String(minsMed)) Min")
                                    .font(Font.fredoka(.bold, size: 24))
                                    .foregroundColor(.black)
                            )
                            .padding(.horizontal)
                            
                            // COINS EARNED
                            HStack {
                                Text("Coins Earned: ")
                                    .font(Font.fredoka(.semiBold, size: 24))
                                    .foregroundColor(Clr.black2)
                                Img.coinBunch
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 25)
                                Text(UserDefaults.standard.bool(forKey: "isPro") ? "\(reward / 2) x 2: \(reward)" : "+\(reward)!")
                                    .font(Font.fredoka(.bold, size: 24))
                                    .foregroundColor(.black)
                                if userModel.isPotion || userModel.isChest {
                                    Img.sunshinepotion
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 30)
                                        .rotationEffect(.degrees(30))
                                }
                            } //: HStack
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .offset(y: playEntryAnimation ? 0 : 100)
                        }
                        Spacer()
                    } //: ZStack
                    // FOOTER FOR SHARE AND CONTINUE
                    ShareAndContinueFooter(
                        model: model,
                        userModel: userModel,
                        gardenModel: gardenModel,
                        bonusModel: bonusModel,
                        onDismiss: onDismiss,
                        isFirst: true,
                        viewRouter: _viewRouter
                    ) //: ShareAndContinueFooter
                } //: VStack
            } //: VStack
            .padding(.all, 24)
            .transition(.move(edge: .trailing))
        } //: GeometryReader
        .onAppear {
            withAnimation(.spring()) {
                playAnim = true
                playEntryAnimation = true
            }
            
            if UserDefaults.standard.bool(forKey: "isPlayMusic") {
                if let player = player {
                    player.play()
                }
            }

            var session = [String: String]()
            session[K.defaults.plantSelected] = userModel.selectedPlant?.title
            var minutesMed = 0

            if model.totalBreaths > 0 {
                if let selectedBreath = model.selectedBreath {
                    session[K.defaults.meditationId] = String(selectedBreath.id)
                    switch selectedBreath.duration * model.totalBreaths {
                    case 0 ... 35: minutesMed = 30
                    case 36 ... 70: minutesMed = 60
                    default: minutesMed = selectedBreath.duration * model.totalBreaths
                    }
                    if minutesMed >= 30 {
                        userModel.finishedMeditation(id: String(selectedBreath.id))
                    }
                }
                session[K.defaults.duration] = String(minutesMed)
                // Log Analytics
//                #if !targetEnvironment(simulator)
//                    Amplitude.instance().logEvent("finished_breathwork", withEventProperties: ["breathwork": model.selectedBreath?.title ?? "default"])
//                #endif
                print("logging, \("finished_\(model.selectedMeditation?.returnEventName() ?? "")")")
            } else {
                session[K.defaults.meditationId] = String(model.selectedMeditation?.id ?? 0)
                session[K.defaults.duration] = model.selectedMeditation?.duration == -1 ? String(model.secondsRemaining) : String(model.selectedMeditation?.duration ?? 0)
                let dur = model.selectedMeditation?.duration ?? 0
                if !((model.forwardCounter > 2 && dur <= 120) || (model.forwardCounter > 6) || (model.selectedMeditation?.id == 22 && model.forwardCounter >= 1)) {
                    userModel.finishedMeditation(id: String(model.selectedMeditation?.id ?? 0))
                }
                // Log Analytics
//                #if !targetEnvironment(simulator)
//                    Amplitude.instance().logEvent("finished_meditation", withEventProperties: ["meditation": model.selectedMeditation?.returnEventName() ?? ""])
//                #endif
                print("logging, \("finMed_\(model.selectedMeditation?.returnEventName() ?? "")")")
            }
            session["timeStamp"] = Date.getTime()
            reward = model.getReward()
            if userModel.isPotion || userModel.isChest {
                reward = reward * 3
            }
//
            userModel.coins += reward
            gardenModel.save(key: "sessions", saveValue: session, coins: userModel.coins) {
         
            }
        }
    }
}

//#if DEBUG
//struct MeditationCompleted_Previews: PreviewProvider {
//    static var previews: some View {
//        MeditationCompleted(model: MeditationViewModel())
//    }
//}
//#endif

struct ShareAndContinueFooter: View {
    
    // MARK: - Properties
    
    var model: MeditationViewModel
    var userModel: UserViewModel
    var gardenModel: GardenViewModel
    var bonusModel: BonusViewModel
    var onDismiss: Page
    var isFirst: Bool = false

    @State private var showStreak = false
    @State private var showRating = false
    @State private var favorited = false
    @State private var ios14 = true
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var heart: some View {
        ZStack {
        
            if model.isFavoritedLoaded {
                LikeButton(isLiked: model.isFavorited, size: 35) {
                    likeAction()
                }
            } else {
                LikeButton(isLiked: false) {
                    likeAction()
                }
            }
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { g in
            HStack {
                heart.padding(.horizontal)
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Clr.black1)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        PHPhotoLibrary.requestAuthorization { _ in
                            // No crash
                        }
                        let snap = self.takeScreenshot(origin: g.frame(in: .global).origin, size: g.size)
                        if let myURL = URL(string: "https://mindgarden.io") {
                            let objectToshare = [snap, myURL] as [Any]
                            let activityVC = UIActivityViewController(activityItems: objectToshare, applicationActivities: nil)
                            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                        }
                    }
                Spacer()
                Button {
                    gardenModel.updateSelf()
                } label: {
                    Capsule()
                        .fill(Clr.yellow)
                        .overlay(
                            HStack {
                                Text("Continue")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.bold, size: 20))
                                Image(systemName: "arrow.right")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 22, weight: .bold))
                            } //: HStack
                        )
                        .addBorder(.black, width: 1.5, cornerRadius: 25)
                        .padding(.horizontal)
                        // TODO: -> change not now in saveProgress modal to trigger showStreak
                        .onTapGesture {
                            if isFirst {
                                Analytics.shared.log(event: .meditationCompleted_tapped_continue)
                            } else {
                                Analytics.shared.log(event: .congratulations_tapped_continue)
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                let launchNum = DefaultsManager.standard.value(forKey: .dailyLaunchNumber).integerValue
//                                UserDefaults.standard.integer(forKey: "dailyLaunchNumber")
                                if !showRating {
                                    if launchNum == 2 || launchNum == 4 || launchNum == 7 || launchNum == 9 {
                                        showRating = true
//                                        if !UserDefaults.standard.bool(forKey: "reviewedApp") {
                                        if !DefaultsManager.standard.value(forKey: .reviewedApp).boolValue {
                                            if let scene = UIApplication.shared.activeScene {
                                                SKStoreReviewController.requestReview(in: scene)
                                            } else {
                                                dismiss()
                                            }
                                        } else {
                                            dismiss()
                                        }
                                    } else {
                                        dismiss()
                                    }
                                } else {
                                    dismiss()
                                }
                            }
                        }
                } //: Button
                .zIndex(100)
                .frame(width: g.size.width * 0.6, height: 50)
                .buttonStyle(ScalePress())
            } //: HStack
            .frame(width: abs(g.size.width - 50), height: 60)
            .background(!K.isSmall() ? .clear : Clr.darkWhite)
            .padding()
            .position(x: g.size.width / 2, y: g.size.height - g.size.height / (K.hasNotch() ? ios14 ? 7 : 9 : 4))
        } //: GeometryReader
        .onAppear {
            DispatchQueue.main.async {
                if #available(iOS 15.0, *) {
                    ios14 = false
                }
                if #available(iOS 16.0, *) {
//                    ios16 = true
                }
            }

        }
        .fullScreenCover(isPresented: $showStreak, content: {
            StreakScene(showStreak: $showStreak)
                .environmentObject(bonusModel)
                .environmentObject(viewRouter)
                .background(Clr.darkWhite)
        })
    }
    
    // MARK: - Helper Functions
    private func likeAction() {
        if isFirst {
            Analytics.shared.log(event: .meditationCompleted_tapped_heart)
        } else {
            Analytics.shared.log(event: .congratulations_tapped_heart)
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let med = model.selectedMeditation {
    //                    Analytics.shared.log(event: "favorited_\(med.returnEventName())")
            model.favorite(id: med.id)
        }
        favorited.toggle()
    }
    
    private func dismiss() {
        if updatedStreak && model.shouldStreakUpdate {
            showStreak.toggle()
            updatedStreak = false
        } else {
            viewRouter.currentPage = onDismiss
        }
    }
}
