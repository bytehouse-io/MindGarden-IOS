//
//  PromptsView.swift
//  MindGarden
//
//  Created by Vishal Davara on 29/06/22.
//

import SwiftUI

struct PromptsView: View {
    
    @State var selectedTab: PromptsTabType = .gratitude
    
    var body: some View {
        ZStack {
            Clr.darkWhite.ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(height:40)
                HStack() {
                    Image(systemName: "xmark")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Clr.black1)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth/3, height:16)
                        .background(
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .frame(width:35,height:35)
                                .cornerRadius(17)
                                .neoShadow()
                        )
                        .onTapGesture {
                            //TODO: implement close button tap event
                        }
                    Text("Prompts")
                        .font(Font.fredoka(.medium, size: 20))
                        .foregroundColor(Clr.black2)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.screenWidth/3, height:30)
                    Spacer()
                        .frame(width: UIScreen.screenWidth/3, height:30)
                }
                .frame(width: UIScreen.screenWidth)
                .padding()
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
                                    )
                            }
                        }
                    }
                }
                .padding(.leading,30)
                .padding()
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer()
                        .frame(height:15)
                    ForEach(promptsTabList) { item in
                        Button {
                            //TODO: redirect on item selection
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .frame(height: 80, alignment: .center)
                                    .cornerRadius(15)
                                    .neoShadow()
                                HStack(spacing:0) {
                                    Img.heart
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 60)
                                        .padding()
                                        .padding(.horizontal,0)
                                    VStack(alignment:.leading) {
                                        Text("Self-Love")
                                            .font(Font.fredoka(.semiBold, size: 20))
                                            .foregroundColor(Clr.black2)
                                            .multilineTextAlignment(.leading)
                                        Text("What am I holding onto that I need to forgive myself for?")
                                            .font(Font.fredoka(.medium, size: 16))
                                            .foregroundColor(Clr.black2)
                                            .multilineTextAlignment(.leading)

                                    }
                                    Spacer()
                                }
                                .frame(height: 80, alignment: .center)
                                .cornerRadius(15)
                            }
                            .padding(.horizontal,30)
                        }
                        .padding(5)
                    }
                }.padding(.horizontal)
            }
        }
        .ignoresSafeArea()
    }
}


//MARK: - preview
struct PromptsView_Previews: PreviewProvider {
    static var previews: some View {
        PromptsView(selectedTab: .gratitude)
    }
}
