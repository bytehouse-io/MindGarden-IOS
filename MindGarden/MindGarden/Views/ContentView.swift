//
//  ContentView.swift
//  MindGarden
//
//  Created by Dante Kim on 5/25/21.
//

import Combine
import Lottie
import Network
import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
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
    /// Ashvin : State variable for pass animation flag
    @State private var PopUpIn = false
    @State private var showPopUpOption = false
    @State private var showItems = false
    @ObservedObject var bonusModel: BonusViewModel
    @ObservedObject var profileModel: ProfileViewModel
    @State var hasConnection = false
    @State var playAnim = false
    @State var selectedTab: TabType = .meditate
    @State var selectedPopupOption: PlusMenuType = .none
    @State private var showSplash = true
    @State private var goShinny = false
    @State private var progressWidth = 0.0
    @State var offset: CGSize = .zero
    
    var authModel: AuthenticationViewModel

    // a closure executed on onboarding's review completion.
    var onReviewCompletion: (() -> Void)? = nil

    init(bonusModel: BonusViewModel, profileModel: ProfileViewModel, authModel: AuthenticationViewModel, onReviewCompletion: (() -> Void)? = nil) {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        self.bonusModel = bonusModel
        self.profileModel = profileModel
        self.authModel = authModel
        self.onReviewCompletion = onReviewCompletion
        //        meditationModel.isOpenEnded = false
        //        meditationModel.secondsRemaining = 150
        // check for auth here
    }

    // MARK: - Body
    
    var body: some View {
        VStack {
            if showSplash {
                SplashView()
                    .ignoresSafeArea()
                    .transition(.scaledCircle)
                    .animation(.linear(duration: 0.5))
            } else {
                // Content
                ZStack {
                    GeometryReader { geometry in
                        ZStack {
                            Clr.darkWhite.edgesIgnoringSafeArea(.all)
                            
                            Rectangle()
                                .fill(Color.gray)
                                .zIndex(100)
                                .frame(width: geometry.size.width, height: hasConnection ? 0 : 60)
                                .overlay(
                                    VStack {
                                        Spacer()
                                        Text("You're offline. Data will not be saved.")
                                            .font(Font.fredoka(.medium, size: 14))
                                            .foregroundColor(.white)
                                            .opacity(hasConnection ? 0 : 1)
                                    } //: VStack
                                    .frame(height: hasConnection ? 0 : 50)
                                )
                                .offset(y: -18)
                                .position(x: geometry.size.width / 2, y: 0)
                            
                            VStack {
                                if #available(iOS 14.0, *) {
                                    switch viewRouter.currentPage {
                                    case .onboarding:
                                        OnboardingScene()
                                            .environmentObject(authModel)
                                    case .experience:
                                        ExperienceScene()
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .meditate:
                                        Home()
                                            .navigationViewStyle(StackNavigationViewStyle())
//                                            .disabled(isOnboarding)
                                            .environmentObject(profileModel)
                                            .environmentObject(bonusModel)
                                            .environmentObject(authModel)
                                            .onAppear {
                                                let onboarding = DefaultsManager.standard.value(forKey: .onboarding).onboardingValue
                                                if onboarding == .signedUp {
                                                    withAnimation {
                                                        self.isOnboarding = true
                                                        addMood = true
                                                    }
                                                } else if onboarding == .mood {
                                                    self.isOnboarding = true
                                                    moodFromFinished = false
                                                    viewRouter.currentPage = .journal
                                                    if let mood = DefaultsManager.standard.value(forKey: .selectedMood).string {
                                                        userModel.selectedMood = Mood.getMood(str: mood)
                                                        if let elab = DefaultsManager.standard.value(forKey: .elaboration).string {
                                                            userModel.elaboration = elab
                                                        }
                                                        moodFirst = true
                                                    }
                                                }
                                            }
                                    case .garden:
                                        Garden()
                                            .frame(height: geometry.size.height - 50)
                                            .onAppear {
                                                showPopUpOption = false
                                                showItems = false
                                            }
                                            .environmentObject(bonusModel)
                                            .environmentObject(profileModel)
                                            .offset(y: K.hasNotch() ? -70 : -20)
                                    case .shop:
                                        Store()
                                            .frame(height: geometry.size.height + 10)
                                            .environmentObject(bonusModel)
                                            .environmentObject(profileModel)
                                            .environmentObject(userModel)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .learn:
                                        DiscoverScene(selectedTab: .learn)
                                            .environmentObject(bonusModel)
                                            .environmentObject(userModel)
                                    case .journey:
                                        DiscoverScene(selectedTab: .journey)
                                            .environmentObject(bonusModel)
                                            .environmentObject(userModel)
                                    case .quickStart:
                                        DiscoverScene(selectedTab: .quickStart)
                                            .environmentObject(bonusModel)
                                            .environmentObject(userModel)
                                    case .categories(let incomingCase):
                                        CategoriesScene(showSearch: .constant(false), isBack: .constant(false), incomingCase: incomingCase)
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .middle(let incomingCase):
                                        MiddleSelect(incomingCase: incomingCase)
                                            .frame(height: geometry.size.height + 10)
                                    case .breathMiddle:
                                        BreathMiddle()
                                    case .play:
                                        Play()
                                            .frame(height: geometry.size.height + 80)
                                            .onAppear {
                                                let onboarding = DefaultsManager.standard.value(forKey: .onboarding).onboardingValue
                                                if onboarding == .gratitude {
                                                    self.isOnboarding = false
                                                }
                                            }
                                    case .mood:
                                        MoodElaborate()
                                    case .journal:
                                        JournalView()
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .environmentObject(userModel)
                                            .environmentObject(gardenModel)
                                    case .finished:
                                        Finished(bonusModel: bonusModel, model: meditationModel, userModel: userModel, gardenModel: gardenModel)
                                            .frame(height: geometry.size.height + 160)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .environmentObject(bonusModel)
                                            .environmentObject(viewRouter)
                                    case .meditationCompleted:
                                        MeditationCompleted(
                                            model: meditationModel,
                                            userModel: userModel,
                                            gardenModel: gardenModel,
                                            bonusModel: bonusModel,
                                            onDismiss: .finished
                                        )
                                        .frame(height: geometry.size.height)
                                        .navigationViewStyle(StackNavigationViewStyle())
                                        .navigationViewStyle(StackNavigationViewStyle())
                                        .environmentObject(bonusModel)
                                        .environmentObject(viewRouter)
                                    case .congratulationsOnCompletion:
                                        CongratulationsOnCompletion(
                                            model: meditationModel,
                                            userModel: userModel,
                                            gardenModel: gardenModel,
                                            bonusModel: bonusModel,
                                            onDismiss: .garden
                                        )
                                        .frame(height: geometry.size.height)
                                        .navigationViewStyle(StackNavigationViewStyle())
                                        .environmentObject(viewRouter)
                                    
                                    case .authentication:
                                        NewAuthentication(viewModel: authModel)
                                            .frame(height: geometry.size.height)
                                            .ignoresSafeArea()
                                            .navigationViewStyle(StackNavigationViewStyle())
                                        //                                            .environmentObject(bonusModel)
                                    case .notification:
                                        NotificationScene()
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .name:
                                        NameScene(onReviewCompletion: onReviewCompletion)
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .pricing:
//                                        PricingView()
                                        PricingMainView()
                                            .environmentObject(viewRouter)
                                            .frame(height: geometry.size.height + 80)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .environmentObject(userModel)
                                            .environmentObject(meditationModel)
                                            .environmentObject(viewRouter)
                                    case .reason:
                                        ReasonScene()
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .meditationGoal:
                                        MeditationGoalView()
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .review:
                                        ReviewScene(onReviewCompletion: onReviewCompletion)
                                            .frame(height: geometry.size.height - (!K.hasNotch() ? 40 : 0))
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    }
                                }
                                
                                // MARK: - onboarding progress indicator
                                
                                if viewRouter.currentPage == .notification || viewRouter.currentPage == .experience || viewRouter.currentPage == .name || viewRouter.currentPage == .reason || viewRouter.currentPage == .review || viewRouter.currentPage == .meditationGoal {
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(width: geometry.size.width * 0.8, height: 20)
                                            .opacity(0.3)
                                            .foregroundColor(Clr.darkWhite)
                                        Rectangle()
                                            .frame(width: progressWidth, height: 20)
                                            .foregroundColor(Clr.brightGreen)
                                            .animation(.linear, value: progressWidth)
                                            .neoShadow()
                                        Rectangle()
                                            .frame(width: progressWidth, height: 20)
                                            .foregroundColor(.white.opacity(0.6))
                                            .animation(.linear, value: progressWidth)
                                            .mask(
                                                Capsule()
                                                    .fill(LinearGradient(gradient: .init(colors: [.clear, .white, .clear]), startPoint: .top, endPoint: .bottom))
                                                    .rotationEffect(.init(degrees: 90))
                                                    .offset(x: goShinny ? progressWidth : -progressWidth)
                                            )
                                            .onChange(of: viewRouter.progressValue) { _ in
                                                self.goShinny = false
                                                let duration = progressWidth * 0.005
                                                DispatchQueue.main.asyncAfter(deadline: .now() + duration / 2) {
                                                    progressWidth = min(CGFloat(viewRouter.progressValue) * (geometry.size.width * 0.8), geometry.size.width * 0.8)
                                                }
                                                withAnimation(.easeOut(duration: duration)) {
                                                    self.goShinny = true
                                                }
                                            }
                                            .onAppear {
                                                progressWidth = min(CGFloat(viewRouter.progressValue) * (geometry.size.width * 0.8), geometry.size.width * 0.8)
                                            }
                                    } //: ZStack
                                    .cornerRadius(45.0)
                                    .padding()
                                    .oldShadow()
                                }
                            } //: VStack
                            .edgesIgnoringSafeArea(.all)
                            let onboardingValue = DefaultsManager.standard.value(forKey: .onboarding).onboardingValue
                            if viewRouter.currentPage == .meditate || viewRouter.currentPage == .garden || viewRouter.currentPage == .categories(incomingCase: .home) || viewRouter.currentPage == .categories(incomingCase: .quickStart) || viewRouter.currentPage == .categories(incomingCase: .journey) || viewRouter.currentPage == .categories(incomingCase: .discover) || viewRouter.currentPage == .learn || viewRouter.currentPage == .quickStart || viewRouter.currentPage == .journey || viewRouter.currentPage == .shop
//                                || (viewRouter.currentPage == .finished && onboardingValue != .meditate && onboardingValue != .gratitude)
                            {
                                ZStack {
                                    Rectangle()
                                        .opacity(addMood || addGratitude ||
//                                                 isOnboarding ||
                                                 userModel.showDay1Complete || profileModel.showWidget || userModel.showCoinAnimation ? 0.3 : 0.0)
                                        .foregroundColor(Clr.black1)
                                        .edgesIgnoringSafeArea(.all)
                                        .frame(height: geometry.size.height + (viewRouter.currentPage == .finished ? 160 : 10))
                                        .transition(.opacity)
                                } //: ZStack
                                .onTapGesture {
                                    withAnimation {
                                        hidePopupWithAnimation {
                                            let onboardingValue = DefaultsManager.standard.value(forKey: .onboarding).onboardingValue
                                            if onboardingValue != .signedUp
//                                                UserDefaults.standard.string(forKey: K.defaults.onboarding) != "signedUp"
                                            {
                                                addMood = false
                                            }
                                            addGratitude = false
                                            if profileModel.showWidget {
                                                profileModel.showWidget = false
                                                DefaultsManager.standard.set(value: true, forKey: .showWidget)
//                                                DefaultsManager.standard.set(value: true, forKey: "showWidget")
                                            }
                                        }
                                    }
                                }
                                
                                ZStack {
                                    HomeTabView(selectedOption: $selectedPopupOption, viewRouter: viewRouter, selectedTab: $selectedTab, showPopup: $showPopUp, isOnboarding: $isOnboarding)
                                        .onChange(of: selectedPopupOption) { value in
                                            setSelectedPopupOption(selectedOption: value)
                                        }
                                } //: ZStack
                                .offset(y: 16)
                                
                                MoodCheck(shown: $addMood, showPopUp: $showPopUp, PopUpIn: $PopUpIn, showPopUpOption: $showPopUpOption, showItems: $showItems)
                                    .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                                    .background(Clr.darkWhite)
                                    .cornerRadius(32)
                                    .offset(y: addMood ? (geometry.size.height / (K.hasNotch() ? 2.75 : 3) + (viewRouter.currentPage == .finished ? -75 : 0)) : geometry.size.height)
                                
                                WidgetPrompt(profileModel: profileModel)
                                    .offset(y: profileModel.showWidget ? 0 : geometry.size.height + 75)
                                    .animation(.default, value: profileModel.showWidget)
                                
                                BottomSheet(
                                    isOpen: $userModel.showDay1Complete,
                                    maxHeight: geometry.size.height * (K.isSmall() ? 1 : 0.75),
                                    minHeight: 0.1,
                                    trigger: {
                                        DefaultsManager.standard.set(value: true, forKey: .fiveHundredBonus)
//                                        DefaultsManager.standard.set(value: true, forKey: "500bonus")
                                        // Analytics.shared.log(event: .home_tapped_see_you_tomorrow)
                                        bonusModel.tripleBonus()
                                    }
                                ) {
                                    VStack {
                                        Img.completeRacoon
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 200)
                                        HStack(alignment: .center) {
                                            Img.coin
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30)
                                            Text("500 Bonus Coins")
                                                .font(Font.fredoka(.bold, size: 32))
                                                .foregroundColor(Clr.darkgreen)
                                        }
                                        Text("You're a rockstar! That's \neverything for today")
                                            .font(Font.fredoka(.medium, size: 20))
                                            .foregroundColor(Clr.black2)
                                            .multilineTextAlignment(.center)
                                            .frame(height: 50)
                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            withAnimation {
                                                // Analytics.shared.log(event: .home_tapped_see_you_tomorrow)
                                                DefaultsManager.standard.set(value: true, forKey: .fiveHundredBonus)
                                                userModel.showDay1Complete = false
                                                bonusModel.tripleBonus()
                                            }
                                        } label: {
                                            Capsule()
                                                .fill(Clr.darkgreen)
                                                .overlay(
                                                    Text("Keep exploring your mindgarden")
                                                        .font(Font.fredoka(.bold, size: 20))
                                                        .foregroundColor(.white)
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.1)
                                                )
                                        } //: Button
                                        .buttonStyle(NeumorphicPress())
                                        .frame(height: 45)
                                        .padding(.top, 32)
                                    } //: VStack
                                    .frame(width: geometry.size.width * 0.8, alignment: .center)
                                    .offset(y: -25)
                                    .padding()
                                } //: BottomSheet
                                .offset(y: geometry.size.height * 0.1)
                                
                                BottomSheet(
                                    isOpen: $userModel.showCoinAnimation,
                                    maxHeight: geometry.size.height * (K.isSmall() ? 0.75 : 0.6),
                                    minHeight: 0.1,
                                    trigger: {}
                                ) {
                                    VStack {
                                        Img.tripleCoins
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 100)
                                        Text("Thanks for Referring 🤝")
                                            .font(Font.fredoka(.bold, size: 28))
                                            .foregroundColor(Clr.darkgreen)
                                            .padding(.bottom, -5)
                                        Text("You just got 500 coins!")
                                            .font(Font.fredoka(.medium, size: 20))
                                            .foregroundColor(Clr.black2)
                                            .multilineTextAlignment(.center)
                                            .frame(height: 50)
                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            withAnimation {
                                                userModel.showCoinAnimation = false
                                                // Analytics.shared.log(event: .onboarding_finished_single_course)
                                            }
                                        } label: {
                                            Capsule()
                                                .fill(Clr.darkgreen)
                                                .overlay(
                                                    Text("Cool beans 👌")
                                                        .font(Font.fredoka(.bold, size: 18))
                                                        .foregroundColor(.white)
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                )
                                            
                                        }
                                        .buttonStyle(NeumorphicPress())
                                        .frame(height: 45)
                                        .padding(.vertical, 25)
                                    } //: VStack
                                    .frame(width: geometry.size.width * 0.85, alignment: .center)
                                    .padding()
                                } //: BottomSheet
                                .offset(y: geometry.size.height * 0.1)
                            }
                        } //: ZStack
                        .navigationViewStyle(StackNavigationViewStyle())
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                    } //: GeometryReader
                } //: ZStack
            }
        } //: VStack
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                withAnimation(.linear(duration: 0.5)) {
                    showSplash.toggle()
                }
            }
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    hasConnection = true
                } else {
                    hasConnection = false
                }
            }
            let queue = DispatchQueue(label: "Monitor")
            monitor.start(queue: queue)
        }
        .onChange(of: viewRouter.currentPage) { _ in
            if viewRouter.currentPage == .garden && selectedTab != .garden {
                selectedTab = .garden
            } else if viewRouter.currentPage == .meditate && selectedTab != .meditate {
                selectedTab = .meditate
            } else if viewRouter.currentPage == .learn && selectedTab != .search {
                selectedTab = .search
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .gratitude)) { _ in
            withAnimation {
                // Analytics.shared.log(event: .widget_tapped_journal)
                viewRouter.currentPage = .journal
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .mood)) { _ in
            // Analytics.shared.log(event: .widget_tapped_meditate)
            withAnimation {
                addMood = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .pro)) { _ in
            fromPage = "widget"
            viewRouter.currentPage = .pricing
        }
        .onReceive(NotificationCenter.default.publisher(for: .meditate)) { _ in
            // Analytics.shared.log(event: .widget_tapped_meditate)
            selectedTab = .search
            viewRouter.currentPage = .learn
        }
        .onReceive(NotificationCenter.default.publisher(for: .garden)) { _ in
            selectedTab = .garden
            viewRouter.currentPage = .garden
        }
        .onReceive(NotificationCenter.default.publisher(for: .trees)) { _ in
            withAnimation {
                selectedTab = .shop
                swipedTrees = true
                viewRouter.currentPage = .shop
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .store)) { _ in
            selectedTab = .shop
            viewRouter.currentPage = .shop
        }
        .onReceive(NotificationCenter.default.publisher(for: .breathwork))
        { _ in
            withAnimation {
                // Analytics.shared.log(event: .widget_tapped_breathwork)
                middleToSearch = "Breathwork"
                selectedTab = .search
                viewRouter.currentPage = .learn
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .learn)) { _ in
            learnNotif = true
            selectedTab = .search
            viewRouter.currentPage = .learn
        }
    }

    /// Ashvin : Show popup with animation method

    public func showPopupWithAnimation(completion: @escaping () -> Void) {
        withAnimation(.easeIn(duration: 0.14)) {
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

    /// Ashvin : Hide popup with animation method

    public func hidePopupWithAnimation(completion: @escaping () -> Void) {
        withAnimation(.easeOut(duration: 0.2)) {
            showItems = false
        }

        withAnimation(.easeOut(duration: 0.14).delay(0.1)) {
            showPopUpOption = false
        }

        withAnimation(.easeOut(duration: 0.08).delay(0.24)) {
            PopUpIn = false
        }

        withAnimation(.easeOut(duration: 0.14).delay(0.31)) {
            showPopUp = false
            completion()
        }
    }

    private func setSelectedPopupOption(selectedOption: PlusMenuType) {
        switch selectedOption {
        case .moodCheck:
            selectedPopupOption = .none
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            // Analytics.shared.log(event: .plus_tapped_mood)
            if isOnboarding {
                // Analytics.shared.log(event: .onboarding_finished_mood)
            }

            withAnimation {
                /// Ashvin : Hide popup with animation
                hidePopupWithAnimation {
                    addMood = true
                }
            }

        case .gratitude:
            selectedPopupOption = .none
            UIImpactFeedbackGenerator(style: .light).impactOccurred()

            // Analytics.shared.log(event: .plus_tapped_gratitude)

            if isOnboarding {
                // Analytics.shared.log(event: .onboarding_finished_gratitude)
            }

            withAnimation(.easeOut(duration: 0.4)) {
                /// Ashvin : Hide popup with animation
                viewRouter.currentPage = .journal
            }

        case .meditate:
            selectedPopupOption = .none
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            // Analytics.shared.log(event: .plus_tapped_meditate)
            if isOnboarding {
                // Analytics.shared.log(event: .onboarding_finished_meditation)
            }
            withAnimation {
                // Hide popup with animation
                hidePopupWithAnimation {
                    showPopUp = false
                }
            }

            if
                DefaultsManager.standard.value(forKey: .onboarding).onboardingValue == .gratitude
//                UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude"
            {
                // Analytics.shared.log(event: .onboarding_finished_gratitude)
                withAnimation {
                    meditationModel.selectedMeditation = Meditation.allMeditations.first(where: { med in
                        med.id == 22
                    })
                    viewRouter.previousPage = .meditate
                    viewRouter.currentPage = .play
                }
            } else {
                withAnimation {
                    selectedTab = .search
                }
            }

        case .none:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bonusModel: BonusViewModel(userModel: UserViewModel(), gardenModel: GardenViewModel()), profileModel: ProfileViewModel(), authModel: AuthenticationViewModel(userModel: UserViewModel(), viewRouter: ViewRouter()))
    }
}

extension NSNotification.Name {
    static let gratitude = Notification.Name("gratitude")
    static let meditate = Notification.Name("meditate")
    static let mood = Notification.Name("mood")
    static let pro = Notification.Name("pro")
    static let garden = Notification.Name("garden")
    static let runCounter = Notification.Name("runCounter")
    static let trees = Notification.Name("trees")
    static let store = Notification.Name("store")
    static let breathwork = Notification.Name("breathwork")
    static let learn = Notification.Name("learn")
    static let intro = Notification.Name("intro")
    static let widget = Notification.Name("widget")
    static let referrals = Notification.Name("referrals")
    static let storyOnboarding = Notification.Name("storyOnboarding")
    static let notification = Notification.Name("notification")
    static let updateStart = Notification.Name("updateStart")
    static let finish = NSNotification.Name("Finish")
//    static let storyOnboarding =
//    static let storyOnboarding =
}
