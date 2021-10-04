//
//  Home.swift
//  MindGarden
//
//  Created by Dante Kim on 6/11/21.
//

import SwiftUI
import FirebaseAuth


struct Home: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @State private var isRecent = true
    @State private var showModal = false
    @State private var showPlantSelect = false
    @State private var showSearch = false
    var bonusModel: BonusViewModel

    init(bonusModel: BonusViewModel) {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        self.bonusModel = bonusModel
    }
    
    var body: some View {
        NavigationView {
                GeometryReader { g in
                    ZStack {
                        Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
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
                                }
                            }
                            .padding(.top, -30)
                            HStack {
                                Button {
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
                                                .font(Font.mada(.regular, size: 18))
                                                .foregroundColor(Clr.black1)
                                            Text("\(model.featuredMeditation?.title ?? "")")
                                                .font(Font.mada(.bold, size: 28))
                                                .foregroundColor(Clr.black1)
                                                .lineLimit(3)
                                                .minimumScaleFactor(0.05)
                                            Spacer()
                                        }.padding(15)
                                        .offset(x: 20, y: 30)
                                        .frame(width: g.size.width * 0.85 * 0.5)
                                        VStack(spacing: 0) {
                                            ZStack {
                                                Circle().frame(width: g.size.width * 0.15, height:  g.size.width * 0.15)
                                                    .foregroundColor(Clr.brightGreen)
                                                Image(systemName: "play.fill")
                                                    .foregroundColor(.white)
                                                    .font(.title)
                                            }.offset(x: 20, y: 10)
                                            .padding([.top, .leading])
                                            (model.featuredMeditation?.img ?? Img.morningSun)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: g.size.width * 0.85 * 0.5, height: g.size.height * 0.2)
                                                .offset(x: -40, y: -25)
                                        }.padding([.top, .bottom, .trailing])
                                    }).padding(.top, 20)
                            }.buttonStyle(NeumorphicPress())
                            VStack(spacing: 1) {
                                HStack {
                                    Button {
                                        withAnimation {
                                            isRecent = true
                                        }
                                    } label: {
                                        Text("Recent")
                                            .foregroundColor(isRecent ? Clr.darkgreen : .black)
                                            .font(Font.mada(.regular, size: 20))
                                    }
                                    Button {
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
                                                if meditation.type == .course {
                                                    viewRouter.currentPage = .middle
                                                } else {
                                                    viewRouter.currentPage = .play
                                                }
                                            } label: {
                                                HomeSquare(width: g.size.width, height: g.size.height, img: meditation.img, title: meditation.title, id: meditation.id, description: meditation.description, duration: meditation.duration)
                                            }.buttonStyle(NeumorphicPress())
                                            .padding(.leading, model.favoritedMeditations.count == 1 ? 25 : 0 )
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
                                }.padding(.top, 20)
                                .buttonStyle(NeumorphicPress())
                            } else {
                                // Fallback on earlier versions
                            }
                            Spacer()
                        }.scrollOnOverflow()
                    if showModal {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
                    BonusModal(bonusModel: bonusModel,shown: $showModal)
                        .offset(y: showModal ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showModal)
                    }
                }
                .animation(nil)
            .animation(.default)
            .navigationBarItems(
                leading: Img.topBranch.padding(.leading, -20),
                trailing: Image(systemName: "magnifyingglass")
                    .foregroundColor(Clr.darkgreen)
                    .font(.system(size: 22))
                    .padding()
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        showSearch = true
                    }
            )
            .popover(isPresented: $showPlantSelect, content: {
                Store(isShop: false, showPlantSelect: $showPlantSelect)
            })
            .sheet(isPresented: $showSearch, content: {
                if #available(iOS 14.0, *) {
                    CategoriesScene(isSearch: true, showSearch: $showSearch)
                }
            })
        }.transition(.move(edge: .leading))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(bonusModel: BonusViewModel(userModel: UserViewModel())).navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(MeditationViewModel())
            .environmentObject(UserViewModel())

    }
}

