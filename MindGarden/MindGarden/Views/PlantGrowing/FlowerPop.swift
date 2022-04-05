//
//  FlowerPop.swift
//  demo
//
//  Created by Vishal Davara on 04/04/22.
//

import SwiftUI

struct FlowerPop: View {
    @State private var scale = 0.0
    
    var body: some View {
        ZStack {
            Img.flower
                .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
                .animation(Animation
                            .spring(response: 0.3, dampingFraction: 2.0), value: scale)
        }
        .onAppear() {
            DispatchQueue.main.async {
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 2.0)) {
                    scale = 1.0
                }
            }
        }
    }
}
