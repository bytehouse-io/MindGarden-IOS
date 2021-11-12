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

struct Home: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @State private var isRecent = true
    @State private var showModal = false
    @State private var showPlantSelect = false
    @State private var showSearch = false
    @State private var showUpdateModal = false
    @State private var wentPro = false
    var bonusModel: BonusViewModel

    init(bonusModel: BonusViewModel) {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        self.bonusModel = bonusModel
    }
    
    var body: some View {
        NavigationView {
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    GeometryReader { g in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            HStack {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\(userModel.greeting), \(userModel.name)")
                                        .font(Font.mada(.bold, size: 25))
                                        .foregroundColor(Clr.black1)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 20)
                                    HStack {
                                        Img.newStar
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 15)
                                        Text("Streak: ")
                                            .foregroundColor(Clr.black2)
                                        + Text("\(bonusModel.streakNumber)")
                                            .font(Font.mada(.semiBold, size: 20))
                                            .foregroundColor(Clr.darkgreen)
                                        Img.coin
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 15)
                                        Text("\(userCoins)")
                                            .font(Font.mada(.semiBold, size: 20))
                                    }.padding(.trailing, 20)
                                        .padding(.top, -10)
                                        .padding(.bottom, 10)
                                }
                            }
                            .padding(.top, K.isSmall() ? -50 : -30 )
                            HStack {
                                Button {
                                    Analytics.shared.log(event: .home_tapped_bonus)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        showModal = true
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
                                            .font(Font.mada(.regular, size: 14))
                                            .foregroundColor(.black)
                                            .font(.footnote)
                                    }
                                    .frame(width: g.size.width * 0.3, height: 20)
                                    .padding(8)
                                    .background(Clr.yellow)
                                    .cornerRadius(25)
                                }
                                .buttonStyle(NeumorphicPress())
                                Button {
                                    Analytics.shared.log(event: .home_tapped_plant_select)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    showPlantSelect = true
                                } label: {
                                    HStack {
                                        Img.daisyHead
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        Text("Plant Select")
                                            .font(Font.mada(.regular, size: 14))
                                            .foregroundColor(.black)
                                            .font(.footnote)
                                    }
                                    .frame(width: g.size.width * 0.3, height: 20)
                                    .padding(8)
                                    .background(Clr.yellow)
                                    .cornerRadius(25)
                                }
                                .buttonStyle(NeumorphicPress())
                            }

                            Button {
                                Analytics.shared.log(event: .home_tapped_featured)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    model.selectedMeditation = model.featuredMeditation
                                    if model.featuredMeditation?.type == .course {
                                        viewRouter.currentPage = .middle
                                    } else {
                                        viewRouter.currentPage = .play
                                    }
                                }
                            } label: {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .border(Clr.darkWhite)
                                    .cornerRadius(25)
                                    .frame(width: g.size.width * 0.85, height: g.size.height * 0.3, alignment: .center)
                                    .neoShadow()
                                    .overlay(
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading) {
                                                Text("Featured")
                                                    .font(Font.mada(.regular, size: K.isPad() ? 30 : 18))
                                                    .foregroundColor(Clr.black1)
                                                Text("\(model.featuredMeditation?.title ?? "")")
                                                    .font(Font.mada(.bold, size: K.isPad() ? 40 : 26))
                                                    .foregroundColor(Clr.black1)
                                                    .lineLimit(3)
                                                    .minimumScaleFactor(0.05)
                                                Spacer()
                                            }
                                            .padding(15)
                                            .padding(.leading, 5)
                                            .offset(x: 20, y: 30)
                                            .frame(width: g.size.width * 0.85 * 0.6)
                                            .padding(K.isPad() ? 20 : 0)
                                            .padding(.top, -5)
                                            VStack(spacing: 0) {
                                                ZStack {
                                                    Circle().frame(width: g.size.width * 0.15, height:  g.size.width * 0.15)
                                                        .foregroundColor(Clr.brightGreen)
                                                    Image(systemName: "play.fill")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: K.isPad() ? 50 : 26))
                                                }.offset(x: 20, y: K.isPad() ? 30 : 10)
                                                    .padding([.top, .leading])
                                                (model.featuredMeditation?.img ?? Img.daisy3)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: g.size.width * 0.85 * 0.5, height: g.size.height * 0.2)
                                                    .offset(x: K.isPad() ? -150 : -45, y: K.isPad() ? -40 : -25)
                                            }.padding([.top, .bottom, .trailing])
                                        }).padding(.top, K.isSmall() ? 10 : 20)
                            }.buttonStyle(NeumorphicPress())
                            VStack(spacing: 1) {
                                HStack {
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        Analytics.shared.log(event: .home_tapped_recents)
                                        withAnimation {
                                            isRecent = true
                                        }
                                    } label: {
                                        Text("Recent")
                                            .foregroundColor(isRecent ? Clr.darkgreen : .black)
                                            .font(Font.mada(.regular, size: 20))
                                    }
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        Analytics.shared.log(event: .home_tapped_favorites)
                                        withAnimation {
                                            isRecent = false
                                        }
                                    } label: {
                                        Text("Favorites")
                                            .foregroundColor(isRecent ? .black : Clr.darkgreen)
                                            .font(Font.mada(.regular, size: 20))
                                    }
                                }
                                Rectangle().frame(width: isRecent ? CGFloat(45) : 65.0, height: 1.5)
                                    .foregroundColor(Clr.darkgreen)
                                    .offset(x: isRecent ? -42.0 : 33.0)
                                    .animation(.default, value: isRecent)
                            }.frame(width: abs(g.size.width - 75), alignment: .leading)
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
                                            Button {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                model.selectedMeditation = meditation
                                                Analytics.shared.log(event: isRecent ? .home_tapped_recent_meditation : .home_tapped_favorite_meditation)
                                                if meditation.type == .course {
                                                    withAnimation {
                                                        viewRouter.currentPage = .middle
                                                    }
                                                } else {
                                                    viewRouter.currentPage = .play
                                                }

                                            } label: {
                                                HomeSquare(width: g.size.width, height: g.size.height, img: meditation.img, title: meditation.title, id: meditation.id, description: meditation.description, duration: meditation.duration)
                                            }.buttonStyle(NeumorphicPress())
                                        }
                                    }
                                    if !isRecent && model.favoritedMeditations.count == 1 {
                                        Spacer()
                                    } else if isRecent && gardenModel.recentMeditations.count == 1 {
                                        Spacer()
                                    }
                                }.frame(height: g.size.height * 0.25)
                                    .padding([.leading, .trailing], 25)
                            }).frame(width: g.size.width, height: g.size.height * 0.25, alignment: .center)
                            if #available(iOS 14.0, *) {
                                Button {
                                    Analytics.shared.log(event: .home_tapped_categories)
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    withAnimation {
                                        viewRouter.currentPage = .categories
                                    }
                                } label: { RoundedRectangle(cornerRadius: 25)
                                        .frame(width: g.size.width * 0.85, height: g.size.height/14)
                                        .foregroundColor(Clr.yellow)
                                        .overlay(Text("See All Categories")
                                                    .foregroundColor(Clr.black2)
                                                    .font(Font.mada(.semiBold, size: 20))
                                        )
                                }.padding(.top, 10)
                                    .buttonStyle(NeumorphicPress())
                            } else {
                                // Fallback on earlier versions
                            }
                            Spacer()
                        }
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
                    }.frame(width: UIScreen.main.bounds.size.width)
                    if showModal || showUpdateModal {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
                    BonusModal(bonusModel: bonusModel,shown: $showModal)
                        .offset(y: showModal ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showModal)
                    NewUpdateModal(shown: $showUpdateModal)
                        .offset(y: showUpdateModal ? 0 : g.size.height)
                        .animation(.default, value: showUpdateModal)
                }
            }
            .animation(nil)
            .animation(.default)
            .navigationBarItems(
                leading: Img.topBranch.padding(.leading, -20),
                trailing: HStack {
                    if !UserDefaults.standard.bool(forKey: "isPro") {
                        Button {
                            Analytics.shared.log(event: .home_tapped_pro)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                fromPage = "home"
                                viewRouter.currentPage = .pricing
                            }
                        } label: {
                            HStack {
                                Text("💚 Go Pro!")
                                    .font(Font.mada(.semiBold, size: 14))
                                    .foregroundColor(Clr.darkgreen)
                                    .font(.footnote)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: 18)
                            .padding(8)
                            .background(Clr.darkWhite)
                            .cornerRadius(25)
                        }
                        .buttonStyle(NeumorphicPress())
                    }
                    Image(systemName: "magnifyingglass")
                    .foregroundColor(Clr.darkgreen)
                    .font(.system(size: 22))
                    .padding([.top,.bottom, .trailing])
                    .onTapGesture {
                        Analytics.shared.log(event: .home_tapped_search)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        showSearch = true
                    }
                }
            )
            .sheet(isPresented: $showPlantSelect, content: {
                Store(isShop: false, showPlantSelect: $showPlantSelect)
            })
            .popover(isPresented: $showSearch, content: {
                if #available(iOS 14.0, *) {
                    CategoriesScene(isSearch: true, showSearch: $showSearch)
                }
            })
            .alert(isPresented: $wentPro) {
                Alert(title: Text("🥳 Congrats! You unlocked MindGarden Pro"), dismissButton: .default(Text("Got it!")))
            }
        }.transition(.move(edge: .leading))
            .onAppear {
                if userWentPro {
                    wentPro = userWentPro
                    userWentPro = false
                }
                checkIfPro()
                numberOfMeds += Int.random(in: -3 ... 3)
                showUpdateModal = !UserDefaults.standard.bool(forKey: "1.0Update") && UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done"
                if UserDefaults.standard.integer(forKey: "launchNumber") == 3 || UserDefaults.standard.integer(forKey: "launchNumber") == 7 {
                    if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
                    }
                    if UserDefaults.standard.integer(forKey: "launchNumber") == 3 {
                        UserDefaults.standard.setValue(4, forKey: "launchNumber")
                    } else {
                        Analytics.shared.log(event: .seventh_time_coming_back)
                        UserDefaults.standard.setValue(8, forKey: "launchNumber")
                    }
                }
            }
            .onAppearAnalytics(event: .screen_load_home)

    }

    private func checkIfPro() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if purchaserInfo?.entitlements.all["isPro"]?.isActive == true {
                UserDefaults.standard.setValue(true, forKey: "isPro")
            } else {
                if !UserDefaults.standard.bool(forKey: "trippleTapped") {
                    UserDefaults.standard.setValue(false, forKey: "isPro")
                    if let email = Auth.auth().currentUser?.email {
                        Firestore.firestore().collection(K.userPreferences).document(email).updateData([
                            "isPro": false,
                        ]) { (error) in
                            if let e = error {
                                print("There was a issue saving data to firestore \(e) ")
                            } else {
                                print("Succesfully saved new items")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(bonusModel: BonusViewModel(userModel: UserViewModel())).navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(MeditationViewModel())
            .environmentObject(UserViewModel())
    }
}

