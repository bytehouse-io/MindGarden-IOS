//
//  MoodElaborate.swift
//  MindGarden
//
//  Created by Vishal Davara on 05/07/22.
//

import SwiftUI
import Amplitude

struct MoodElaborate: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @State private var selectedSubMood: String = ""
    
    
    @State private var showDetail = false
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                    .frame(height:100)
                HStack() {
                    Text("\(Date().toString(withFormat: "EEEE, MMM dd"))")
                        .font(Font.fredoka(.regular, size: 20))
                        .foregroundColor(Clr.black2)
                        .padding(.leading,30)
                    Spacer()
                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "signedUp" {
                        CloseButton() {
                            withAnimation {
                                viewRouter.currentPage = .meditate
                            }
                        }.padding(.trailing,20)
                    }
                }
                .frame(width: UIScreen.screenWidth)
                Mood.getMoodImage(mood: userModel.selectedMood)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth:70)
                    .padding(.top,30)
                Text("How would you describe how you’re feeling?")
                    .foregroundColor(Clr.black2)
                    .font(Font.fredoka(.semiBold, size: 28))
                    .multilineTextAlignment(.center)
                ZStack {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(userModel.selectedMood.options, id: \.self) { item in
                            Button {
                                withAnimation {
                                    selectedSubMood = item
                                    var num = UserDefaults.standard.integer(forKey: "numMoods")
                                    num += 1
                                    UserDefaults.standard.setValue(num, forKey: "numMoods")
                                    let identify = AMPIdentify()
                                        .set("num_moods", value: NSNumber(value: num))
                                    Amplitude.instance().identify(identify ?? AMPIdentify())
                                    Analytics.shared.log(event: .mood_tapped_done)
                                    
                                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "signedUp" {
                                        UserDefaults.standard.setValue("mood", forKey: K.defaults.onboarding)
                                    }
                                    Amplitude.instance().logEvent("mood_elaborate", withEventProperties: ["elaboration": item])
                                    var moodSession = [String: String]()
                                    moodSession["timeStamp"] = Date.getTime()
                                    moodSession["elaboration"] = item
                                    moodSession["mood"] = userModel.selectedMood.title
                                    userModel.coins += 20
                                    gardenModel.save(key: "moods", saveValue: moodSession, coins: userModel.coins)
                                
                                    viewRouter.currentPage = .journal
                                }
                            }
                            label : {
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .cornerRadius(10)
                                        .neoShadow()
                                    Text(item)
                                        .font(Font.fredoka(.semiBold, size: 14))
                                        .foregroundColor(Clr.black2)
                                        .lineLimit(1)
                                        .padding(.vertical,10)
                                        .padding(5)
                                }.padding(5)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top,20)
                Spacer()
            }
        }.transition(.move(edge: .trailing))
    }
}
