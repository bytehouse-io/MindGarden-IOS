//
//  TabView.swift
//  MindGarden
//
//  Created by Vishal Davara on 23/02/22.
//

import SwiftUI

struct TabButtonView: View {
    @Binding var selectedTab: TabType
    @State var color: Color = .white
    @Binding var isOnboarding: Bool
    
    var body: some View {
        HStack {
            ForEach(tabList) { item in
                Button {
                    if !isOnboarding {
                        DispatchQueue.main.async {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = item.tabName
                                color = item.color
                            }
                        }
                    }
                } label: {
                    VStack(spacing: 0) {
                        item.image
                            .renderingMode(.template)
                            .font(.body.bold())
                            .frame(width: 44, height: 29)
                    }
                    .foregroundColor(selectedTab == item.tabName ? .white : Clr.unselectedIcon)
                    .frame(maxWidth: .infinity)
                }
                if item.tabName == .meditate {
                    Spacer().frame(maxWidth: .infinity)
                }
            }
        }
        
        .padding(.horizontal, 8)
        .padding(.top, 14)
        .frame(height: 88, alignment: .top)
        .background( Clr.darkgreen.cornerRadius(40))
        .overlay(
            HStack {
                if selectedTab == .shop { Spacer() }
                if selectedTab == .meditate { Spacer() }
                if selectedTab == .learn {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                Rectangle()
                    .fill(color)
                    .frame(width: 45, height: 5)
                    .cornerRadius(3)
                    .frame(width: 88)
                    .frame(maxHeight: .infinity, alignment: .top)
                if selectedTab == .garden { Spacer() }
                if selectedTab == .meditate {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                if selectedTab == .learn { Spacer() }
            }
                .padding(.horizontal, 5)
        )
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
}
