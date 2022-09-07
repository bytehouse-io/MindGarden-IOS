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
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @Binding var showModal : Bool
    @Binding var totalBonuses : Int
    @Binding var greeting : String
    @State var name : String
    @Binding var activeSheet: Sheet?
    @Binding var showIAP: Bool
    @Binding var streakNumber: Int
    @State var showRecFavs = false
    @State var sheetType: [Int] = []
    @State var sheetTitle: String = ""
    let height = 20.0
    var body: some View {
        let width = UIScreen.screenWidth
        ZStack {
            VStack {

                HStack {
                    VStack(alignment:.leading) {
                        Text("\(Date().toString(withFormat: "EEEE, MMM dd"))")
                            .font(Font.fredoka(.regular, size: 20))
                            .foregroundColor(Clr.darkGray)
                        Text("\(greeting), \(name)")
                            .font(Font.fredoka(.medium, size: 28))
                            .foregroundColor(Clr.black2)
                    }
                    Spacer()
                    HStack {
                        if !userModel.completedMeditations.isEmpty {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                Analytics.shared.log(event: .home_tapped_recents)
                                withAnimation {
                                    sheetTitle = "Your Recents"
                                    sheetType = userModel.completedMeditations.compactMap({ Int($0)}).reversed().unique()
                                    showRecFavs = true
                                }
                            } label: {
                                Image(systemName: "clock.arrow.circlepath")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25)
                                    .foregroundColor(Clr.darkGray)
                            }
                        }
                        if !medModel.favoritedMeditations.isEmpty {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                Analytics.shared.log(event: .home_tapped_favorites)
                                withAnimation {
                                    sheetTitle = "Your Favorites"
                                    sheetType = medModel.favoritedMeditations.reversed()
                                    showRecFavs = true
                                }
                            } label: {
                                Image(systemName: "heart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25)
                                    .foregroundColor(Clr.darkGray)
                            }
                        }
                    }.padding(.trailing, 32)
                     .offset(y: -16)
                }
                .padding(.top,20)
            }
            .padding(.horizontal, 24)
            .padding(.top)
        }.sheet(isPresented: $showRecFavs) {
            ShowRecsScene(meditations: sheetType, title: $sheetTitle)
        }
    }
}
