//
//  ContentView.swift
//  MindGarden
//
//  Created by Dante Kim on 5/25/21.
//

import SwiftUI
import Combine
import Lottie
import Network


struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @State private var showPopUp = false
    @State private var addMood = false
    @State private var openPrompts = false
    @State private var addGratitude = false
    @State private var isOnboarding = false
    @State private var isKeyboardVisible = false
    @State private var animateSplash = false
    @State private var showSplash = true
    @State private var animationAmount: CGFloat = 1
    ///Ashvin : State variable for pass animation flag
    @State private var PopUpIn = false
    @State private var showPopUpOption = false
    @State private var showItems = false
    @State private var showRecs = false
    var bonusModel: BonusViewModel
    var profileModel: ProfileViewModel
    var authModel: AuthenticationViewModel
    @State var hasConnection = false

    @State var selectedPopupOption: PlusMenuType = .none
    init(bonusModel: BonusViewModel, profileModel: ProfileViewModel, authModel: AuthenticationViewModel) {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        self.bonusModel = bonusModel
        self.profileModel = profileModel
        self.authModel = authModel
        //        meditationModel.isOpenEnded = false
        //        meditationModel.secondsRemaining = 150
        // check for auth here
    }

    var body: some View {
        VStack {
            ZStack {
                // Content
                ZStack {
                    GeometryReader { geometry in
                        ZStack {
                            Clr.darkWhite.edgesIgnoringSafeArea(.all)
                            Rectangle()
                                .fill(Color.gray)
                                .zIndex(100)
                                .frame(width: geometry.size.width, height: (hasConnection ? 0 : 60))
                                .overlay(
                                    VStack {
                                        Spacer()
                                        Text("You're offline. Data will not be saved.")
                                            .font(Font.mada(.medium, size: 14))
                                            .foregroundColor(.white)
                                            .opacity(hasConnection ? 0 : 1)
                                    }.frame(height: (hasConnection ? 0 : 50))
                                ).offset(y: -18)
                                .position(x: geometry.size.width/2, y: 0)
                            VStack {
                                if #available(iOS 14.0, *) {
                                    switch viewRouter.currentPage {
                                    case .onboarding:
                                            OnboardingScene()
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                                .navigationViewStyle(StackNavigationViewStyle())
                                    case .experience:
                                            ExperienceScene()
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                                .navigationViewStyle(StackNavigationViewStyle())
                                    case .meditate:
                                        Home(bonusModel: bonusModel)
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .onAppear {
                                                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "signedUp" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "mood" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                                                    showPopupWithAnimation {
                                                        self.isOnboarding = true
                                                    }
                                                }
                                            }
                                            .disabled(isOnboarding)
                                            .environmentObject(profileModel)
                                    case .garden:
                                        Garden()
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .onAppear {
                                                    showPopUpOption = false
//                                                    showPopUp = false
                                                    showItems = false
                                            }
                                    case .shop:
                                        Store(showPlantSelect: .constant(false))
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .environmentObject(bonusModel)
                                            .environmentObject(profileModel)
                                    case .learn:
                                        LearnScene()
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .categories:
                                        CategoriesScene(showSearch: .constant(false))
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .middle:
                                        MiddleSelect()
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .play:
                                        Play()
                                            .frame(height: geometry.size.height + 80)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .onAppear {
                                                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                                                    self.isOnboarding = false
                                                }
                                            }
                                    case .finished:
                                        Finished(model: meditationModel, userModel: userModel, gardenModel: gardenModel)
                                            .frame(height: geometry.size.height + 160)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .authentication:
                                        Authentication(isSignUp: !tappedSignIn, viewModel: authModel)
                                            .frame(height: geometry.size.height + 160)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .notification:
                                        NotificationScene()
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .name:
                                        NameScene()
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .pricing:
                                        PricingView()
                                            .frame(height: geometry.size.height + 80)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .reason:
                                        ReasonScene()
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .review:
                                        ReviewScene()
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    }

                                } else {
                                    // Fallback on earlier versions
                                }
//                                if viewRouter.currentPage == .notification || viewRouter.currentPage == .onboarding
//                                                        || viewRouter.currentPage == .experience || viewRouter.currentPage == .name  || viewRouter.currentPage == .reason || viewRouter.currentPage == .review {
//                                            VStack {
//                                                Img.lily3
//                                                    .resizable()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .frame(width: 100)
//                                                    .rotationEffect(Angle(degrees: 20))
//                                                    .position(x: 30, y: 0)
//                                                Img.redMushroom3
//                                                    .resizable()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .frame(width: 100)
//                                                    .rotationEffect(Angle(degrees: 20))
//                                                    .position(x: width/4, y: 0)
//                                                Img.redTulips3
//                                                    .resizable()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .frame(width: 200)
//                                                    .rotationEffect(Angle(degrees: 20))
//                                                    .position(x: UIScreen.main.bounds.width, y: 0)
//                                            }.frame(height: 100)
//                                    }
                                if viewRouter.currentPage == .notification || viewRouter.currentPage == .onboarding
                                                || viewRouter.currentPage == .experience || viewRouter.currentPage == .name  || viewRouter.currentPage == .reason || viewRouter.currentPage == .review {
                                        ZStack(alignment: .leading) {
                                            Rectangle().frame(width: geometry.size.width - 50 , height: 20)
                                                .opacity(0.3)
                                                .foregroundColor(Clr.darkWhite)
                                            Rectangle().frame(width: min(CGFloat(viewRouter.progressValue) * (geometry.size.width - 50), geometry.size.width - 50), height: 20)
                                                .foregroundColor(Clr.brightGreen)
                                                .animation(.linear)
                                                .neoShadow()
                                        }.cornerRadius(45.0)
                                            .padding()
                                            .oldShadow()
    
//                                    ZStack {
//                                        Img.lilyValley3
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 100)
//                                            .rotationEffect(Angle(degrees: 20))
//                                            .position(x: 20, y: -15)
//                                        Img.redMushroom3
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 100)
//                                            .rotationEffect(Angle(degrees: 20))
//                                            .position(x: UIScreen.main.bounds.width/2, y: 20)
//                                        Img.redTulips3
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 200)
//                                            .rotationEffect(Angle(degrees: 20))
//                                            .position(x: UIScreen.main.bounds.width - 15, y: 0)
//                                    }.frame(height: 100)
//                                        .zIndex(-100)
                                }
                            }.edgesIgnoringSafeArea(.all)
                            
                            if viewRouter.currentPage == .meditate || viewRouter.currentPage == .garden || viewRouter.currentPage == .categories || viewRouter.currentPage == .learn || viewRouter.currentPage == .shop || (viewRouter.currentPage == .finished &&                     UserDefaults.standard.string(forKey: K.defaults.onboarding) != "meditate" &&                     UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude"
                            ) {
                                ///Ashvin : Replace background button to stack with shollw effect with animation
                                ZStack {
                                    Rectangle()
                                        .opacity(addMood || addGratitude || isOnboarding ? 0.3 : 0.0)
                                        .foregroundColor(Clr.black1)
                                        .edgesIgnoringSafeArea(.all)
                                        .frame(height: geometry.size.height + (viewRouter.currentPage == .finished ? 160 : 10))
                                        .transition(.opacity)
                                }
                                .onTapGesture {
                                    if !isOnboarding {
                                        withAnimation {
                                            hidePopupWithAnimation {
                                                addMood = false
                                                addGratitude = false
                                            }
                                        }
                                    }
                                }
                                ZStack {
                                    HomeTabView(selectedOption:$selectedPopupOption, viewRouter:viewRouter, showPopup: $showPopUp, isOnboarding:$isOnboarding)
                                        .onChange(of: selectedPopupOption) { value in
                                            setSelectedPopupOption(selectedOption:value)
                                        }
                                    //The way user defaults work is that each step, should be the previous steps title. For example if we're on the mood check step,
                                    //onboarding userdefault should be equal to signedUp because we just completed it.
                                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "signedUp" || UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "mood" ||  UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "gratitude"   {
                                        LottieView(fileName: "side-arrow")
                                            .frame(width: 75, height: 25)
                                            .padding(.horizontal)
                                            .offset(x: -20, y: UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "signedUp" ? geometry.size.height * (K.hasNotch()  ? -0.050 : 0.125) : UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "gratitude" ? geometry.size.height * (K.hasNotch()  ? 0.1 : 0.025) : geometry.size.height * (K.hasNotch()  ? 0.03 : -0.045))
                                    }
                                }
                                MoodCheck(shown: $addMood, showPopUp: $showPopUp, PopUpIn: $PopUpIn, showPopUpOption: $showPopUpOption, showItems: $showItems, showRecs: $showRecs)
                                    .frame(width: geometry.size.width, height: geometry.size.height * 0.45)
                                    .background(Clr.darkWhite)
                                    .cornerRadius(12)
                                    .offset(y: addMood ?( geometry.size.height/(K.hasNotch() ? 2.75 : 3) + (viewRouter.currentPage == .finished ? -75 : 0)) : geometry.size.height)
                                Gratitude(shown: $addGratitude, showPopUp: $showPopUp, openPrompts: $openPrompts, contentKeyVisible: $isKeyboardVisible, PopUpIn: $PopUpIn, showPopUpOption: $showPopUpOption, showItems: $showItems)
                                    .frame(width: geometry.size.width, height: (geometry.size.height * (K.hasNotch() ? 0.5 : 0.6 ) * (openPrompts ? 2.25 : 1)) + (isKeyboardVisible ? geometry.size.height * 0.2 : 0))
                                    .background(Clr.darkWhite)
                                    .cornerRadius(12)
                                    .offset(y: (addGratitude ? (geometry.size.height/((K.hasNotch()
                                                                                     ? 3.25 * (openPrompts ? 2 : 1)
                                                                                     : K.isPad()  ?  2.5 * (openPrompts ? 2 : 1)
                                                                                       : 4.5 * (openPrompts ? 3.5 : 1) ) ) + (viewRouter.currentPage == .finished ? -60 : 0))
                                                : geometry.size.height) - (isKeyboardVisible ? geometry.size.height * 0.12 : 0))
                            }
                        }
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                    }.navigationViewStyle(StackNavigationViewStyle())
                }

                // Splash
                ZStack {
                    Clr.darkWhite
                    VStack {
                        Img.coloredPots
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                            .scaleEffect(animationAmount)
                            .opacity(Double(2 - animationAmount))
                            .animation(
                                Animation.easeOut(duration: 2.0)
                            )
                    }
                }.edgesIgnoringSafeArea(.all)
                    .animation(.default, value: showSplash)
                    .opacity(showSplash ? 1 : 0)
            }
        }
        .sheet(isPresented: $showRecs) {
            if !isOnboarding {
                let meditations = Meditation.getRecsFromMood()
                ShowRecsScene(mood: selectedMood, meditations: meditations)
            }
        }
        .onAppear {
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    hasConnection  = true
                } else {
                    hasConnection = false
                }
            }
            let queue = DispatchQueue(label: "Monitor")
            monitor.start(queue: queue)
            animationAmount = 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSplash.toggle()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.gratitude))
               { _ in addGratitude = true }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.mood))
                      { _ in addMood = true }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.pro))
        { _ in
            fromPage = "widget"
            viewRouter.currentPage = .pricing}
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.meditate))
        { _ in
            if let defaultRecents = UserDefaults.standard.value(forKey: "recent") as? [Int] {
                meditationModel.selectedMeditation = Meditation.allMeditations.filter({ med in defaultRecents.contains(med.id) }).reversed()[0]
            } else {
                meditationModel.selectedMeditation = meditationModel.featuredMeditation
            }

            if meditationModel.selectedMeditation?.type == .course {
                viewRouter.currentPage = .middle
            } else {
                viewRouter.currentPage = .play
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.garden)) { _ in
            viewRouter.currentPage = .garden
        }


    }
    ///Ashvin : Show popup with animation method

    public func showPopupWithAnimation(completion: @escaping () -> ()) {
        withAnimation(.easeIn(duration:0.14)){
            showPopUp = true
        }
        withAnimation(.easeIn(duration: 0.08).delay(0.14)) {
            PopUpIn = true
        }
        withAnimation(.easeIn(duration: 0.14).delay(0.22)) {
            showPopUpOption = true
        }
        withAnimation(.easeIn(duration: 0.4).delay(0.36)) {
            showItems = true
            completion()
        }
    }

    ///Ashvin : Hide popup with animation method

    public func hidePopupWithAnimation(completion: @escaping () -> ()) {
        withAnimation(.easeOut(duration: 0.2)) {
            showItems = false
        }
        withAnimation(.easeOut(duration: 0.14).delay(0.1)) {
            showPopUpOption = false
        }
        withAnimation(.easeOut(duration: 0.08).delay(0.24)) {
            PopUpIn = false
        }
        withAnimation(.easeOut(duration: 0.14).delay(0.31)){
            showPopUp = false
            completion()
        }
    }
    
    private func setSelectedPopupOption(selectedOption:PlusMenuType){
        switch selectedOption {
        case .moodCheck:
            selectedPopupOption = .none
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if UserDefaults.standard.integer(forKey: "numMoods") >= 30 && !UserDefaults.standard.bool(forKey: "isPro") {
                withAnimation {
                    Analytics.shared.log(event: .plus_tapped_mood_to_pricing)
                    fromPage = "plusMood"
                    viewRouter.currentPage = .pricing
                }
            } else {
                Analytics.shared.log(event: .plus_tapped_mood)
                if isOnboarding {
                    Analytics.shared.log(event: .onboarding_finished_mood)
                }
                withAnimation {

                    ///Ashvin : Hide popup with animation
                    hidePopupWithAnimation {
                        addMood = true
                    }
                }
            }
        case .gratitude:
            selectedPopupOption = .none
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
                    Analytics.shared.log(event: .onboarding_finished_gratitude)
                }
                withAnimation {
                    ///Ashvin : Hide popup with animation
                    hidePopupWithAnimation {
                        addGratitude = true
                    }
                }
            }
        case .meditate:
            selectedPopupOption = .none
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if UserDefaults.standard.integer(forKey: "numMeds") >= 30 && !UserDefaults.standard.bool(forKey: "isPro") {
                withAnimation {
                    fromPage = "plusMeditation"
                    viewRouter.currentPage = .pricing
                }
            } else {
                Analytics.shared.log(event: .plus_tapped_meditate)
                if isOnboarding {
                    Analytics.shared.log(event: .onboarding_finished_meditation)
                }
                withAnimation {
                    // Hide popup with animation
                    hidePopupWithAnimation {
                        showPopUp = false
                    }
                }

                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                    Analytics.shared.log(event: .onboarding_finished_gratitude)
                    meditationModel.selectedMeditation = Meditation.allMeditations.first(where: { med in
                        med.id == 22
                    })
                    viewRouter.currentPage = .play
                } else {
                    if let defaultRecents = UserDefaults.standard.value(forKey: "recent") as? [Int] {
                        meditationModel.selectedMeditation = Meditation.allMeditations.filter({ med in defaultRecents.contains(med.id) }).reversed()[0]
                    } else {
                        meditationModel.selectedMeditation = meditationModel.featuredMeditation
                    }

                    if meditationModel.selectedMeditation?.type == .course {
                        viewRouter.currentPage = .middle
                    } else {
                        viewRouter.currentPage = .play
                    }
                }
            }
        case .none:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bonusModel: BonusViewModel(userModel: UserViewModel()), profileModel: ProfileViewModel(), authModel: AuthenticationViewModel(userModel: UserViewModel(), viewRouter: ViewRouter()))
    }
}

extension NSNotification {
    static let gratitude = Notification.Name.init("gratitude")
    static let meditate = Notification.Name.init("meditate")
    static let mood = Notification.Name.init("mood")
    static let pro = Notification.Name.init("pro")
    static let garden = Notification.Name.init("garden")
    static let runCounter = Notification.Name.init("runCounter")
}
