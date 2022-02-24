//
//  HomeTabView.swift
//  MindGarden
//
//  Created by Vishal Davara on 22/02/22.
//

import SwiftUI

struct HomeTabView: View {
    @Binding var selectedOption: PlusMenuType
    
    @ObservedObject var viewRouter: ViewRouter
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
                        }
                    }
                }
            TabButtonView(selectedTab:$selectedTab)
            PlusButtonPopup(showPopup: $showPopup, scale: $scale, selectedOption: $selectedOption)
        }.onChange(of: selectedTab) { value in
            showPopup = false
            setSelectedTab(selectedTab: value)
        }
    }
    
    private func setSelectedTab(selectedTab:TabType){
        let tabName = selectedTab.rawValue.capitalized
        Analytics.shared.log(event: AnalyticEvent.getTab(tabName: tabName))
        withAnimation {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "single"  {
                switch selectedTab {
                case .garden:
                    viewRouter.currentPage = .garden
                case .meditate:
                    viewRouter.currentPage = .meditate
                case .shop:
                    viewRouter.currentPage = .shop
                case .learn:
                    viewRouter.currentPage = .learn
                }
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(selectedOption: .constant(.meditate), viewRouter: ViewRouter())
    }
}
