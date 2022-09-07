//
//  FloatingMenu.swift
//  MindGarden
//
//  Created by Vishal Davara on 06/09/22.
//

import SwiftUI


enum MenuType: String, CaseIterable {
    case profile,bonus,favourite,recent,plantselect
    var id: String { return self.rawValue }
    
    var image:Image {
        switch self {
        case .profile:
            return Img.menuProfile
        case .bonus:
            return Img.coin
        case .favourite:
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
        case .favourite:
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
    @Binding var showModal : Bool
    @Binding var activeSheet: Sheet?
    @Binding var totalBonuses : Int
    
    @State var isOpen = false
    @State var width = 60.0
    @State var scale = 0.0
    @State var offset = 0
    var body: some View {
        ZStack(alignment:.top) {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                DispatchQueue.main.async {
                    withAnimation(.interpolatingSpring(stiffness: 50, damping: 26)) {
                        isOpen.toggle()
                    }
                }
            } label: {
                let image =  isOpen ? Img.menuClose : Img.menu
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:width)
            }.rotationEffect(Angle(degrees: isOpen ?  180 : 0))
                .buttonStyle(ScalePress())
        }
        .onChange(of: isOpen) { newVal in
            if newVal {
                scale = 0.0
                offset = -50
                DispatchQueue.main.async {
                    withAnimation(.interpolatingSpring(stiffness: 50, damping: 26)) {
                        scale = 1.0
                        offset = 0
                    }
                }
            } else {
                scale = 1.0
                offset = 0
                DispatchQueue.main.async {
                    withAnimation(.interpolatingSpring(stiffness: 50, damping: 26)) {
                        offset = -20
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
        .overlay(
            ZStack {
                if totalBonuses > 0 {
                    HStack(spacing:0) {
                        ZStack {
                            Circle().frame(height: 16)
                                .foregroundColor(Clr.redGradientBottom)
                            Text("\(totalBonuses)")
                                .font(Font.fredoka(.medium, size: 12))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.005)
                                .frame(width: 10)
                        }.frame(width: 15)
                    }
                }
            }.offset(x:width/3,y:-width/3)
        )
    }
    
    var menuItem: some View {
        VStack(alignment:.leading,spacing:15) {
            ForEach(MenuType.allCases, id: \.id) { state in
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    DispatchQueue.main.async {
                        buttonAction(type: state)
                    }
                } label: {
                    HStack {
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
                            .foregroundColor(Clr.black2)
                            .padding([.trailing,.vertical],10)
                        }
                        .background(
                            Rectangle()
                                .fill(Clr.yellow)
                                .addBorder(.black, cornerRadius: 25)
                                .frame(height: 35)
                        )
                        if totalBonuses > 0, state == .bonus {
                            HStack(spacing:0) {
                                ZStack {
                                    Circle().frame(height: 16)
                                        .foregroundColor(Clr.redGradientBottom)
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
                                    .foregroundColor(Clr.black2)
                                    .padding([.trailing,.vertical],10)
                            }
                            
                            .background(
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .addBorder(.black, cornerRadius: 25)
                                    .frame(height: 35)
                            ).wiggling1()
                        }
                    }.frame(height: 30)
                        .scaleEffect(scale, anchor: .leading)
                        .offset(x:width/2,y:CGFloat(offset))
                    
                }
                .buttonStyle(ScalePress())
            }
        }.frame(width: 300, alignment: .leading)
            .offset(x:100,y:140)
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
        case .favourite:
            //TODO: implement faourites tap event
            break
        case .recent:
            //TODO: implement recent tap event
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
        case .favourite:
            return "Favourites"
        case .recent:
            return "Recent"
        case .plantselect:
            return "Plant Select"
        }
    }
}
