//
//  PlantGrowing.swift
//  demo
//
//  Created by Vishal Davara on 04/04/22.
//

import SwiftUI

struct PlantGrowing: View {
    @State private var buttonRotating = -10.0
    @State private var scale = 0.0
    @State private var isTransit = false
    let title = "New!\n Red Tulips"
    
    var body: some View {
        ZStack {
            LottieAnimationView(filename: "background", loopMode: .loop, isPlaying: .constant(true))
                .frame(width: 630, height: 1000, alignment: .center)
            VStack {
                if !isTransit {
                    Img.seedPacket
                        .scaleEffect(CGSize(width: scale, height: scale))
                        .rotationEffect(.degrees(Double(buttonRotating)), anchor: .center)
                        .animation(Animation
                                    .interpolatingSpring(stiffness: 170, damping: 5), value: buttonRotating)
                } else {
                    ZStack {
                        FlowerPop()
                            .transition(.scale)
                        VStack {
                            Spacer()
                                .frame(height: 100, alignment: .center)
                            Text(title)
                                .font(.mada(.bold, size: 40))
                                .foregroundColor(Clr.superBlack)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear() {
            DispatchQueue.main.async {
                withAnimation(Animation.interpolatingSpring(stiffness: 170, damping: 5)) {
                    buttonRotating = 0
                    scale = 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation() {
                    isTransit = true
                }
            }
        }
    }
}
