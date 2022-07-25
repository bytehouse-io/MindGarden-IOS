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
    @Binding var showIAP : Bool
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
                    HomeViewDashboard(showModal: $showModal, totalBonuses: $bonusModel.totalBonuses, greeting:$userModel.greeting,name:userModel.name , activeSheet:$activeSheet, showIAP: $showIAP,coin:userModel.coins, streakNumber: bonusModel.streakNumber)
                    StartDayView()
                    HStack(spacing: 15) {
                        Text("\(numberOfMeds)")
                            .font(Font.fredoka(.bold, size: 36))
                            .foregroundColor(Clr.black1)
                        Text("people are meditating \nright now")
                            .font(Font.fredoka(.regular, size: 22))
                            .minimumScaleFactor(0.05)
                            .lineLimit(2)
                            .foregroundColor(.gray)
                    }
                    .frame(width: width * 0.8, height: height * 0.06)
                    .padding(30)
                    JourneyScene(userModel: userModel)
                    Spacer().frame(height:80)
            }.padding(.bottom, height * 0.23)
            }.frame(height: height)
        }.onAppear {
        }
    }
}
