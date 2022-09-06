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
    @EnvironmentObject var bonusModel: BonusViewModel

    @State var gardenModel: GardenViewModel
    @Binding var showModal : Bool
    @Binding var showMiddleModal : Bool
    @Binding var activeSheet: Sheet?
    @Binding var totalBonuses: Int
    @Binding var attempts : Int
    @Binding var showIAP : Bool
    @State var userModel: UserViewModel
    @State private var isRecent = true

    let width = UIScreen.screenWidth
    let height = UIScreen.screenHeight - 100
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        ZStack(alignment: .top) {
            //MARK: - scroll view
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 7) {
                    HStack(spacing: 15) {
                        Button {
                            Analytics.shared.log(event: .home_tapped_profile)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            activeSheet = .profile
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height:20)
                                .foregroundColor(.black)
                                .roundedCapsule()
                        }.buttonStyle(BonusPress())
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(16)
                                .frame(width: width * 0.75, height: 100, alignment: .center)
                                .addBorder(.black, width: 1.5, cornerRadius: 16)
                            Stories()
                                .frame(width: width * 0.725, height: K.isSmall() ? 70 : 95, alignment: .trailing)
                                .padding(30)
                                .offset(y: K.isSmall() ? 3 : 8)
                        }.frame(width: width * 0.75, height: 100, alignment: .center)
                    }.frame(width: width * 0.85)
                        .offset(x: width * -0.025)
                    .padding(.top, 40)
       
                    HomeViewDashboard(showModal: $showModal, totalBonuses: $bonusModel.totalBonuses, greeting:$userModel.greeting,name:userModel.name , activeSheet:$activeSheet, showIAP: $showIAP, streakNumber: $bonusModel.streakNumber)
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
            }.padding(.bottom, height * 0.1)
            }.frame(height: height + (K.isSmall() ? 125 : 0))
        }.onAppear {
        }
    }
}
