//
//  SplashView.swift
//  MindGarden
//
//  Created by Vishal Davara on 20/03/22.
//

import SwiftUI

struct SplashView: View {
    @State private var text = "  "
    var body: some View {
        ZStack(alignment:.center) {
            Color.white
            Img.mindGardenSplash
                .resizable()
                .aspectRatio(contentMode: .fill)
            HStack(alignment:.bottom) {
                Img.plant
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth:80)
                VStack(alignment:.leading) {
                    Text("Loading your")
                        .frame(alignment:.leading)
                        .font(Font.mada(.bold, size: 28))
                        .foregroundColor(Clr.black1)
                    HStack {
                        Text("MindGarden")
                            .frame(alignment:.leading)
                            .font(Font.mada(.bold, size: 36))
                            .foregroundColor(Clr.brightGreen)
                            .padding(0)
                        Text(text)
                            .frame(width:32)
                            .frame(alignment:.leading)
                            .lineLimit(1)
                            .font(Font.mada(.bold, size: 36))
                            .foregroundColor(Clr.brightGreen)
                            .padding(0)
                    }
                }
            }
        }.ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        text = ".  "
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        text = ".. "
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        text = "..."
                    }
                }
            }
    }
}
