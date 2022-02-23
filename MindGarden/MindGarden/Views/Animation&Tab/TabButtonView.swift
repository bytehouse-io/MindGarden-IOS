//
//  TabView.swift
//  MindGarden
//
//  Created by Vishal Davara on 23/02/22.
//

import SwiftUI

struct TabButtonView: View {
    @Binding var selectedTab: TabType
    @State var color: Color = .purple
    
    var body: some View {
        HStack {
            ForEach(tabList) { item in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = item.tabName
                        color = item.color
                    }
                } label: {
                    VStack(spacing: 0) {
                        item.image
                            .renderingMode(.template)
                            .font(.body.bold())
                            .frame(width: 44, height: 29)
                    }
                    .foregroundColor(selectedTab == item.tabName ? .white : .black)
                    .frame(maxWidth: .infinity)
                }
                .blendMode(selectedTab == item.tabName ? .overlay : .normal)
                if item.tabName == .meditate {
                    Spacer().frame(maxWidth: .infinity)
                }
            }
        }
        
        .padding(.horizontal, 8)
        .padding(.top, 14)
        .frame(height: 88, alignment: .top)
        .background( Color.green.cornerRadius(40).opacity(0.2))
        .background( VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial)).cornerRadius(40) )
        .background(
            HStack {
                if selectedTab == .profile { Spacer() }
                if selectedTab == .meditate { Spacer() }
                if selectedTab == .shop {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                Circle().fill(color).frame(width: 88)
                if selectedTab == .garden { Spacer() }
                if selectedTab == .meditate {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                if selectedTab == .shop { Spacer() }
            }
            .padding(.horizontal, 8)
        )
        .overlay(
            HStack {
                if selectedTab == .profile { Spacer() }
                if selectedTab == .meditate { Spacer() }
                if selectedTab == .shop {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                Rectangle()
                    .fill(color)
                    .frame(width: 28, height: 5)
                    .cornerRadius(3)
                    .frame(width: 88)
                    .frame(maxHeight: .infinity, alignment: .top)
                if selectedTab == .garden { Spacer() }
                if selectedTab == .meditate {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                if selectedTab == .shop { Spacer() }
            }
                .padding(.horizontal, 8)
        )
        .strokeStyle(cornerRadius: 34)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
}
