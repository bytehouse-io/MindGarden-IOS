//
//  PromptsView.swift
//  MindGarden
//
//  Created by Vishal Davara on 29/06/22.
//

import SwiftUI

struct PromptsView: View {
    
    @Binding var question:String
    @State var selectedPrompts: [Journal] = []
    @State var selectedTab: PromptsTabType = .gratitude
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Clr.darkWhite.ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(height:40)
                HStack() {
                    CloseButton() {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    Spacer()
                    Text("Journal Prompts")
                        .font(Font.fredoka(.bold, size: 16))
                        .foregroundColor(Clr.black2)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.screenWidth/3, height:30)
                    Spacer()
                    CloseButton() {}.opacity(0)
                }.padding(.horizontal, 32)
                .padding(.bottom)
           
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(promptsTabList) { item in
                            Button {
                                withAnimation {
                                    selectedTab = item.tabName
                                    selectedPrompts = Journal.prompts.filter({ prompt in
                                        prompt.category == selectedTab
                                    })
                                }
                            } label: {
                                HStack {
                                    Text(item.name)
                                        .font(Font.fredoka(.medium, size: 16))
                                        .foregroundColor(selectedTab == item.tabName ? Clr.black2 : Clr.black2 )
                                        .padding(.horizontal)

                                }
                                .padding(8)
                                .background(selectedTab == item.tabName ? Clr.yellow : Clr.darkWhite)
                                .cornerRadius(16)
                                .addBorder(.black, width: selectedTab == item.tabName ? 2 : 1, cornerRadius: 16)
                
                            }
                            .frame(height:32)
                            .buttonStyle(NeumorphicPress())
                        }
                    }.frame(height:45)
                }
                .frame(height:45)
                .padding(.leading, 32)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: -20) {
                        ForEach(selectedPrompts, id: \.self) { prompt in
                        Button {
                            question = prompt.description
                            withAnimation {
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .frame(height: UIScreen.screenHeight * 0.1, alignment: .center)
                                    .cornerRadius(16)
                                    .addBorder(.black, width: 1.5, cornerRadius: 16)
                                    .neoShadow()
                                HStack(spacing:0) {
                                    prompt.img
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .padding()
                                        .padding(.horizontal,0)
                                        .offset(x: -5)
                                    VStack(alignment:.leading) {
                                        Text(prompt.title)
                                            .font(Font.fredoka(.semiBold, size: 20))
                                            .foregroundColor(Clr.black2)
                                            .multilineTextAlignment(.leading)
                                        Text(prompt.description)
                                            .font(Font.fredoka(.medium, size: 12))
                                            .foregroundColor(Clr.black2)
                                            .multilineTextAlignment(.leading)
                                    }.frame(width: UIScreen.screenWidth * 0.55, alignment: .leading)
                                }
                                .frame(width: UIScreen.screenWidth - 96, height: UIScreen.screenHeight * 0.1, alignment: .center)
                                .cornerRadius(16)
                                .padding()
                            }
                        }
                        .padding(5)
                    }
                    }.padding(.horizontal, 48)
                }
            }.frame(width: UIScreen.screenWidth)
        }
        .ignoresSafeArea()
        .onAppear {
            selectedPrompts = Journal.prompts.filter({ prompt in
                prompt.category == selectedTab
            })
        }
    }
}


//MARK: - preview
struct PromptsView_Previews: PreviewProvider {
    static var previews: some View {
        PromptsView(question: .constant(""), selectedTab: .gratitude)
    }
}
