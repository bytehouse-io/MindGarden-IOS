//
//  Finished.swift
//  MindGarden
//
//  Created by Dante Kim on 7/10/21.
//

import SwiftUI
import Photos

struct Finished: View {
    var model: MeditationViewModel
    var userModel: UserViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    var gardenModel: GardenViewModel
    @State private var sharedImage: UIImage?
    @State private var shotting = true
    @State private var isOnboarding = false
    @State private var animateViews = false
    @State private var favorited = false
    @State private var showUnlockedModal = false

    var minsMed: Int {
        if Int(model.selectedMeditation?.duration ?? 0)/60 == 0 {
            return 1
        } else {
            return Int(model.selectedMeditation?.duration ?? 0)/60
        }
    }

    init(model: MeditationViewModel, userModel: UserViewModel, gardenModel: GardenViewModel) {
        self.model = model
        self.userModel = userModel
        self.gardenModel = gardenModel
    }

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { g in
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    Rectangle()
                        .fill(Clr.finishedGreen)
                        .frame(width: g.size
                                .width/1, height: g.size.height/2)
                        .offset(y: -g.size.height/4)
                    Img.greenBlob
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: g.size
                                .width/1, height: g.size.height/2)
                        .offset(x: g.size.width/6, y: -g.size.height/4)
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 20) {
                            VStack {
                                Text("Minutes Meditated")
                                    .font(Font.mada(.semiBold, size: 28))
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        withAnimation {
                                            viewRouter.currentPage  = .garden
                                        }
                                    }
                                Text(String(minsMed))
                                    .font(Font.mada(.bold, size: 70))
                                    .foregroundColor(.white)
                                    .animation(.easeInOut(duration: 1.5))
                                    .opacity(animateViews ? 0 : 1)
                                    .offset(x: animateViews ? 500 : 0)

                                HStack {
                                    Text("You received:")
                                        .font(Font.mada(.semiBold, size: 24))
                                        .foregroundColor(.white)
                                    Img.coin
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                    Text("\(model.selectedMeditation?.reward ?? 0)!")
                                        .font(Font.mada(.bold, size: 24))
                                        .foregroundColor(.white)
                                        .offset(x: -5)
                                }.offset(y: -20)
                            }.padding(.bottom, g.size.height * 0.08)
                            VStack {
                                Text("With patience and mindfulness you were able to grow a \(userModel.selectedPlant?.title ?? "")!")
                                    .font(Font.mada(.bold, size: 22))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.05)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Clr.black1)
                                    .frame(height: g.size.height/12)
                                    .padding(.horizontal)
                                userModel.selectedPlant?.badge
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: g.size.height/2.75)
                                    .padding(10)
                                    .animation(.easeInOut(duration: 2.0))
                                    .offset(y: 0)
                                Spacer()
                                ZStack {
                                    LottieView(fileName: "confetti")
                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                        .offset(x: 0, y: -g.size.height * 0.5)
                                    HStack {
                                        Image(systemName: favorited ? "heart.fill" : "heart")
                                            .font(.system(size: 36, weight: .bold))
                                            .foregroundColor(favorited ? Color.red : Clr.black1)
                                            .padding()
                                            .padding(.leading)
                                            .onTapGesture {
                                                Analytics.shared.log(event: .finished_tapped_favorite)
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                if let med = model.selectedMeditation {
                                                    model.favorite(selectMeditation: med)
                                                }
                                                favorited.toggle()
                                            }
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(Clr.black1)
                                            .onTapGesture {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                PHPhotoLibrary.requestAuthorization { (status) in
                                                          // No crash
                                                }
                                                let snap = self.takeScreenshot(origin: g.frame(in: .global).origin, size: g.size)
                                                let myURL = URL(string: "https://mindgarden.io")
                                                let objectToshare = [snap, myURL!] as [Any]
                                                let activityVC = UIActivityViewController(activityItems: objectToshare, applicationActivities: nil)
                                                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                                            }
                                        Spacer()
                                        Button {
                                            Analytics.shared.log(event: .finished_tapped_finished)
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            withAnimation {
                                                viewRouter.currentPage = .garden
                                            }
                                        } label: {
                                            Capsule()
                                                .fill(Clr.yellow)
                                                .padding(.horizontal)
                                                .overlay(
                                                    HStack {
                                                        Text("Finished")
                                                            .foregroundColor(Clr.black1)
                                                            .font(Font.mada(.bold, size: 22))
                                                        Image(systemName: "arrow.right")
                                                            .foregroundColor(Clr.black1)
                                                            .font(.system(size: 22, weight: .bold))
                                                    }
                                                )
                                        }.buttonStyle(NeumorphicPress())
                                        .zIndex(100)
                                        .frame(width: g.size.width * 0.6, height: g.size.height/12)
                                    }

                                }.frame(width: g.size.width, height: g.size.height/12)
                                .padding()
                            }
                            .frame(height: g.size.height/2)
                        }
                        Spacer()
                    }.frame(width: g.size.width, height: g.size.height)
                    .offset(y: -60)
                    if showUnlockedModal {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
                    OnboardingModal(shown: $showUnlockedModal, isUnlocked: true)
                        .offset(y: showUnlockedModal ? 0 : g.size.height)
                        .animation(.default)
                }
            }
        }.transition(.move(edge: .trailing))
        .animation(.easeIn)

        .onDisappear {
            model.playImage = Img.seed
            model.lastSeconds = false
        }
        .onAppear {
            showUnlockedModal = UserDefaults.standard.bool(forKey: "unlockStrawberry") && !UserDefaults.standard.bool(forKey: "strawberryUnlocked")
            favorited = model.isFavorited
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                Analytics.shared.log(event: .onboarding_finished_meditation)
                UserDefaults.standard.setValue("meditate", forKey: K.defaults.onboarding)
                isOnboarding = true
            }
            Analytics.shared.log(event: AnalyticEvent.getMeditation(meditation: "finished_\(model.selectedMeditation?.returnEventName() ?? "")"))
            var session = [String: String]()
            session[K.defaults.plantSelected] = userModel.selectedPlant?.title
            session[K.defaults.meditationId] = String(model.selectedMeditation?.id ?? 0)
            session[K.defaults.duration] = String(model.selectedMeditation?.duration ?? 0)
            userCoins += model.selectedMeditation?.reward ?? 0
            gardenModel.save(key: "sessions", saveValue: session)
        }
        .onAppearAnalytics(event: .screen_load_finished)

    }


}

struct Finished_Previews: PreviewProvider {
    static var previews: some View {
        Finished(model: MeditationViewModel(), userModel: UserViewModel(), gardenModel: GardenViewModel())
    }
}

