//
//  HomeTabView.swift
//  MindGarden
//
//  Created by Vishal Davara on 22/02/22.
//

import SwiftUI

struct HomeTabView: View {
    @State var selectedTab: TabType = .meditate
    @State var showPopup = false
    @State var scale : CGFloat = 0.01
    var body: some View {
        ZStack(alignment: .bottom) {
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
                .opacity(showPopup ? 0.5 : 0)
                .onTapGesture {
                    DispatchQueue.main.async {
                        withAnimation(.spring()) {
                            showPopup.toggle()
                            scale = scale < 1.0 ? 1.0 : 0.01
                        }
                    }
                }
            TabButtonView(selectedTab:$selectedTab)
            PlusButtonPopup(showPopup: $showPopup, scale: $scale)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
