//
//  HomeViewHeader.swift
//  MindGarden
//
//  Created by Vishal Davara on 12/04/22.
//

import SwiftUI

struct HomeViewHeader: View {
    @State var greeting : String
    @State var name : String
    @Binding var streakNumber : Int
    @Binding var showSearch : Bool
    @Binding var activeSheet : Sheet?
    @Binding var showIAP : Bool
    @Binding var showPurchase: Bool
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State var challengeOn = false
    @State var Speaker = true
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    let width = UIScreen.screenWidth
    let height = UIScreen.screenHeight
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
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
                        // TODO if user presses off: speaker.slash.fill icon
                        Image(systemName: Speaker ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .foregroundColor(Clr.darkgreen)
                            .font(.system(size: 22))
                            .onTapGesture {
                                Analytics.shared.log(event: .home_tapped_sound)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                
                                if let player = player {
                                    if player.isPlaying {
                                        player.pause()
                                        UserDefaults.standard.setValue(false, forKey: "isPlayMusic")
                                        Speaker = false
                                    } else {
                                        player.play()
                                        UserDefaults.standard.setValue(true, forKey: "isPlayMusic")
                                        Speaker = true
                                    }
                                }
//                                showSearch = true
//                                searchScreen = true
//                                activeSheet = .search
                            }
                        Image(systemName: "person.fill")
                            .foregroundColor(Clr.darkgreen)
                            .font(.system(size: 22))
                            .onTapGesture {
                                Analytics.shared.log(event: .home_tapped_profile)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                activeSheet = .profile
                            }
                    }.offset(x: 30, y: -25)
                    
                    HStack{
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(greeting), \(name)")
                                .font(Font.mada(.bold, size: 25))
                                .foregroundColor(colorScheme == .dark ? .black : Clr.black1)
                                .fontWeight(.bold)
                                .padding(.trailing, 20)
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                            HStack {
                                if challengeOn {
                                    Capsule()
                                        .fill(Color.red.opacity(0.7))
                                        .frame(width: 100, height: 25)
                                        .overlay(
                                            Text("\(Date().intToMonth(num: Int(Date().get(.month))!)) Challenge")
                                                .font(Font.mada(.bold, size: 12))
                                                .foregroundColor(.white)
                                                .frame(height: 25, alignment: .center)
                                        )
                                        .shadow(radius: 10)
                                        .onTapGesture {
                                            withAnimation {
                                                medModel.selectedMeditation = Meditation.allMeditations.first(where: { $0.id == 6 })
                                                viewRouter.currentPage = .middle
                                            }
                                        }
                                }
                                if userModel.streakFreeze > 0 {
                                    HStack {
                                        Img.iceFlower
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 25)
                                            .shadow(radius: 4)
                                        Text("\(userModel.streakFreeze)")
                                            .font(Font.mada(.semiBold, size: 22))
                                            .foregroundColor(Clr.darkgreen)
                                            .frame(height: 30, alignment: .bottom)
                                    }.offset(x: -7)
                                }
                             
                                    HStack {
                                        Img.leaf
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 35)
                                            .shadow(radius: 4)
                                        Text("\(userModel.plantedTrees.count)")
                                            .font(Font.mada(.semiBold, size: 22))
                                            .foregroundColor(Clr.darkgreen)
                                            .frame(height: 30, alignment: .bottom)
                                            .offset(x: -5)
                                    }.offset(x: -5)
                                        .onTapGesture {
                                            Analytics.shared.log(event: .home_tapped_real_tree)
                                            withAnimation {
                                                userModel.willBuyPlant = Plant.allPlants.first(where: { plt in
                                                    plt.title == "Real Tree"
                                                })
                                                showPurchase = true
                                            }
                                }
                         
                                HStack {
                                    Img.streak
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 25)
                                        .shadow(radius: 4)
//                                    Text("Streak: ")
//                                        .foregroundColor(colorScheme == .dark ? .black : Clr.black1)
//                                        .font(Font.mada(.medium, size: 21))
                                    Text("\(streakNumber)")
                                        .font(Font.mada(.semiBold, size: 22))
                                        .foregroundColor(Clr.darkgreen)
                                }.frame(height: 30, alignment: .bottom)
                                    .offset(x: -5)
                                if !UserDefaults.standard.bool(forKey: "day4") {
                                     HStack {
                                        Img.coin
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25)
                                            .shadow(radius: 4)
                                        Text("\(userModel.coins)")
                                            .font(Font.mada(.semiBold, size: 20))
                                            .foregroundColor(colorScheme == .dark ? .black : Clr.black2)
                                     }.frame(height: 30, alignment: .bottom)
                                } else {
                                    PlusCoins(coins: $userModel.coins)
                                        .onTapGesture {
                                            UserDefaults.standard.setValue(true, forKey: "plusCoins")
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            Analytics.shared.log(event: .home_tapped_IAP)
                                            withAnimation { showIAP.toggle() }
                                        }
                                }
                            }.padding(.trailing, 25)
                                .padding(.top, -10)
                                .padding(.bottom, 10)
                        }
                    }.offset(x: -width * 0.25, y: -10)
                }.frame(width: width * (userModel.streakFreeze > 0 || challengeOn ? 0.92 : 0.84))
                .padding(.trailing, 40)
            }
        }.frame(width: width)
            .offset(y: -height * 0.1)
            .onAppear {
                if let challengeDate = UserDefaults.standard.string(forKey: "challengeDate") {
                    if challengeDate != "" {
                        if (Date() - (formatter.date(from: challengeDate) ?? Date()) < 30000) && !UserDefaults.standard.bool(forKey: "day7"){
                            challengeOn = true
                        }
                    }
                }
            }
    }
}

struct HomeViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewHeader(greeting: "", name: "", streakNumber: .constant(0), showSearch: .constant(true), activeSheet: .constant(.profile), showIAP: .constant(true), showPurchase: .constant(false))
    }
}
