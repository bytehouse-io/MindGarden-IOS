//
//  PlantGrowing.swift
//  demo
//
//  Created by Vishal Davara on 04/04/22.
//

import SwiftUI

struct PlantGrowing: View {
    @State private var buttonRotating = -20.0
    @State private var scale = 0.0
    @State private var isTransit = false
    
    var body: some View {
        ZStack {
            VStack {
                if !isTransit {
                    Img.seedPacket
                        .scaleEffect(CGSize(width: scale, height: scale))
                        .rotationEffect(.degrees(Double(buttonRotating)), anchor: .center)
                        .animation(Animation
                                    .interpolatingSpring(stiffness: 170, damping: 5), value: buttonRotating)
                } else {
                    FlowerPop()
                        .transition(.scale)
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


struct PlantGrowing_Previews: PreviewProvider {
    static var previews: some View {
        PlantGrowing()
    }
}
