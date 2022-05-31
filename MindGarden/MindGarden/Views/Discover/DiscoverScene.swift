//
//  DiscoverScene.swift
//  MindGarden
//
//  Created by Vishal Davara on 26/05/22.
//

import SwiftUI
import Lottie

struct DiscoverScene: View {
    @State private var selectedTab: DiscoverTabType = .quickStart
    var body: some View {
        ZStack(alignment:.top) {
            Clr.darkWhite
            let width = UIScreen.screenWidth
            ZStack(alignment:.top) {
                Arc(startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                    .fill(Clr.yellow)
                    .frame(width: width, height: width*0.83)
                    .offset(y:-width)
                VStack {
                    Spacer().frame(height:(width*0.13))
                    HStack {
                        Text("Discover")
                            .minimumScaleFactor(0.5)
                            .font(Font.mada(.bold, size: 32))
                            .foregroundColor(Clr.darkgreen)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Img.discoverSearch
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(height:35)
                    .padding(.vertical,5)
                    .padding(.horizontal,30)
                    DiscoverTab(selectedTab: $selectedTab)
                        .padding(.horizontal,30)
                        .frame( height:36)
                }
            }
            .zIndex(1)
            VStack(spacing:0) {
                Spacer().frame(height:(width/2)*0.8)
                tabView
                    .zIndex(0)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var tabView: some View {
        return Group {
            switch selectedTab {
            case .courses:
                Clr.darkWhite
            case .quickStart:
                QuickStart()
            case .learn:
                Clr.darkWhite
            }
        }
    }
}

struct DiscoverScene_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverScene()
    }
}

struct Arc: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = UIScreen.screenWidth
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: clockwise)
        return path
    }
}
