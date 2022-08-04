//
//  ContentView.swift
//
//
//  Created by Vishal Davara on 28/02/22.
//

import SwiftUI
import StoreKit
import Firebase

struct StreakScene: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    var title : String {
        return "\(bonusModel.streakNumber) Day Streak"
    }
    @Binding  var showStreak: Bool
    @State private var img = UIImage()
    @State private var isSharePresented: Bool = false
    @State private var showButtons = true
    @State private var triggerRating = false
    @State private var showNextSteps = false
    
    var subTitle : String {
        switch bonusModel.streakNumber {
        case 1:  return "👣 A journey of a thousand miles begins with a single step - Lao Tzu"
        case 2:  return "Great Work! Let's make it \(bonusModel.streakNumber+1) in a row \ntomorrow!"
        case 3: return "3 is a magical 🦄 number, and you're on fire!"
        case 4: return "👀 Wow only 22% of our users make it this far"
        case 7: return "🎉 1 Full Week! You're killing it"
        case 10: return "Double digits!!! Only 10% of our users make it this far"
        case 14: return "🎉 2 Full Weeks!! You're a star"
        case 21: return "🎉 3 Full Weeks!! You've offially made it a habit"
        case 30: return "👏 Everyone here on the MindGarden team applauds you"
        case 50: return "🥑 We're half way to a 100!"
        case 60: return "2 Full MONTHS! You're in the 1% of MindGarden meditators"
        default: return "Great Work! Let's make it \(bonusModel.streakNumber+1) in a row \ntomorrow!"
        }
    }
    @State var timeRemaining = 2
    @State private var timer : Timer?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                ZStack {
                    LottieAnimationView(filename: "flame 1", loopMode: .playOnce, isPlaying: .constant(true))
                        .frame(width: 500, height: 500, alignment: .center)
                        .opacity(timeRemaining <= 0 ? 0 : 1)
                    LottieAnimationView(filename: "flame 2", loopMode: .loop, isPlaying: .constant(true))
                        .frame(width: 500, height: 500, alignment: .center)
                        .opacity(timeRemaining <= 0 ? 1 : 0)
                }.offset(y: 75)
                Spacer()
                Text(title)
                    .streakTitleStyle()
                    .offset(y: 25)
                Text(subTitle)
                    .streakBodyStyle()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 150)
                DaysProgressBar()
                Spacer()
                if showButtons {
//                    Button {
//                        showButtons = false
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            img = takeStreakSceneScreenshot(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
//                            isSharePresented = true
//                        }
//                    } label: {
//                        Capsule()
//                            .fill(Clr.gardenRed)
//                            .frame(width: UIScreen.main.bounds.width * 0.85 , height: 58)
//                            .overlay(
//                                Text("Share")
//                                    .font(Font.fredoka(.bold, size: 24))
//                                    .foregroundColor(.white)
//                            )
//                    }
//                    .buttonStyle(NeumorphicPress())
//                    .shadow(color: Clr.shadow.opacity(0.3), radius: 5, x: 5, y: 5)
//                    .padding(.top, 50)
                    Button {
                        let launchNum = UserDefaults.standard.integer(forKey: "launchNumber")
                        if Auth.auth().currentUser?.email == nil && launchNum >= 2 {
                            fromPage = "garden"
                            viewRouter.currentPage = .authentication
                        } else {
                            if !UserDefaults.standard.bool(forKey: "tappedRate") {
                                if launchNum == 1 || launchNum == 3 || launchNum == 5 || launchNum == 7  {
                                    if !UserDefaults.standard.bool(forKey: "reviewedApp") {
                                        triggerRating.toggle()
                                    } else {
                                        dismiss()
                                    }
                                }
                            }
                        }
                    } label: {
                        Capsule()
                            .fill(Clr.gardenRed)
                            .frame(width: UIScreen.main.bounds.width * 0.85 , height: 58)
                            .overlay(
                                Text("Continue")
                                    .font(Font.fredoka(.bold, size: 24))
                                    .foregroundColor(.white)
                            )
                            .addBorder(.black, width: 1.5, cornerRadius: 24)
                    }
                    .buttonStyle(NeumorphicPress())
                    
                    .shadow(color: Clr.shadow.opacity(0.3), radius: 5, x: 5, y: 5)
                    .padding(.top, 40)
                }
            }
            .offset(y: -145)
        }
        .alert(isPresented: $triggerRating) {
            Alert(title: Text("🧑‍🌾 Are you enjoying MindGarden so far?"), message: Text(""),
                  primaryButton: .default(Text("Yes!")) {
                UserDefaults.standard.setValue(true, forKey: "reviewedApp")
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                                dismiss()
                }
            },
                  secondaryButton: .default(Text("No")) {
                    dismiss()
            })
        }
        .onChange(of: isSharePresented) { value in
            showButtons = !value
        }
        .sheet(isPresented: $isSharePresented) {
            ShareView(img:img)
        }
        .onAppear() {
            MGAudio.sharedInstance.stopSound()
            MGAudio.sharedInstance.playSounds(soundFileNames: ["fire_ignite.mp3","fire.mp3"])
            self.animate()

        }
        .onDisappear() {
            MGAudio.sharedInstance.stopSound()
            timer?.invalidate()
        }
//        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { theValue in
//            print("-----> The Value is \(theValue)") // <--- this will be executed
//            if timeRemaining > 0 {
//                timeRemaining -= 1
//            }
//        }

        .background(Clr.darkWhite)
        .fullScreenCover(isPresented: $showNextSteps) {
            NextSteps()
                .environmentObject(viewRouter)
        }
    }
    
    private func dismiss() {
        withAnimation {
            if UserDefaults.standard.integer(forKey: "launchNumber") == 2 || UserDefaults.standard.integer(forKey: "launchNumber") == 5 || bonusModel.streakNumber == 2 ||  UserDefaults.standard.integer(forKey: "launchNumber") == 10  {
                fromPage = ""
                viewRouter.previousPage = .garden
                viewRouter.currentPage = .pricing
            } else {
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" {
                    showNextSteps = true
                } else {
                    viewRouter.previousPage = .garden
                    viewRouter.currentPage = .garden
                }
            }
        }
    }
    
    private func animate() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct StreakScene_Previews: PreviewProvider {
    static var previews: some View {
        StreakScene(showStreak: .constant(true))
            .environmentObject(BonusViewModel(userModel: UserViewModel(), gardenModel: GardenViewModel()))
    }
}

struct ShareView: View {
    @State var img: UIImage?
    var body: some View {
        if let shareImg = img {
            ActivityViewController(activityItems: [shareImg])
        }
    }
}

extension View {
    func takeStreakSceneScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self
                                            .environmentObject(SceneDelegate.userModel)
                                            .environmentObject(SceneDelegate.bonusModel)
                                            .environmentObject(SceneDelegate.gardenModel)
        )
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}
