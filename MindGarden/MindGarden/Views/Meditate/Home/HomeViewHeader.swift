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
    @EnvironmentObject var userModel: UserViewModel
    
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
                            Text("\(greeting), \(name)")
                                .font(Font.mada(.bold, size: 25))
                                .foregroundColor(colorScheme == .dark ? .black : Clr.black1)
                                .fontWeight(.bold)
                                .padding(.trailing, 20)
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                            HStack {
                                if userModel.streakFreeze > 0 {
                                    HStack {
                                        Img.iceFlower
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 25)
                                            .oldShadow()
                                        Text("\(userModel.streakFreeze)")
                                            .font(Font.mada(.semiBold, size: 22))
                                            .foregroundColor(Clr.darkgreen)
                                            .frame(height: 30, alignment: .bottom)
                                    }.offset(x: -7)
                                }
                                Img.streak
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 25)
                                    .oldShadow()
                                HStack {
                                    Text("Streak: ")
                                        .foregroundColor(colorScheme == .dark ? .black : Clr.black1)
                                        .font(Font.mada(.medium, size: 21))
                                    + Text("\(streakNumber)")
                                        .font(Font.mada(.semiBold, size: 22))
                                        .foregroundColor(Clr.darkgreen)
                                }.frame(height: 30, alignment: .bottom)
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
                }.frame(width: width * (userModel.streakFreeze > 0 ? 0.85 : 0.8))
            }
        }.frame(width: width)
            .offset(y: -height * 0.1)
    }
}

struct HomeViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewHeader(greeting: "", name: "", streakNumber: .constant(0), showSearch: .constant(true), activeSheet: .constant(.profile), showIAP: .constant(true))
    }
}
