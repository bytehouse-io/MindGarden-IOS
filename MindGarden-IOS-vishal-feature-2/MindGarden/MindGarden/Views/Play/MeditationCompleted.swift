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
    var onDismiss: Page

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
            let width = g.size.width
            let height = g.size.height
            
            VStack {
                Spacer()
                    .frame(height: 150)
                // MEDITATING TURLE IMAGE
                Img.meditatingTurtle2
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .padding(.bottom, 40)
                VStack(alignment: .leading) {
                    // TITLE
                    Text("Meditation Completed")
                        .font(Font.fredoka(.bold, size: 28))
                        .foregroundColor(Clr.darkgreen)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    
                    // TIME MEDITATED
                    (
                        Text(model.totalBreaths > 0 ? "Total Breaths meditated: " : "Time meditated: ")
                            .font(Font.fredoka(.semiBold, size: 16))
                            .foregroundColor(Clr.black2)
                        +
                        Text(model.totalBreaths > 0 ? String(model.totalBreaths) : "\(String(minsMed)) Min")
                            .font(Font.fredoka(.bold, size: 16))
                            .foregroundColor(.black)
                    )
                    .padding(.horizontal)
                    
                    // COINS EARNED
                    HStack {
                        Text("Coins Earned: ")
                            .font(Font.fredoka(.semiBold, size: 16))
                            .foregroundColor(Clr.black2)
                        Img.coinBunch
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                        Text(UserDefaults.standard.bool(forKey: "isPro") ? "\(reward / 2) x 2: \(reward)" : "+\(reward)!")
                            .font(Font.fredoka(.bold, size: 16))
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
                    
                    Spacer()
                    
                    // FOOTER FOR SHARE AND CONTINUE
                    ShareAndContinueFooter(
                        model: model,
                        userModel: userModel,
                        gardenModel: gardenModel,
                        onDismiss: onDismiss,
                        viewRouter: _viewRouter
                    ) //: ShareAndContinueFooter
                } //: VStack
            } //: VStack
            .padding(.all, 24)
        } //: GeometryReader
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
    var onDismiss: Page

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
                            Analytics.shared.log(event: .finished_tapped_finished)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                let launchNum = UserDefaults.standard.integer(forKey: "dailyLaunchNumber")
                                if !showRating {
                                    if launchNum == 2 || launchNum == 4 || launchNum == 7 || launchNum == 9 {
                                        showRating = true
                                        if !UserDefaults.standard.bool(forKey: "reviewedApp") {
                                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
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
            if UserDefaults.standard.bool(forKey: "isPlayMusic") {
                if let player = player {
                    player.play()
                }
            }
            
            DispatchQueue.main.async {
                if #available(iOS 15.0, *) {
                    ios14 = false
                }
//                if #available(iOS 16.0, *) {
//                    ios16 = true
//                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func likeAction() {
        Analytics.shared.log(event: .play_tapped_favorite)
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
