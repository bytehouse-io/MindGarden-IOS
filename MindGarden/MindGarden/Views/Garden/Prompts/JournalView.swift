//
//  PromptsTab.swift
//  MindGarden
//
//  Created by Vishal Davara on 29/06/22.
//

import SwiftUI
import Lottie
import Amplitude
import Combine

var placeholderReflection = "\"I write because I don’t know what I think until I read what I say.\"\n— Flannery O’Connor"
var placeholderQuestion = "Reflect on how you feel"

struct JournalView: View, KeyboardReadable {
    @State private var text: String = placeholderReflection
    @State private var contentKeyVisible: Bool = true
    @State private var showPrompts = false
    @State private var showRecs = false
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var showtextFieldToolbar = false
    @State private var coin = 0
    @State var question = ""
    @State var recs = [-4,71,23]
    
    @available(iOS 15.0, *)
    @FocusState private var isFocused: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment:.top) {
            Clr.darkWhite.ignoresSafeArea()
            VStack(spacing:0) {
                Spacer()
                    .frame(height:50)
                HStack {
                    Text("\(Date().toString(withFormat: "EEEE, MMM dd"))")
                        .font(Font.fredoka(.medium, size: 20))
                        .foregroundColor(Clr.blackShadow)
                        .multilineTextAlignment(.center)
                        .opacity(0.5)
                    Spacer()
                    
                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "mood" {
                        CloseButton() {
                            withAnimation {
                                placeholderReflection = "\"I write because I don’t know what I think until I read what I say.\"\n— Flannery O’Connor"
                                placeholderQuestion = "Reflect on how you feel"
                                presentationMode.wrappedValue.dismiss()
                                viewRouter.currentPage = viewRouter.previousPage
                            }
                        }.padding(.leading, 5)
                    }
                }.padding(.leading, 5)
                if userModel.elaboration != "" {
                    HStack {
                        Mood.getMoodImage(mood: userModel.selectedMood)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                        Text(userModel.elaboration)
                            .font(Font.fredoka(.medium, size: 14))
                            .foregroundColor(Clr.black2)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black, lineWidth: 1.5)
                            )
                            .frame(minWidth: UIScreen.screenWidth * 0.175)
                            .padding(.leading, 10)
                    }
                    .frame(width: UIScreen.screenWidth - 60, alignment: .leading)
                    .padding(.leading, 5)
                    .padding(.vertical, 10)
                }
                GeometryReader { g in
                    VStack(spacing: 0) {
                        Text(question)
                            .font(Font.fredoka(.semiBold, size: 24))
                            .foregroundColor(Clr.black2)
                            .lineLimit(3)
                            .frame(width: UIScreen.screenWidth - 60, alignment: .leading)
                            .padding(.leading, 5)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(16)
                                .addBorder(.black, width: 1.5, cornerRadius: 16)
                                .neoShadow()
                            ScrollView(.vertical, showsIndicators: false) {
                                if #available(iOS 15.0, *) {
                                    TextEditor(text: $text)
                                        .frame(height:240, alignment: .leading)
                                        .disableAutocorrection(false)
                                        .foregroundColor(text == placeholderReflection ? Clr.lightGray : Clr.black2)
                                        .padding(EdgeInsets(top: 15, leading: 15, bottom: -20, trailing: 15))
                                        .focused($isFocused)
                                        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                            withAnimation {
                                                contentKeyVisible = newIsKeyboardVisible
                                            }
                                        }.onTapGesture {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            if text == placeholderReflection {
                                                text = ""
                                            }
                                        }
                                } else if #available(iOS 14.0, *) {
                                    TextEditor(text: $text)
                                        .frame(height:240, alignment: .leading)
                                        .disableAutocorrection(false)
                                        .foregroundColor(text == placeholderReflection ? Clr.lightGray : Clr.black2)
                                        .padding(EdgeInsets(top: 15, leading: 15, bottom: -20, trailing: 15))
                                        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                            withAnimation {
                                                contentKeyVisible = newIsKeyboardVisible
                                            }
                                        }.onTapGesture {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            if text == placeholderReflection {
                                                text = ""
                                            }
                                        }
                                }
                            }
                        }
                        .transition(.move(edge: .leading))
                        .frame(height: g.size.height * (question == placeholderQuestion ? 0.4 : (question.count >= 64 ? 0.35 : question.count >= 32 ? 0.4 : 0.45)))
                        .padding(.top, 15)
                    }
                }
            }
            ZStack(alignment:.top) {
                VStack {
                    Spacer()
                    HStack {
                        Text("\(coin)")
                            .font(Font.fredoka(.semiBold, size: 20))
                            .foregroundColor(.black)
                        Img.coin
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height:20)
                            .foregroundColor(.black)
                            .neoShadow()
                        
                        Spacer()
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                question = Journal.prompts.shuffled()[0].description
                            }
                        } label: {
                            Image(systemName: "shuffle")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Clr.black1)
                                .aspectRatio(contentMode: .fit)
                                .frame(width:25)
                                .padding(.trailing)
                        }
                        
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                showPrompts = true
                            }
                        } label: {
                            Text("Prompts")
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(Clr.redGradientBottom)
                                .multilineTextAlignment(.center)
                                .padding(.trailing)
                        }.frame(height: 35)
                            .neoShadow()
                        Button {
                            if !text.isEmpty && text != placeholderReflection {
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
                                    userModel.coins += coin
                                    gardenModel.save(key: K.defaults.journals, saveValue: journalObj, coins: userModel.coins)
                                    if moodFirst {
                                        showRecs = true
                                        moodFirst = false
                                    } else {
                                        viewRouter.currentPage = .meditate
                                    }                            }
                                placeholderReflection = "\"I write because I don’t know what I think until I read what I say.\"\n— Flannery O’Connor"
                                placeholderQuestion = "Reflect on how you feel"
                            }
                        } label: {
                            HStack {
                                Text("Done")
                                    .foregroundColor(.white)
                                    .font(Font.fredoka(.semiBold, size: 20))
                                    .padding()
                            }
                            .frame(width:120, height: 35)
                            .background(Clr.brightGreen.neoShadow())
                            .cornerRadius(24)
                            .addBorder(.black, width: 1.5, cornerRadius: 24)
                        }
                        .buttonStyle(NeoPress())
                        
                    }.KeyboardAwarePadding()
                        .padding(.bottom)
                    Spacer()
                        .frame(height:50)
                }
            }.padding(.horizontal, 5)
        }.frame(width: UIScreen.screenWidth - 60, alignment: .leading)
            .offset(x: -5)
            .onChange(of:text) { text in
                if text.count >= 10 && text.count < 25 {
                    coin = 5
                } else if text.count >= 25 && text.count < 50 {
                    coin = 10
                } else if text.count >= 50 && text.count < 100 {
                    coin = 20
                } else if text.count >= 100 && text.count < 200 {
                    coin = 30
                } else if text.count >= 200 && text.count < 300 {
                    coin = 40
                } else if text.count >= 300 {
                    coin = 50
                } else {
                    coin = 0
                }
            }
            .onAppear {
                if #available(iOS 15.0, *) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFocused = true
                    }
                }
                recs = Meditation.getRecsFromMood(selectedMood: userModel.selectedMood)
                question = placeholderQuestion
                UITextView.appearance().backgroundColor = .clear
            }
            .ignoresSafeArea()
            .sheet(isPresented: $showPrompts) {
                PromptsView(question: $question)
            }
            .fullScreenCover(isPresented: $showRecs) {
                RecommendationsView(recs: $recs, coin: $coin)
            }
            .transition(.move(edge: .trailing))
    }
}



struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height - 60 },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
    }
}

extension View {
    func KeyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}
