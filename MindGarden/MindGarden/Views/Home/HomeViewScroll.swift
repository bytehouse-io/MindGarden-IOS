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
    @Binding var selectedMood : Mood
    
    let width = UIScreen.screenWidth
    let height = UIScreen.screenHeight - 100
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        ZStack(alignment: .top) {
            //MARK: - scroll view
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HomeViewDashboard(greeting:$userModel.greeting,name:userModel.name , activeSheet:$activeSheet, showIAP: $showIAP,coin:userModel.coins, streakNumber: bonusModel.streakNumber)
                    StartDayView(activeSheet:$activeSheet, selectedMood: $selectedMood)
                    
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
//                    if #available(iOS 14.0, *) {
//                        Button { } label: {
//                            HStack {
//                                Text("See All Meditations")
//                                    .foregroundColor(.black)
//                                    .font(Font.fredoka(.semiBold, size: 20))
//                            }.frame(width: width * 0.85, height: height/14)
//                                .background(Clr.yellow)
//                                .cornerRadius(25)
//                                .onTapGesture {
//                                    withAnimation {
//                                        UserDefaults.standard.setValue(true, forKey: "allMeditations")
//                                        Analytics.shared.log(event: .home_tapped_categories)
//                                        let impact = UIImpactFeedbackGenerator(style: .light)
//                                        impact.impactOccurred()
//                                        viewRouter.currentPage = .categories
//                                    }
//                                }
//                        }.padding(.top, 24)
//                            .oldShadow()
//                    } else {
//                        // Fallback on earlier versions
//
//                    }
                    Spacer().frame(height:80)
            }.padding(.bottom, height * 0.23)
            }.frame(height: height)
        }
    }
}
