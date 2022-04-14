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
    @Binding var plant : Plant?
    
    var body: some View {
        ZStack {
            VStack {
                if !isTransit {
                    Img.seedPacket
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth*0.6, alignment: .center)
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
            if let selectedPlant = plant?.id, (Plant.badgePlants.first(where: { $0.id == selectedPlant }) != nil) {
                isTransit = true
            } else {
                DispatchQueue.main.async {
                    MGAudio.sharedInstance.stopSound()
                    MGAudio.sharedInstance.playSound(soundFileName: "seedPacket.wav")
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
}


struct PlantGrowing_Previews: PreviewProvider {
    static var previews: some View {
        PlantGrowing(plant: .constant(nil))
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

