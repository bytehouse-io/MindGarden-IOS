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
                Img.loadingyour
            }
        }.ignoresSafeArea()
    }
}
