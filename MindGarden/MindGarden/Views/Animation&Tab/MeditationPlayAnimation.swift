//
//  MeditationPlayAnimation.swift
//  MindGarden
//
//  Created by Vishal Davara on 25/06/22.
//

import SwiftUI

struct MeditationPlayAnimation : View {
    
    @State private var bgAnimation: Bool = false
    
    var body: some View {
        ZStack {
            Clr.darkgreen
            
            CustomShape(radius: 50 )
                .fill(Color.purple)
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .scaleEffect(bgAnimation ? 2.2 : 0)
            
//            Circle()
//                .stroke(lineWidth: 20.0)
//                .frame(width:100)
//                .foregroundColor(Clr.superLightGray)
        }.onAppear() {
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5).repeatForever()) {
                bgAnimation = true
            }
        }
    }
}
