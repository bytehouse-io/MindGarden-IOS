//
//  DiscoverTab.swift
//  MindGarden
//
//  Created by Vishal Davara on 27/05/22.
//

import SwiftUI

struct DiscoverTab: View {
    @Binding var selectedTab: TopTabType
    var body: some View {
        ZStack (alignment:.center) {
            HStack {
                if selectedTab == .learn { Spacer() }
                if selectedTab == .quickStart { Spacer() }
                Capsule()
                    .fill(.white.opacity(0.4))
                    .frame(width:UIScreen.screenWidth * 0.27)
                    .padding(.vertical,3)
                    .addBorder(.black, width: 1.5, cornerRadius: 30)
                    .offset(x: selectedTab == .learn ? 2 : -2)
                if selectedTab == .quickStart { Spacer() }
                if selectedTab == .journey { Spacer() }
            }.padding(.horizontal,3)
            HStack(alignment:.center) {
                ForEach(discoverTabList) { item in
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        DispatchQueue.main.async {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = item.tabName
                                if selectedTab == .journey {
                                    Analytics.shared.log(event: .screen_load_journey)
                                }
                            }
                        }
                    } label: {
                        ZStack(alignment:.center) {
                            Text(item.name)
                                .minimumScaleFactor(0.5)
                                .font(Font.fredoka(.medium, size: 16))
                                .foregroundColor(selectedTab == item.tabName ? .white : .white)
                                .multilineTextAlignment(.center)
                                .padding(.leading, item.name == "Courses" ? 10 : 0)
                                .padding(.trailing, selectedTab != .learn && item.name == "Library" ? 5 : 0)
                        }.foregroundColor(selectedTab == item.tabName ? .white : .white)
                        .frame(maxWidth: .infinity)
                    }
                }
            }.padding(.vertical,5)
        }
        .frame(height: 36, alignment: .top)
        .background(
            Clr.brightGreen
            .cornerRadius(16)
        )
        .addBorder(.black, width: 1, cornerRadius: 16)
        .shadow(color: Clr.blackShadow.opacity(0.4), radius: 2, x: 2, y: 2)
    }
}


