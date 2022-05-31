//
//  DiscoverTab.swift
//  MindGarden
//
//  Created by Vishal Davara on 27/05/22.
//

import SwiftUI

struct DiscoverTab: View {
    
    @Binding var selectedTab: DiscoverTabType
    
    var body: some View {
        ZStack (alignment:.center) {
            HStack {
                if selectedTab == .learn { Spacer() }
                if selectedTab == .quickStart { Spacer() }
                Capsule()
                    .fill(.white.opacity(0.4))
                    .frame(width:UIScreen.screenWidth*0.27)
                    .padding(.vertical,3)
                if selectedTab == .quickStart { Spacer() }
                if selectedTab == .courses { Spacer() }
            }.padding(.horizontal,3)
            HStack(alignment:.center) {
                ForEach(discoverTabList) { item in
                    Button {
                        DispatchQueue.main.async {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = item.tabName
                            }
                        }
                    } label: {
                        ZStack(alignment:.center) {
                            Text(item.name)
                                .minimumScaleFactor(0.5)
                                .font(Font.mada(.medium, size: 16))
                                .foregroundColor(selectedTab == item.tabName ? .white : Clr.unselectedIcon)
                                .multilineTextAlignment(.center)
                                .padding(.leading, item.name == "Courses" ? 10 : 0)
                                .padding(.trailing, item.name == "Learn" ? 10 : 0)
                        }
                        .foregroundColor(selectedTab == item.tabName ? .white : Clr.unselectedIcon)
                        .frame(maxWidth: .infinity)
                        
                    }
                }
            }
            .padding(.vertical,5)
        }
        .frame(height: 36, alignment: .top)
        .background(
            Clr.darkgreen
            .cornerRadius(18)
                .shadow(color: Clr.blackShadow.opacity(0.4), radius: 2, x: 2, y: 2)
        )
    }
}
