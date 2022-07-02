//
//  QuickStart.swift
//  MindGarden
//
//  Created by Vishal Davara on 28/05/22.
//

import SwiftUI

struct QuickStart: View {
    @State private var isShowCategory = false
    @State private var category : QuickStartType = .minutes3
    @State private var playEntryAnimation = false
    var body: some View {
        ZStack {
            if isShowCategory {
                CategoriesScene(isSearch: false, showSearch: .constant(true), isBack: $isShowCategory, isFromQuickstart: true, selectedCategory:category)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer()
                        .frame(height:15)
                    ForEach(quickStartTabList) { item in
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                category = item.title
                                middleToSearch = item.name
                                isShowCategory = true
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .frame(height: 56.0, alignment: .center)
                                    .cornerRadius(27)
                                    .neoShadow()
                                RoundedRectangle(cornerRadius: 27)
                                    .stroke(Color.black, lineWidth: 1)
                                    .frame(height: 56.0, alignment: .center)
                                HStack {
                                    Text(item.name)
                                        .font(Font.fredoka(.semiBold, size: 16))
                                        .foregroundColor(Clr.black2)
                                        .multilineTextAlignment(.center)
                                        .padding(.vertical, 15)
                                        .padding(.leading,20)
                                    Spacer()
                                    item.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 56.0)
                                }
                                .frame(height: 56.0, alignment: .center)
                                .cornerRadius(28)
                            }
                            .padding(.horizontal,30)
                        }
                        .padding(5)
                        .offset(y: playEntryAnimation ? 0 : 75)
                        .animation(.spring().delay(item.delay), value: playEntryAnimation)
                            .padding(5)
                    }
                }.padding(.bottom, 100)
                Spacer()
                    .frame(height:200)
            }
        }.onAppear {
            withAnimation {
                if middleToSearch != "" {
                    category = QuickStartMenuItem.getName(str: middleToSearch)
                    isShowCategory = true
                } else {
                    playEntryAnimation = true
                }
            }
        }
    }
}


struct QuickStart_Previews: PreviewProvider {
    static var previews: some View {
        QuickStart()
    }
}
