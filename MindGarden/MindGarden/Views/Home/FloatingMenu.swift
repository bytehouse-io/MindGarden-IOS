//
//  FloatingMenu.swift
//  MindGarden
//
//  Created by Vishal Davara on 06/09/22.
//

import SwiftUI


enum MenuType: String, CaseIterable {
    case bonus, profile,recent,favorites, plantselect
    var id: String { return self.rawValue }
    
    var image:Image {
        switch self {
        case .profile:
            return Img.menuProfile
        case .bonus:
            return Img.coin
        case .favorites:
            return Img.menuFavourite
        case .recent:
            return Img.menuRecent
        case .plantselect:
            return Img.menuPlantSelect
        }
    }
    
    var delay:Double {
        switch self {
        case .profile:
            return 1.0
        case .bonus:
            return 2.0
        case .favorites:
            return 3.0
        case .recent:
            return 4.0
        case .plantselect:
            return 5.0
        }
    }
}

struct FloatingMenu: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @Binding var showModal : Bool
    @Binding var activeSheet: Sheet?
    @Binding var totalBonuses : Int
    
    @State var isOpen = false
    @State var width = 60.0
    @State var scale = 0.0
    @State var offset = 0
    @State var rotation = 0.0
    @State var sheetTitle: String = ""
    @State var showRecFavs = false
    @State var sheetType: [Int] = []

    var body: some View {
        ZStack(alignment:.top) {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                DispatchQueue.main.async {
                    isOpen.toggle()
                }
            } label: {
                if isOpen {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height:15)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Capsule().fill(Clr.redGradientBottom).opacity(0.85))
                        .overlay(Capsule().stroke(.black, lineWidth: 1))
                } else {
                    Group {
                        if totalBonuses > 0 {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height:20)
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Capsule().fill(Clr.yellow))
                                .overlay(Capsule().stroke(.black, lineWidth: 1))
                                .overlay(badgeIcon)
                                .wiggling1()
                        } else {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height:20)
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Capsule().fill(Clr.yellow))
                                .overlay(Capsule().stroke(.black, lineWidth: 1))
                                .overlay(badgeIcon)
                        }
                    }
                }
            }.rotationEffect(Angle(degrees: rotation))
        }
        .onChange(of: isOpen) { newVal in
            if newVal {
                scale = 0.0
                offset = -50
                rotation = 0.0
                DispatchQueue.main.async {
                    withAnimation(.interpolatingSpring(stiffness: 50, damping: 26)) {
                        scale = 1.0
                        offset = 0
                        rotation = 90
                    }
                }
            } else {
                rotation = 0.0
                scale = 1.0
                DispatchQueue.main.async {
                    withAnimation(.interpolatingSpring(stiffness: 50, damping: 26)) {
                        scale = 0.0
                    }
                }
            }
        }
        .background(
            ZStack {
                if isOpen {
                    Color.black.opacity(0.4)
                        .onTapGesture {
                            withAnimation(.interpolatingSpring(stiffness: 50, damping: 26)) {
                                isOpen = false
                            }
                        }
                }
            }
                .frame(width: UIScreen.screenWidth*2.5, height: UIScreen.screenHeight*3, alignment: .center)
        )
        .overlay(menuItem)
        .sheet(isPresented: $showRecFavs) {
            ShowRecsScene(meditations: sheetType, title: $sheetTitle)
        }
        
    }
    var badgeIcon: some View {
        ZStack {
            if totalBonuses > 0, !isOpen {
                HStack(spacing:0) {
                    ZStack {
                        Circle()
                            .frame(width:20, height: 20)
                            .foregroundColor(Clr.redGradientBottom)
                            .overlay(Capsule().stroke(.black, lineWidth: 1))
                        Text("\(totalBonuses)")
                            .font(Font.fredoka(.medium, size: 12))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.005)
                            .frame(width: 10)
                    }.frame(width: 15)
                }
            }
        }.offset(x:width/3.5,y:-width/3.5)
    }
    
    var menuItem: some View {
        VStack(alignment:.leading, spacing:20) {
            ForEach(MenuType.allCases, id: \.id) { state in
                if (state != .favorites || (state == .favorites && !medModel.favoritedMeditations.isEmpty)) && (state != .recent || (state == .recent && !userModel.completedMeditations.isEmpty)) {
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    DispatchQueue.main.async {
                        buttonAction(type: state)
                    }
                } label: {
                    HStack {
                        if totalBonuses > 0, state == .bonus {
                            HStack(spacing:0) {
                                ZStack {
                                    Circle().frame(width:20,height: 20)
                                        .foregroundColor(Clr.redGradientBottom)
                                        .overlay(Capsule().stroke(.black, lineWidth: 1))
                                    Text("\(totalBonuses)")
                                        .font(Font.fredoka(.medium, size: 12))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.005)
                                        .frame(width: 10)
                                }.frame(width: 15)
                                    .padding([.leading,.vertical],10)
                                    .padding(.trailing,10)
                                Text(getTitle(type:state))
                                    .font(Font.fredoka(.medium, size: 16))
                                    .foregroundColor(Clr.redGradientBottom)
                                    .padding([.trailing,.vertical],10)
                            }
                            .background(
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .addBorder(.black, cornerRadius: 25)
                                    .frame(height: 35)
                            ).wiggling1()
                        } else {
                            HStack(spacing:0) {
                                state.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height:20)
                                    .padding([.leading,.vertical],10)
                                    .padding(.trailing,10)
                                Group {
                                    if state == .bonus {
                                        Text("\(userModel.coins)")
                                    } else {
                                        Text(getTitle(type:state))
                                    }
                                }
                                .font(Font.fredoka(.medium, size: 16))
                                .foregroundColor( Clr.black2)
                                .padding([.trailing,.vertical],10)
                            }
                            .background(
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .addBorder(.black, cornerRadius: 25)
                                    .frame(height: 35)
                            )
                        }
                    }.frame(height: 30)
                        .scaleEffect(scale, anchor: .leading)
                        .offset(x:width/2,y:CGFloat(offset))
                    
                }
                .buttonStyle(ScalePress())
                }
            }
        }.frame(width: 300, alignment: .leading)
            .offset(x:100,y:160)
//            .opacity(isOpen ? 1.0 : 0.0)
    }
    
    private func buttonAction(type:MenuType) {
        withAnimation(.interpolatingSpring(stiffness: 50, damping: 26)) {
            isOpen.toggle()
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        switch type {
        case .profile:
            Analytics.shared.log(event: .home_tapped_profile)
            activeSheet = .profile
        case .bonus:
            Analytics.shared.log(event: .home_tapped_bonus)
            withAnimation {
                DispatchQueue.main.async {
                    showModal = true
                }
            }
        case .favorites:
            Analytics.shared.log(event: .home_tapped_favorites)
            withAnimation {
                sheetTitle = "Your Favorites"
                sheetType = medModel.favoritedMeditations.reversed()
                showRecFavs = true
            }
  
            break
        case .recent:
            Analytics.shared.log(event: .home_tapped_recents)
            withAnimation {
                sheetTitle = "Your Recents"
                sheetType = userModel.completedMeditations.compactMap({ Int($0)}).reversed().unique()
                showRecFavs = true
            }
            break
        case .plantselect:
            Analytics.shared.log(event: .home_tapped_plant_select)
            activeSheet = .plant
        }
    }
    
    private func getTitle(type:MenuType) -> String {
        switch type {
        case .profile:
            return "Profile"
        case .bonus:
            return "Bonus!"
        case .favorites:
            return "Favorites"
        case .recent:
            return "Recent"
        case .plantselect:
            return "Plant Select"
        }
    }
}
