//
//  HomeViewScroll.swift
//  MindGarden
//
//  Created by Vishal Davara on 13/04/22.
//

import SwiftUI

struct HomeViewScroll: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @State var gardenModel: GardenViewModel
    @Binding var showModal : Bool
    @Binding var showMiddleModal : Bool
    @Binding var activeSheet: Sheet?
    @Binding var totalBonuses: Int
    @Binding var attempts : Int
    @State var userModel: UserViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    
    @State private var isRecent = true
    
    let width = UIScreen.screenWidth
    let height = UIScreen.screenHeight - 100
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        ZStack(alignment: .top) {
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
                                .frame(height: K.isSmall() ? 90 : 130)
                                .padding(.leading, K.isSmall() ? 10 : 20)
                                .padding(.top, K.isSmall() ? 15 : 45)

                        }.frame(width: width * 0.85, height: K.isSmall() ? 90 : 120, alignment: .center)
                         .padding(.top,10)
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
                                    if totalBonuses == 0 {
                                        HStack {
                                            Img.coin
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 17)
                                                .neoShadow()
                                            Text("Daily Bonus")
                                                .font(Font.mada(.regular, size: 16))
                                                .foregroundColor(.black)
                                                .font(.footnote)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                        }
                                        .frame(width: width * 0.35, height: 20)
                                        .padding(8)
                                        .background(Clr.yellow)
                                        .cornerRadius(20)
                                        .modifier(Shake(animatableData: CGFloat(attempts)))
                                    } else {
                                        HStack {
                                            ZStack {
                                                Circle().frame(height: 16)
                                                    .foregroundColor(Clr.redGradientBottom)
                                                Text("\(totalBonuses)")
                                                    .font(Font.mada(.bold, size: 12))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.005)
                                                    .frame(width: 10)
                                            }.frame(width: 15)
                                            Text("Daily Bonus")
                                                .font(Font.mada(.regular, size: 16))
                                                .foregroundColor(.black)
                                                .font(.footnote)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                        }
                                        .frame(width: width * 0.35, height: 20)
                                        .padding(8)
                                        .background(Clr.yellow)
                                        .cornerRadius(20)
                                        .modifier(Shake(animatableData: CGFloat(attempts)))
                                        .wiggling1()
                                    }
                                }
                                
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
                                .frame(width: width * 0.35, height: 20)
                                .padding(8)
                                .background(Clr.yellow)
                                .cornerRadius(20)
                            }
                            .buttonStyle(BonusPress())
                        }.padding(.top, K.isSmall() ? 30 : 15)
                    }
                    
                    Button {} label: {
                        Rectangle()
                            .fill(Color("darkWhite"))
                            .border(Clr.darkWhite)
                            .cornerRadius(25)
                            .frame(width: width * 0.85, height: height * (K.isSmall() ? 0.325 : 0.275), alignment: .center)
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
                                            let count = Meditation.allMeditations.filter { $0.belongsTo.lowercased() == model.featuredMeditation?.title.lowercased() }.count
                                            if let meditationTitle = model.featuredMeditation?.title {
                                                Text("Day \(userModel.getCourseCounter(title:meditationTitle) + 1) of \(count)")
                                                    .font(Font.mada(.regular, size: K.isPad() ? 26 : 16))
                                                    .foregroundColor(Color.gray)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.65 * 0.525)
                                    .position(x: UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.85 + 30, y: height * (K.isSmall() ? 0.24 : 0.21))
                                    VStack(spacing: 0) { 
                                        ZStack {
                                            Circle().frame(width: width * 0.15, height:  width * 0.15)
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
                                                .frame(width: UIScreen.main.bounds.width * 0.80 * 0.5, height: height * 0.2)
                                                .offset(x: K.isPad() ? -150 : -25, y: K.isPad() ? -40 : -25)
                                        } else {
                                            (model.featuredMeditation?.img ?? Img.daisy3)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: UIScreen.main.bounds.width * 0.80 * 0.5, height: height * 0.2)
                                                .offset(x: K.isPad() ? -150 : -25, y: K.isPad() ? -40 : -25)
                                        }
                                        
                                    }.padding([.top, .bottom, .trailing])
                                }.onTapGesture {
                                    Analytics.shared.log(event: .home_tapped_featured)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        if !UserDefaults.standard.bool(forKey: "tappedFeature") {
                                            onboardingTime = false
                                            UserDefaults.standard.setValue(true, forKey: "tappedFeature")
                                        }
                                        model.selectedMeditation = model.featuredMeditation
                                        if model.featuredMeditation?.type == .course {
                                            viewRouter.currentPage = .middle
                                        } else {
                                            viewRouter.currentPage = .play
                                        }
                                    }
                                }
                            ).padding(.top, K.isSmall() ? 10 : 20)

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
                    }.frame(width: abs(width * 0.825), alignment: .leading)
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
                                        HomeSquare(width: width, height: height  - (height * 0.15), img: meditation.img, title: meditation.title, id: meditation.id, instructor: meditation.instructor, duration: meditation.duration, imgURL: meditation.imgURL, isNew: meditation.isNew)
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
                        }.frame(height: height * 0.2 + 15)
                            .padding([.leading, .trailing], 5)
                    }).frame(width: width * 0.9, height: height * 0.2, alignment: .center)
                        .padding(.top, 5)
                    if !UserDefaults.standard.bool(forKey: "isPro") {
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
                                        .frame(height: height * 0.1)
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        Text("Start Free Trial")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.mada(.bold, size: 20))
                                        Text("Invest in your mental health, focus, and happiness 💚")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.mada(.medium, size: 14))
                                        Spacer()
                                    }.frame(width: width * 0.5)
                                    Spacer()
                                }
                            }.frame(width: width * 0.85, height: height * (K.isSmall() ? 0.15 : 0.125), alignment: .center)
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
                    HStack(spacing: 15) {
                        Text("\(numberOfMeds)")
                            .font(Font.mada(.bold, size: 36))
                            .foregroundColor(Clr.black1)
                        Text("people are meditating \nright now")
                            .font(Font.mada(.regular, size: 22))
                            .minimumScaleFactor(0.05)
                            .lineLimit(2)
                            .foregroundColor(.gray)
                    }
                    .frame(width: width * 0.8, height: height * 0.06)
                    .padding(30)
                    //MARK: - New Meds
                    Text("🧭 Your Roadmap")
                        .font(Font.mada(.semiBold, size: 28))
                        .foregroundColor(Clr.black2)
                        .padding(.top, 30)
                        .frame(width: abs(width * 0.825), alignment: .leading)
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(Meditation.userMap.1, id: \.self) { medId in
                                    HStack {
                                        JourneyRow(width: width * 0.9, meditation: model.weeklyMeditation ?? Meditation.allMeditations[0], meditationModel: model, viewRouter: viewRouter)
                                            .padding([.horizontal, .bottom])
                                    }.frame(width: width * 0.9, alignment: .trailing)
                                }
                            }
                        }.frame(width: width)
                    }.padding(.bottom)
                    
                    if #available(iOS 14.0, *) {
                        Button { } label: {
                            HStack {
                                Text("See All Meditations")
                                    .foregroundColor(.black)
                                    .font(Font.mada(.semiBold, size: 20))
                            }.frame(width: width * 0.85, height: height/14)
                                .background(Clr.yellow)
                                .cornerRadius(25)
                                .onTapGesture {
                                    withAnimation {
                                        UserDefaults.standard.setValue(true, forKey: "allMeditations")
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
            }.padding(.bottom, height * 0.23)
            }.frame(height: height)
                .offset(y: -height * 0.23)
        }
    }
}
