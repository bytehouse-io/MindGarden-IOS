//
//  PlantGrowing.swift
//  demo
//
//  Created by Vishal Davara on 04/04/22.
//

import SwiftUI

struct PlantGrowing: View {
    @State private var isTransit = false
    @State private var shake = 0
    @State private var calendarWiggles = false
    
    var body: some View {
        ZStack {
            VStack {
                if !isTransit {
                    Img.seedPacket
                        .modifier(Shake1(animatableData: CGFloat(shake)))
                        .rotationEffect(.degrees(calendarWiggles ? -8 : 16), anchor: .bottom)
                        .animation(Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true))
                } else {
                    FlowerPop()
                        .transition(.scale)
                }
            }
        }
        .onAppear() {
            DispatchQueue.main.async {
                withAnimation(.linear(duration: 3.0)) {
                    calendarWiggles = true
                    shake = 10
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

struct Shake1: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)) ))
    }
}

