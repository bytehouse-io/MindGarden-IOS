//
//  MoodElaborate.swift
//  MindGarden
//
//  Created by Vishal Davara on 05/07/22.
//

import SwiftUI

struct MoodElaborate: View {
    @State var selectedMood: Mood
    @State private var selectedSubMood: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDetail = false
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height:40)
                HStack() {
                    Text("\(Date().toString(withFormat: "EEEE, MMM dd"))")
                        .font(Font.fredoka(.regular, size: 16))
                        .foregroundColor(Clr.black2)
                        .padding(.leading,30)
                    Spacer()
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
                        .padding(.trailing,30)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                .frame(width: UIScreen.screenWidth)
                selectedMood.moodImage
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
                        ForEach(selectedMood.options, id: \.self) { item in
                            Button {
                                selectedSubMood = item
                                showDetail = true
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
        }
        .fullScreenCover(isPresented: $showDetail) {
            PromptsDetailView(selectedMood: selectedMood,selectedSubMood:$selectedSubMood)
                .environmentObject(MoodModel())
        }
    }
}
