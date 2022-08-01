//
//  HomeViewDashboard.swift
//  MindGarden
//
//  Created by Vishal Davara on 02/07/22.
//

import SwiftUI
// Font sizes: 12, 16, 28
struct HomeViewDashboard: View {
    @EnvironmentObject var userModel: UserViewModel
    @Binding var showModal : Bool
    @Binding var totalBonuses : Int
    @Binding var greeting : String
    @State var name : String
    @Binding var activeSheet: Sheet?
    @Binding var showIAP: Bool
    @State var coin: Int
    @State var streakNumber: Int
    let height = 20.0
    var body: some View {
        let width = UIScreen.screenWidth
        ZStack {
            VStack {
                HStack {
                    Button {
                        Analytics.shared.log(event: .home_tapped_profile)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        activeSheet = .profile
                    } label: {
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height:height)
                            .foregroundColor(.black)
                            .roundedCapsule()
                    }
                    .buttonStyle(BonusPress())
                    
                    Spacer()
                    Button {
                        Analytics.shared.log(event: .home_tapped_bonus)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        withAnimation {
                            DispatchQueue.main.async {
                                showModal = true
                            }
                        }
                    } label : {
                        if totalBonuses > 0 {
                            HStack(spacing:5) {
                                if totalBonuses > 0 {
                                    ZStack {
                                        Circle().frame(height: 16)
                                            .foregroundColor(Clr.redGradientBottom)
                                        Text("\(totalBonuses)")
                                            .font(Font.fredoka(.bold, size: 12))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.005)
                                            .frame(width: 10)
                                    }.frame(width: 15)
                                }
                                Img.coin
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height:20)
                                    .foregroundColor(.black)
                                Text("\(coin)")
                                    .font(Font.fredoka(.medium, size: 16))
                                    .foregroundColor(.black)
                            }
                            .frame(width: width * 0.2, height:height)
                            .roundedCapsule()
                            .wiggling1()
                        } else {
                            HStack(spacing:5) {
                                Img.coin
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height:20)
                                    .foregroundColor(.black)
                                Text("\(coin)")
                                    .font(Font.fredoka(.medium, size: 16))
                                    .foregroundColor(.black)
                            }
                            .frame(width: width * 0.2, height:height)
                            .roundedCapsule()
                        }
                    }
                    
                    
                    Spacer()
                    Button {
                        Analytics.shared.log(event: .home_tapped_plant_select)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        activeSheet = .plant
                    } label: {
                        HStack(spacing:5) {
                            userModel.selectedPlant?.head
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height:20)
                                .foregroundColor(.black)
                            Text("Select")
                                .font(Font.fredoka(.regular, size: 16))
                                .minimumScaleFactor(0.05)
                                .foregroundColor(.black)
                        }.frame(width: width * 0.2, height:height)
                        .roundedCapsule()
                    }.buttonStyle(BonusPress())
                    Spacer()
                    HStack(spacing:5) {
                        Img.streak
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height:24)
                            .foregroundColor(.black)
                        Text("\(streakNumber) " + (K.isSmall() ? "" : "days"))
                            .font(Font.fredoka(.medium, size: 16))
                            .foregroundColor(Clr.gardenRed)
                    }
                    .frame(height:height)
                    .roundedCapsule(color: .clear)
                    Spacer()
                }.padding(.trailing, 8)
                
                HStack {
                    VStack(alignment:.leading) {
                        Text("\(Date().toString(withFormat: "EEEE, MMM dd"))")
                            .font(Font.fredoka(.regular, size: 20))
                            .foregroundColor(Clr.black2)
                        Text("\(greeting), \(name)")
                            .font(Font.fredoka(.medium, size: 32))
                            .foregroundColor(Clr.black2)
                    }
                    Spacer()
                }
                .padding(.top,20)
            }
            .padding(.horizontal, 24)
            .padding(.top)
        }
    }
}
