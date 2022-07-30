//
//  PromptsView.swift
//  MindGarden
//
//  Created by Vishal Davara on 29/06/22.
//

import SwiftUI

struct PromptsView: View {
    
    @Binding var question:String
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
           
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack {
                        ForEach(promptsTabList) { item in
                            Button {
                                DispatchQueue.main.async {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedTab = item.tabName
                                        //TODO: implement tab selection ui update event
                                    }
                                }
                            } label: {
                                Text(item.name)
                                    .font(Font.fredoka(.medium, size: 16))
                                    .foregroundColor(selectedTab == item.tabName ? .white : Clr.black2 )
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal,10)
                                    .padding(.vertical,5)
                                    .shadow(color: selectedTab == item.tabName ? .black : .clear, radius: 2)
                                    .background (
                                        Capsule()
                                                .fill(selectedTab == item.tabName ? Clr.brightGreen : .clear)
                                                .addBorder(.black, width: selectedTab == item.tabName ? 1.5 :0, cornerRadius: 28)
                                    )
                            }.buttonStyle(ScalePress())
                                .cornerRadius(28)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.leading, 16)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: -20) {
                    ForEach(promptsTabList) { item in
                        Button {
                            question = "What am I holding onto that I need to forgive myself for?"
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
                                    Img.heart
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 70, height: 70)
                                        .padding()
                                        .padding(.horizontal,0)
                                    VStack(alignment:.leading) {
                                        Text("Self-Love")
                                            .font(Font.fredoka(.semiBold, size: 20))
                                            .foregroundColor(Clr.black2)
                                            .multilineTextAlignment(.leading)
                                        Text("What am I holding onto that I need to forgive myself for?")
                                            .font(Font.fredoka(.medium, size: 12))
                                            .foregroundColor(Clr.black2)
                                            .multilineTextAlignment(.leading)
                                    }.frame(width: UIScreen.screenWidth * 0.6, alignment: .leading)
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
    }
}


//MARK: - preview
struct PromptsView_Previews: PreviewProvider {
    static var previews: some View {
        PromptsView(question: .constant(""), selectedTab: .gratitude)
    }
}
