//
//  HoorayView.swift
//  MindGarden
//
//  Created by apple on 20/04/23.
//

import SwiftUI

struct HoorayView: View {
    
    // MARK: - Properties
    
    @State private var isOnboarding = false
    @State private var playAnim = false
    @State private var playEntryAnimation = false
    @State private var rowOpacity = 1.0
    @State private var moodCoins = 1
    @State private var showRecs = false

    @Binding var recs: [Int]
    @Binding var coin: Int
    
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.presentationMode) var presentationMode

    let width = UIScreen.screenWidth

    // MARK: - Body
    
    var body: some View {
        GeometryReader { g in
            VStack {
                Spacer()
                    .frame(height: 80)
                Text("Hooray!")
                    .foregroundColor(Clr.brightGreen)
                    .font(Font.fredoka(.semiBold, size: 36))
                    .multilineTextAlignment(.center)
                (
                    Text("You earned")
                        .foregroundColor(Clr.black2)
                    +
                    Text("  +\(moodCoins + coin)  ")
                        .foregroundColor(Clr.brightGreen)
                    +
                    Text("coins")
                        .foregroundColor(Clr.black2)
                )
                .font(Font.fredoka(.semiBold, size: 24))
                .padding(.bottom)
                Spacer()
                Img.coinBunch
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.leading, 16)
                    .frame(width: 200)
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(LinearGradient(colors: [Clr.brightGreen.opacity(0.8), Clr.yellow], startPoint: .leading, endPoint: .trailing))
                        .font(Font.fredoka(.medium, size: 20))
                        .overlay(CustomLottieAnimationView(filename: "party", loopMode: .playOnce, isPlaying: $playAnim)
                            .scaleEffect(2))
                    VStack(spacing: 10) {
                        Spacer()
                        HStack() {
                            Text("+\(moodCoins)")
                                .foregroundColor(.white)
                                .font(Font.fredoka(.bold, size: 20)) +
                            Text("  Mood Check")
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.semiBold, size: 20))
                            Spacer()
                            Mood.getMoodImage(mood: userModel.selectedMood)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
                        } //: HStack
                        HStack {
                            Text("+\(coin)")
                                .foregroundColor(.white)
                                .font(Font.fredoka(.bold, size: 20))
                            +
                            Text("  Journaling")
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.semiBold, size: 20))
                            Spacer()
                            Img.streakPencil
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
                        } //: HStack
                        Spacer()
                    } //: VStack
                    .padding()
                    .frame(width: g.size.width * 0.8)
                } //: ZStack
                .frame(width: width * 0.85, height: 150)
                .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                Spacer()
                    
                ContinueButton(
                    action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        // Analytics.shared.log(event: .hooray_tapped_continue)
//                        presentationMode.wrappedValue.dismiss()
                        showRecs = true
                    },
                    enabled: Binding(get: { true }, set: { _, _ in })
                ) //: ContinueButton
                .frame(width: g.size.width * 0.8)
            } //: VStack
            .frame(maxWidth: .infinity)
        } //: GeometryReader
        .onAppear {
            if let moods = gardenModel.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?["moods"] as? [[String: String]] {
                if moods.count == 1 {
                    moodCoins = 20
                } else {
                    moodCoins = max(20 / ((moods.count - 1) * 3), 1)
                }
            } else {
                moodCoins = 20
            }
            withAnimation(.spring()) {
                playAnim = true
                playEntryAnimation = true
            }

            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" && !UserDefaults.standard.bool(forKey: "review") {
                if UserDefaults.standard.integer(forKey: "numMeds") == 0 {
                    // Analytics.shared.log(event: .onboarding_load_recs)
                    isOnboarding = true
                    var count = 0
                    let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        count += 1
                        if count == 1 {
                            timer.invalidate()
                            withAnimation {
                                rowOpacity = 0.2
                            }
                        }
                    }
                }
            } else {
                // Analytics.shared.log(event: .screen_load_recs)
            }
        }
        .fullScreenCover(isPresented: $showRecs) {
            RecommendationsView(recs: $recs, coin: $coin)
        }
//        .transition(.move(edge: .trailing))
    }
}
