//
//  LoadingIllusion.swift
//  MindGarden
//
//  Created by Dante Kim on 6/24/22.
//

import SwiftUI

struct LoadingIllusion: View {
    @State private var showCircleProgress = true
    var body: some View {
        CircleLoadingView(isShowing: $showCircleProgress) {
                ZStack {
                    Clr.darkgreen
                }
            }
    }
}

struct LoadingIllusion_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIllusion()
    }
}
