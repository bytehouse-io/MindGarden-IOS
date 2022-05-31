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
    var body: some View {
        if isShowCategory {
            CategoriesScene(isSearch: false, showSearch: .constant(true), isBack: $isShowCategory, isFromQuickstart: true, selectedCategory:category)
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                Spacer()
                    .frame(height:20)
                ForEach(quickStartTabList) { item in
                    Button {
                        withAnimation {
                            category = item.title
                            isShowCategory = true
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .frame(height: 56.0, alignment: .center)
                                .cornerRadius(27)
                                .neoShadow()
                            HStack {
                                Text(item.name)
                                    .font(Font.mada(.semiBold, size: 16))
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.center)
                                    .padding(15)
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
                }
                Spacer()
                    .frame(height:100)
            }
        }
    }
}


struct QuickStart_Previews: PreviewProvider {
    static var previews: some View {
        QuickStart()
    }
}
