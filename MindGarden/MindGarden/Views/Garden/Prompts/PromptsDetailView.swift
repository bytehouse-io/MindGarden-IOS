//
//  PromptsTab.swift
//  MindGarden
//
//  Created by Vishal Davara on 29/06/22.
//

import SwiftUI
import Lottie

struct PromptsDetailView: View, KeyboardReadable {
    @EnvironmentObject var moodModel: MoodModel
    @State var selectedMood: Mood
    @Binding var selectedSubMood: String
    
    @State private var text: String = "Write here..."
    @State private var contentKeyVisible: Bool = true
    @State private var showPrompt = false
        
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
                        showPrompt = true
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
                    Image(systemName: "xmark")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Clr.black1)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height:16)
                        .background(
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .frame(width:35,height:35)
                                .cornerRadius(17)
                                .neoShadow()
                        )
                        .padding(.horizontal,20)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                .padding(.horizontal,30)
                Text("Reflect on how you feel.")
                    .font(Font.fredoka(.semiBold, size: 28))
                    .foregroundColor(Clr.black2)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.horizontal,20)
                ZStack {
                    Rectangle()
                        .fill(Clr.darkWhite)
                        .cornerRadius(15)
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
                                    if text == "Write here..." {
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
                    moodModel.addMood(mood: MoodData(date: "\(Date().toString(withFormat: "EEEE, MMM dd"))", mood: selectedMood.rawValue, subMood: selectedSubMood, elaboration: text))
                    presentationMode.wrappedValue.dismiss()
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
                .buttonStyle(BonusPress())
            }
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showPrompt) {
            PromptsView()
        }
    }
}
