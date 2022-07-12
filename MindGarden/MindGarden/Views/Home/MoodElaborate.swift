//
//  MoodElaborate.swift
//  MindGarden
//
//  Created by Vishal Davara on 05/07/22.
//

import SwiftUI

struct MoodElaborate: View {
    
    @EnvironmentObject var moodModel: MoodModel
    @State var selectedMood: NewMood
    @State private var selectedSubMood: String = ""
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
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
                    CloseButton() {
                        viewControllerHolder?.dismissController()
                    }.padding(.trailing,20)
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
                                moodModel.addMood(mood: MoodData(date: "\(Date().toString(withFormat: "EEEE, MMM dd"))", mood: selectedMood.rawValue, subMood: selectedSubMood))
                                selectedSubMood = item
                                viewControllerHolder?.present(style: .overFullScreen, builder: {
                                    PromptsDetailView()
                                        .environmentObject(MoodModel())
                                        .environmentObject(GardenViewModel())
                                        .environmentObject(UserViewModel())
                                })
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
    }
}
