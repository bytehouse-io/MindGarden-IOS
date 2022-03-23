//
//  SplashView.swift
//  MindGarden
//
//  Created by Vishal Davara on 20/03/22.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack(alignment:.center) {
            Color.white
            Img.mindGardenSplash
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .center)
            VStack(alignment:.center) {
                Img.loadingyour
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.screenWidth*0.75)
            }.offset(y: -50)
        }
    }
}
