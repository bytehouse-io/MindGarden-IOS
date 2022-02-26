//
//  PlusMenuView.swift
//  MindGarden
//
//  Created by Vishal Davara on 24/02/22.
//

import SwiftUI

struct PlusMenuView: View {
    @Binding var showPopup: Bool
    @Binding var selectedOption: PlusMenuType
    @State var opac: CGFloat = 0.01
    @Binding var isOnboarding: Bool
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                ForEach(plusMenuList) { item in
                    Button {
                        selectedOption = item.tabName
                        showPopup = false
                    } label: {
                        MenuChoice(title: item.title, img: Image(systemName: item.image), disabled: false)
                    }.disabled((isOnboarding && (item.tabName == .moodCheck && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "signedUp")) || (isOnboarding && (item.tabName == .gratitude && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "mood")) || (isOnboarding && (item.tabName == .meditate && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude"))).opacity((isOnboarding && (item.tabName == .moodCheck && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "signedUp")) || (isOnboarding && (item.tabName == .gratitude && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "mood")) || (isOnboarding && (item.tabName == .meditate && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude")) ? 0.5 : 1.0)
                }
            }
            .scaleEffect(opac)
            .opacity(opac)
            .padding()
        }.onChange(of: showPopup) { value in
            withAnimation(.easeInOut(duration: 0.3)) {
                opac =  value ? 1.0 : 0.01
            }
        }
    }
    
    struct MenuChoice: View {
        let title: String
        let img: Image
        let disabled: Bool

        var body: some View {
            ZStack {
                Capsule()
                    .fill(Clr.darkWhite)
                HStack {
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Clr.darkgreen)
                        .padding(3)
                    Text(title)
                        .font(Font.mada(.medium, size: 20))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Clr.darkgreen)
                        .frame(width: UIScreen.main.bounds.width * 0.3)
                        .multilineTextAlignment(.trailing)
                }.frame(width: UIScreen.main.bounds.width * 0.4, alignment: .leading)
                .padding(5)
            }
            .opacity(disabled ? 0.3 : 1)
            .neoShadow()
        }
    }
}


enum PlusMenuType: String {
    case moodCheck
    case gratitude
    case meditate
    case none
}

var plusMenuList = [
    PlusMenuItem(title: "Mood Check", image: "face.smiling", tabName: .moodCheck),
    PlusMenuItem(title: "Gratitude", image: "square.and.pencil", tabName: .gratitude),
    PlusMenuItem(title: "Meditate", image: "play", tabName: .meditate)
]

struct PlusMenuItem: Identifiable {
    var id = UUID()
    var title: String
    var image: String
    var tabName: PlusMenuType
}
