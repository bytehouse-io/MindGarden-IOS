//
//  HomeTabView.swift
//  MindGarden
//
//  Created by Vishal Davara on 22/02/22.
//

import SwiftUI

struct HomeTabView: View {
    
    // MARK: - Properties
    
    @Binding var selectedOption: PlusMenuType
    @ObservedObject var viewRouter: ViewRouter
    @Binding var selectedTab: TabType
    @Binding var showPopup: Bool
    @State var scale: CGFloat = 0.01
    @Binding var isOnboarding: Bool
    @State private var playEntryAnimation = false
    
    // MARK: - Body

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
                .offset(y: -16)
            TabButtonView(selectedTab: $selectedTab, isOnboarding: $isOnboarding)
                .padding([.bottom, .horizontal], 20)
            PlusButtonPopup(showPopup: $showPopup, scale: $scale, selectedOption: $selectedOption, isOnboarding: $isOnboarding)
        } //: ZStack
        .onChange(of: selectedTab) { value in
            showPopup = false
            DispatchQueue.main.async {
                setSelectedTab(selectedTab: value)
            }
        }
    }

    private func setSelectedTab(selectedTab: TabType) {
        let tabName = selectedTab.rawValue.capitalized
        // Analytics.shared.log(event: AnalyticEvent.getTab(tabName: tabName))
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.linear(duration: 0.4)) {
            let onboardingValue = DefaultsManager.standard.value(forKey: .onboarding).onboardingValue
            switch onboardingValue {
            case .done, .stats, .garden, .single:
                switchTab(selectedTab)
                return
            case .none, .signedUp, .mood, .gratitude, .meditate, .calendar:
                break
            }
            
            if DefaultsManager.standard.value(forKey: .review).boolValue {
                switchTab(selectedTab)
            }
//            if UserDefaults.standard.string(forKey: K.defaults.on4boarding) == "done" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "garden" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "single" || UserDefaults.standard.bool(forKey: "review") {
//
//            }
        }
    }
    
    private func switchTab(_ selectedTab: TabType) {
        switch selectedTab {
        case .garden:
            viewRouter.currentPage = .garden
        case .meditate:
            viewRouter.currentPage = .meditate
        case .shop:
            viewRouter.currentPage = .shop
        case .search:
            viewRouter.currentPage = .quickStart
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(selectedOption: .constant(.meditate), viewRouter: ViewRouter(), selectedTab: .constant(.meditate), showPopup: .constant(false), isOnboarding: .constant(false))
    }
}
