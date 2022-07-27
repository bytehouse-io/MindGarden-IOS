//
//  PromptsTab.swift
//  MindGarden
//
//  Created by Vishal Davara on 29/06/22.
//

import SwiftUI
import Lottie
import Amplitude

var placeholderReflection = "\"I write because I don’t know what I think until I read what I say.\" — Flannery O’Connor"
var placeholderQuestion = "Reflect on how you feel"
struct JournalView: View, KeyboardReadable {
    @State private var text: String = placeholderReflection
    @State private var contentKeyVisible: Bool = true
    @State private var showPrompts = false
    @State private var showRecs = false
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack(alignment:.top) {
            Clr.darkWhite.ignoresSafeArea()
            VStack(spacing:0) {
                Spacer()
                    .frame(height:50)
                HStack {
                    Text("\(Date().toString(withFormat: "EEEE, MMM dd"))")
                        .font(Font.fredoka(.medium, size: 16))
                        .foregroundColor(Clr.blackShadow)
                        .multilineTextAlignment(.center)
                        .opacity(0.5)
                    Spacer()
                    Button {
                        withAnimation {
                            showPrompts = true
                        }
                    } label: {
                        Text("Prompts")
                            .font(Font.fredoka(.semiBold, size: 16))
                            .foregroundColor(Clr.gardenRed)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    Image(systemName: "shuffle")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Clr.black1)
                        .aspectRatio(contentMode: .fit)
                        .frame(width:30)
                        .onTapGesture {
                            //TODO: implement shuffle tap event
                        }
                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "mood" {
                        CloseButton() {
                            withAnimation {
                                placeholderReflection = "\"I write because I don’t know what I think until I read what I say.\" — Flannery O’Connor"
                                placeholderQuestion = "Reflect on how you feel"
                                presentationMode.wrappedValue.dismiss()
                                viewRouter.currentPage = .meditate
                            }
                        }.padding(.leading, 10)
                    }
                }
                .padding(.horizontal,30)
            
                Text(placeholderQuestion)
                    .font(Font.fredoka(.semiBold, size: 28))
                    .foregroundColor(Clr.black2)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.horizontal,20)
                ZStack {
                    Rectangle()
                        .fill(Clr.darkWhite)
                        .cornerRadius(14)
                        .addBorder(.black, width: 1.5, cornerRadius: 14)
                        .neoShadow()
                    ScrollView(.vertical, showsIndicators: false) {
                        if #available(iOS 14.0, *) {
                            TextEditor(text: $text)
                                .disableAutocorrection(false)
                                .foregroundColor(Clr.black2)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: -10, trailing: 10))
                                .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                    withAnimation {
                                        contentKeyVisible = newIsKeyboardVisible
                                    }
                                }.onTapGesture {
                                    if text == placeholderReflection {
                                        text = ""
                                    }
                                }
                        }
                    }
                }
                .frame(width:UIScreen.screenWidth-40, height:250)
                .padding()
                Spacer()
                    .frame(height:50)
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    var num = UserDefaults.standard.integer(forKey: "numGrads")
                    num += 1
                    let identify = AMPIdentify()
                        .set("num_gratitudes", value: NSNumber(value: num))
                    Amplitude.instance().identify(identify ?? AMPIdentify())
                    if num == 30 {
                        userModel.willBuyPlant = Plant.badgePlants.first(where: { $0.title == "Camellia" })
                        userModel.buyPlant(unlockedStrawberry: true)
                        userModel.triggerAnimation = true
                    }
                    UserDefaults.standard.setValue(num, forKey: "numGrads")
                    Analytics.shared.log(event: .gratitude_tapped_done)
                    gardenModel.save(key: K.defaults.journals, saveValue: text, coins: userModel.coins)
                    withAnimation {                        
                        if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "mood" {
                            UserDefaults.standard.setValue("gratitude", forKey: K.defaults.onboarding)
                        }
                        Analytics.shared.log(event: .gratitude_tapped_done)
                        var journalObj = [String: String]()
                        journalObj["timeStamp"] = Date.getTime()
                        journalObj["gratitude"] = text
                        journalObj["question"] =  placeholderQuestion
                        userModel.coins += 20
                        gardenModel.save(key: K.defaults.journals, saveValue: journalObj, coins: userModel.coins)
                        
                        if moodFirst {
                            showRecs = true
                            moodFirst = false
                        } else {
                            viewRouter.currentPage = .meditate
                        }
                    }
                    placeholderReflection = "\"I write because I don’t know what I think until I read what I say.\" — Flannery O’Connor"
                    placeholderQuestion = "Reflect on how you feel"
                } label: {
                    HStack {
                        Text("Done")
                            .foregroundColor(.white)
                            .font(Font.fredoka(.semiBold, size: 20))
                            .padding()
                    }
                    .frame(width:150, height: 44, alignment: .center)
                    .background(Clr.brightGreen)
                    .cornerRadius(28)
                    
                }
                .padding()
                .buttonStyle(NeoPress())
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showPrompts) {
            PromptsView()
        }
        .fullScreenCover(isPresented: $showRecs) {
            RecommendationsView()
        }
        .transition(.move(edge: .trailing))
    }
}
