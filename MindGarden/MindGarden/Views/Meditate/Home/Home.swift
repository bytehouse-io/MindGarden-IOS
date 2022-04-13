//
//  Home.swift
//  MindGarden
//
//  Created by Dante Kim on 6/11/21.
//

import SwiftUI
import FirebaseAuth
import StoreKit
import Purchases
import Firebase
import FirebaseFirestore
import AppsFlyerLib
import Paywall

var launchedApp = false
struct Home: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    @State private var isRecent = true
    @State private var showModal = false
    @State private var showSearch = false
    @State private var showUpdateModal = false
    @State private var showMiddleModal = false
    @State private var showIAP = false
    @State private var wentPro = false
    @State private var ios14 = true
    @State private var coins = 0
    @State private var attempts = 0
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    
    enum Sheet: Identifiable {
        case profile, plant, search
        var id: Int {
            hashValue
        }
    }
    @State var activeSheet: Sheet?

    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                GeometryReader { g in
                    let width = g.size.width
                    let height = g.size.height
                    VStack {
                    ZStack {
                        Img.yellowBubble
                            .resizable()
                            .frame(width: width + 25, height: height * 0.4)
                            .oldShadow()
                            .offset(x: -10)
                            HStack {
                                Img.topBranch.offset(x: 40,  y: height * -0.1)
                                Spacer()
                                VStack {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(.system(size: 22))
                                            .onTapGesture {
                                                Analytics.shared.log(event: .home_tapped_search)
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                showSearch = true
                                                activeSheet = .search
                                            }
                                        Image(systemName: "person.fill")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(.system(size: 22))
                                            .onTapGesture {
                                                Analytics.shared.log(event: .home_tapped_search)
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                activeSheet = .profile
                                            }
                                    }.offset(x: 15, y: -25)
                          
                                    HStack{
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            Text("\(userModel.greeting), \(userModel.name)")
                                                .font(Font.mada(.bold, size: 25))
                                                .foregroundColor(colorScheme == .dark ? .black : Clr.black1)
                                                .fontWeight(.bold)
                                                .padding(.trailing, 20)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                            HStack {
                                                Img.streak
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(height: 25)
                                                    .oldShadow()
                                                Text("Streak: ")
                                                    .foregroundColor(colorScheme == .dark ? .black : Clr.black1)
                                                    .font(Font.mada(.medium, size: 21))
                                                + Text("\(bonusModel.streakNumber)")
                                                    .font(Font.mada(.semiBold, size: 22))
                                                    .foregroundColor(Clr.darkgreen)
                                                PlusCoins()
                                                    .onTapGesture {
                                                        Analytics.shared.log(event: .home_tapped_IAP)
                                                        withAnimation { showIAP.toggle() }
                                                    }
                                            }.padding(.trailing, 20)
                                                .padding(.top, -10)
                                                .padding(.bottom, 10)
                                        }
                                    }.offset(x: -width * 0.25, y: -10)
                                }.frame(width: width * 0.8)
                            }
                        }.frame(width: width)
                        .offset(y: -height * 0.1)
                        //MARK: - scroll view
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .cornerRadius(14)
                                        .frame(height: 120, alignment: .center)
                                        .oldShadow()
                                    Stories()
                                        .padding(.horizontal, 15)
                                        .padding(.top)
                                }.frame(width: g.size.width * 0.85, height: 120, alignment: .center)
                              
                                
                                HStack(spacing: width * 0.04) {
                                    Button {
                                        Analytics.shared.log(event: .home_tapped_bonus)
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        withAnimation {
                                            DispatchQueue.main.async {
                                                showModal = true
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            if bonusModel.totalBonuses == 0 {
                                                Img.coin
                                                    .font(.system(size: 22))
                                            } else {
                                                ZStack {
                                                    Circle().frame(height: 16)
                                                        .foregroundColor(Clr.redGradientBottom)
                                                    Text("\(bonusModel.totalBonuses)")
                                                        .font(Font.mada(.bold, size: 12))
                                                        .foregroundColor(.white)
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.005)
                                                        .frame(width: 10)
                                                }.frame(width: 15)
                                            }
                                            Text("Daily Bonus")
                                                .font(Font.mada(.regular, size: 16))
                                                .foregroundColor(.black)
                                                .font(.footnote)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                        }
                                        .frame(width: g.size.width * 0.35, height: 20)
                                        .padding(8)
                                        .background(Clr.yellow)
                                        .cornerRadius(20)
                                        .modifier(Shake(animatableData: CGFloat(attempts)))
                                    }
                                    .buttonStyle(BonusPress())
                                    Button {
                                        Analytics.shared.log(event: .home_tapped_plant_select)
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        activeSheet = .plant
                                    } label: {
                                        HStack {
                                            userModel.selectedPlant?.head
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                            Text("Plant Select")
                                                .font(Font.mada(.regular, size: 16))
                                                .foregroundColor(.black)
                                                .font(.footnote)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                        }
                                        .frame(width: g.size.width * 0.35, height: 20)
                                        .padding(8)
                                        .background(Clr.yellow)
                                        .cornerRadius(20)
                                    }
                                    .buttonStyle(BonusPress())
                                }.padding(.top, 15)
                            }
                                Button {} label: {
                                    Rectangle()
                                        .fill(Color("darkWhite"))
                                        .border(Clr.darkWhite)
                                        .cornerRadius(25)
                                        .frame(width: g.size.width * 0.85, height: g.size.height * 0.275, alignment: .center)
                                        .overlay(
                                            HStack(alignment: .top) {
                                                VStack(alignment: .leading) {
                                                    Text("Featured")
                                                        .font(Font.mada(.regular, size: K.isPad() ? 30 : 18))
                                                        .foregroundColor(Clr.black1)
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.05)
                                                    Text("\(model.featuredMeditation?.title ?? "")")
                                                        .font(Font.mada(.bold, size: K.isPad() ? 40 : 26))
                                                        .foregroundColor(Clr.black1)
                                                        .lineLimit(3)
                                                        .minimumScaleFactor(0.05)
                                                    if model.featuredMeditation?.type == .course && model.featuredMeditation?.id != 57 && model.featuredMeditation?.id != 2 {
                                                        Text("7 Day Course")
                                                            .font(Font.mada(.regular, size: K.isPad() ? 26 : 16))
                                                            .foregroundColor(Color.gray)
                                                    }
                                                    Spacer()
                                                }
                                                .frame(width: UIScreen.main.bounds.width * 0.65 * 0.525)
                                                .position(x: UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.85 + 25, y: g.size.height * 0.21)
                                                VStack(spacing: 0) {
                                                    ZStack {
                                                        Circle().frame(width: g.size.width * 0.15, height:  g.size.width * 0.15)
                                                            .foregroundColor(Clr.brightGreen)
                                                            .rightShadow()
                                                        Image(systemName: "play.fill")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: K.isPad() ? 50 : 26))
                                                    }.offset(x: 35, y: K.isPad() ? 45 : 25)
                                                        .padding([.top, .leading])
                                                        .zIndex(100)
                                                    if model.featuredMeditation?.imgURL != "" {
                                                        UrlImageView(urlString: model.featuredMeditation?.imgURL)
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: UIScreen.main.bounds.width * 0.80 * 0.5, height: g.size.height * 0.2)
                                                            .offset(x: K.isPad() ? -150 : -25, y: K.isPad() ? -40 : -25)
                                                    } else {
                                                        (model.featuredMeditation?.img ?? Img.daisy3)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: UIScreen.main.bounds.width * 0.80 * 0.5, height: g.size.height * 0.2)
                                                            .offset(x: K.isPad() ? -150 : -25, y: K.isPad() ? -40 : -25)
                                                    }
                                                      
                                                }.padding([.top, .bottom, .trailing])
                                            }.onTapGesture {
                                                Analytics.shared.log(event: .home_tapped_featured)
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                withAnimation {
                                                    DispatchQueue.main.async {
                                                        onboardingTime = false
                                                        model.selectedMeditation = model.featuredMeditation
                                                        if model.featuredMeditation?.type == .course {
                                                            viewRouter.currentPage = .middle
                                                        } else {
                                                            viewRouter.currentPage = .play
                                                        }
                                                    }
                                                }
                                            }
                                        ).padding(.top, K.isSmall() ? 10 : 20)
                                        .wiggling()
                                }.buttonStyle(BonusPress())
                                HStack {
                                    VStack(spacing: 1) {
                                        HStack {
                                            Button {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                Analytics.shared.log(event: .home_tapped_recents)
                                                withAnimation {
                                                    DispatchQueue.main.async {
                                                        isRecent = true
                                                    }
                                                }
                                            } label: {
                                                Text("Recent")
                                                    .foregroundColor(isRecent ? Clr.darkgreen : Clr.black2)
                                                    .font(Font.mada(.regular, size:  sizeCategory > .large ? 14 : 20))
                                            }
                                            Button {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                Analytics.shared.log(event: .home_tapped_favorites)
                                                withAnimation {
                                                    DispatchQueue.main.async {
                                                        isRecent = false
                                                    }
                                                }
                                            } label: {
                                                Text("Favorites")
                                                    .foregroundColor(isRecent ? Clr.black2 : Clr.darkgreen)
                                                    .font(Font.mada(.regular, size: sizeCategory > .large ? 14 : 20))
                                            }
                                        }
                                        Rectangle().frame(width: isRecent ? CGFloat(45) : 65.0, height: 1.5)
                                            .foregroundColor(Clr.darkgreen)
                                            .offset(x: isRecent ? -42.0 : 33.0)
                                            .animation(.default, value: isRecent)
                                    }
                                    Spacer()
//                                    if !UserDefaults.standard.bool(forKey: "isPro") {
//                                        Button { } label: {
//                                            HStack {
//                                                Text("💚 Go Pro!")
//                                                    .font(Font.mada(.semiBold, size: 14))
//                                                    .foregroundColor(Clr.darkgreen)
//                                                    .font(.footnote)
//                                                    .lineLimit(1)
//                                                    .minimumScaleFactor(0.05)
//                                            }
//                                            .frame(width: UIScreen.main.bounds.width * 0.2, height: 18)
//                                            .padding(8)
//                                            .background(Clr.darkWhite)
//                                            .cornerRadius(25)
//                                            .onTapGesture {
//                                                Analytics.shared.log(event: .home_tapped_pro)
//                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                                                withAnimation {
//                                                    fromPage = "home"
//                                                    viewRouter.currentPage = .pricing
//                                                }
//                                            }
//                                        }
//                                        .buttonStyle(NeumorphicPress())
//                                    }
                                }.frame(width: abs(g.size.width * 0.825), alignment: .leading)
                                .padding(.top, 20)
                                ScrollView(.horizontal, showsIndicators: false, content: {
                                    HStack(spacing: 15) {
                                        if model.favoritedMeditations.isEmpty && !isRecent {
                                            Spacer()
                                            Text("No Favorited Meditations")
                                                .font(Font.mada(.semiBold, size: 20))
                                                .foregroundColor(Color.gray)
                                            Spacer()
                                        } else if gardenModel.recentMeditations.isEmpty && isRecent {
                                            Spacer()
                                            Text("No Recent Meditations")
                                                .font(Font.mada(.semiBold, size: 20))
                                                .foregroundColor(Color.gray)
                                            Spacer()
                                        } else {
                                            ForEach(isRecent ? gardenModel.recentMeditations : model.favoritedMeditations, id: \.self) { meditation in
                                                Button { } label: {
                                                    HomeSquare(width: g.size.width, height: g.size.height  - (height * 0.15), img: meditation.img, title: meditation.title, id: meditation.id, instructor: meditation.instructor, duration: meditation.duration, imgURL: meditation.imgURL, isNew: meditation.isNew)
                                                        .onTapGesture {
                                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                            model.selectedMeditation = meditation
                                                            Analytics.shared.log(event: isRecent ? .home_tapped_recent_meditation : .home_tapped_favorite_meditation)
                                                            if meditation.type == .course  {
                                                                withAnimation {
                                                                    viewRouter.currentPage = .middle
                                                                }
                                                            } else {
                                                                viewRouter.currentPage = .play
                                                            }
                                                        }
                                                }.buttonStyle(BonusPress())
                                            }
                                        }
                                        if !isRecent && model.favoritedMeditations.count == 1 {
                                            Spacer()
                                        } else if isRecent && gardenModel.recentMeditations.count == 1 {
                                            Spacer()
                                        }
                                    }.frame(height: g.size.height * 0.2 + 15)
                                        .padding([.leading, .trailing], g.size.width * 0.07)
                                }).frame(width: g.size.width, height: g.size.height * 0.2, alignment: .center)
                                .padding(.top, 5)
                                if !UserDefaults.standard.bool(forKey: "isPro") && UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" {
                                Button {} label: {
                                    ZStack {
                                        Rectangle()
                                            .fill(Clr.darkWhite)
                                            .cornerRadius(16)
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Clr.darkgreen, lineWidth: 2)
                                        HStack {
                                            Spacer()
                                            Img.panda
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: g.size.height * 0.1)
                                            Spacer()
                                            VStack(alignment: .leading) {
                                                Spacer()
                                                Text("Start Free Trial")
                                                    .foregroundColor(Clr.black2)
                                                    .font(Font.mada(.bold, size: 20))
                                                Text("Join 1378 pro members who practice daily 💚")
                                                    .foregroundColor(Clr.black2)
                                                    .font(Font.mada(.medium, size: 14))
                                                Spacer()
                                            }.frame(width: g.size.width * 0.5)
                                            Spacer()
                                        }
                                    }.frame(width: g.size.width * 0.85, height: g.size.height * 0.125, alignment: .center)
                                    .onTapGesture {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        withAnimation {
                                            fromPage = "home"
                                            viewRouter.currentPage = .pricing
                                        }
                                    }
                                }.padding(.vertical)
                                .buttonStyle(BonusPress())
                               }
                                //MARK: - New Meds
                                Text("☀️ New Meditations")
                                    .font(Font.mada(.semiBold, size: 28))
                                    .foregroundColor(Clr.black2)
                                    .padding(.top, 56)
                                    .frame(width: abs(g.size.width * 0.825), alignment: .leading)
                                VStack {
                                    RecRow(width: UIScreen.main.bounds.width, meditation: model.weeklyMeditation ?? Meditation.allMeditations[0], meditationModel: model, viewRouter: viewRouter, isWeekly: true)
                                        .padding(.bottom)
                                        .offset(y: -10)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 15) {
                                            ForEach(model.newMeditations, id: \.self) { meditation in
                                                Button {} label: {
                                                    HomeSquare(width: g.size.width, height: g.size.height  - (height * 0.15), img: meditation.img, title: meditation.title, id: meditation.id, instructor: meditation.instructor, duration: meditation.duration, imgURL: meditation.imgURL, isNew: meditation.isNew)
                                                        .onTapGesture {
                                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                            model.selectedMeditation = meditation
                                                            Analytics.shared.log(event: .home_tapped_new_meditation)
                                                            model.selectedMeditation = meditation
                                                            if !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(meditation.id) {
                                                                withAnimation {
                                                                    fromPage = "lockedHome"
                                                                    Analytics.shared.log(event: .home_tapped_locked_meditation)
                                                                    viewRouter.currentPage = .pricing
                                                                }
                                                            } else {
                                                                if meditation.type == .course  {
                                                                    withAnimation {
                                                                        viewRouter.currentPage = .middle
                                                                    }
                                                                } else {
                                                                    withAnimation {
                                                                        showMiddleModal = true
                                                                    }
                                                                }
                                                            }
                                                        }
                                                }.buttonStyle(BonusPress())
                                            }
                                        }.frame(height: g.size.height * 0.2 + 15)
                                            .padding([.leading, .trailing], g.size.width * 0.07)
                                    }.frame(width: g.size.width, height: g.size.height * 0.2, alignment: .center)
                                        .offset(y: -15)
                                        .padding(.top, 16)
                                }
                                
                                if #available(iOS 14.0, *) {
                                    Button { } label: {
                                        HStack {
                                            Text("See All Meditations")
                                                .foregroundColor(.black)
                                                .font(Font.mada(.semiBold, size: 20))
                                        }.frame(width: g.size.width * 0.85, height: g.size.height/14)
                                            .background(Clr.yellow)
                                            .cornerRadius(25)
                                            .onTapGesture {
                                                withAnimation {
                                                    Analytics.shared.log(event: .home_tapped_categories)
                                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                                    impact.impactOccurred()
                                                    viewRouter.currentPage = .categories
                                                }
                                            }
                                    }.padding(.top, 24)
                                    .oldShadow()
                                } else {
                                    // Fallback on earlier versions
                                    
                                }
                                Spacer()
                                HStack(spacing: 15) {
                                    Text("\(numberOfMeds)")
                                        .font(Font.mada(.bold, size: 36))
                                        .foregroundColor(Clr.black1)
                                    Text("people are meditating \nright now")
                                        .font(Font.mada(.regular, size: 22))
                                        .minimumScaleFactor(0.05)
                                        .lineLimit(2)
                                        .foregroundColor(.gray)
                                }.frame(width: g.size.width * 0.8, height: g.size.height * 0.06)
                                    .padding(30)
                            }.padding(.bottom, height * 0.23)
                        }.frame(height: height)
                        .offset(y: -height * 0.23)
                    }
                    if showModal || showUpdateModal || showMiddleModal || showIAP {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showModal = false
                                showUpdateModal = false
                                showMiddleModal = false
                                showIAP = false
                            }
                        Spacer()
                    }
                    MiddleModal(shown: $showMiddleModal)
                        .offset(y: showMiddleModal ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showMiddleModal)
                    BonusModal(bonusModel: bonusModel, shown: $showModal, coins: $coins)
                        .offset(y: showModal ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showModal)
                    NewUpdateModal(shown: $showUpdateModal, showSearch: $showSearch)
                        .offset(y: showUpdateModal ? 0 : g.size.height)
                        .animation(.default, value: showUpdateModal)
                    IAPModal(shown: $showIAP, fromPage: "home")
                        .offset(y: showIAP ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showIAP)
                }
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .profile:
                    ProfileScene(profileModel: profileModel)
                                        .environmentObject(userModel)
                                        .environmentObject(gardenModel)
                                        .environmentObject(viewRouter)
                case .plant:
                    Store(isShop: false)
                case .search:
                    CategoriesScene(isSearch: true, showSearch: $showSearch)
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $wentPro) {
                Alert(title: Text("😎 Welcome to the club."), message: Text("🍀 You're now a MindGarden Pro Member"), dismissButton: .default(Text("Got it!")))
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.runCounter))
        { _ in
            if !onboardingTime {
                runCounter(counter: $attempts, start: 0, end: 3, speed: 1)
            }
        }
        .onAppear {
      

            userModel.checkIfPro()
            DispatchQueue.main.async {
                if #available(iOS 15.0, *) {
                    ios14 = false
                }
                if launchedApp {
                    gardenModel.updateSelf()
                    launchedApp = false
                    var num = UserDefaults.standard.integer(forKey: "shownFive")
                    num += 1
                    UserDefaults.standard.setValue(num, forKey: "shownFive")
                    model.getFeaturedMeditation()
                }
                if userWentPro {
                    wentPro = userWentPro
                    userWentPro = false
                }
                numberOfMeds += Int.random(in: -3 ... 3)
                //handle update modal or deeplink
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" {
                    if UserDefaults.standard.bool(forKey: "introLink") {
                        model.selectedMeditation = Meditation.allMeditations.first(where: {$0.id == 6})
                        viewRouter.currentPage = .middle
                        UserDefaults.standard.setValue(false, forKey: "introLink")
                    } else if UserDefaults.standard.bool(forKey: "happinessLink") {
                        model.selectedMeditation = Meditation.allMeditations.first(where: {$0.id == 14})
                        viewRouter.currentPage = .middle
                        UserDefaults.standard.setValue(false, forKey: "happinessLink")
                    }
                }
                if UserDefaults.standard.integer(forKey: "launchNumber") == 2 && !UserDefaults.standard.bool(forKey: "isPro") && !UserDefaults.standard.bool(forKey: "14DayModal") {
                    showUpdateModal = true
                }
                                
                coins = userCoins
                //             self.runCounter(counter: $coins, start: 0, end: coins, speed: 0.015)
            }
        }
        .onAppearAnalytics(event: .screen_load_home)
    }
    func runCounter(counter: Binding<Int>, start: Int, end: Int, speed: Double) {
        counter.wrappedValue = start
        
        Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            counter.wrappedValue += 1
            if counter.wrappedValue == end {
                counter.wrappedValue = 0
                timer.invalidate()
            }
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}
