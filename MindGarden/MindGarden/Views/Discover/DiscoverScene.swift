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
            Arc(startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                .fill(Clr.yellow)
                .frame(width: width, height: width)
                .offset(y:-UIScreen.screenWidth)
            VStack(spacing:0) {
                Spacer().frame(height:50)
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
                        .frame(width: 40)
                }
                .padding()
                .padding(.horizontal,30)
                DiscoverTab(selectedTab: $selectedTab)
                    .padding(.horizontal,30)
                    .frame( height:50)
                Spacer().frame(height:35)
                tabView
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
        path.addArc(center: CGPoint(x: rect.midX - 5, y: rect.midY),
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: clockwise)
        return path
    }
}
