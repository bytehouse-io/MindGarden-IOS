//
//  WiggleModifier.swift
//  MindGarden
//
//  Created by Vishal Davara on 18/03/22.

import SwiftUI

extension View {
    func wiggling() -> some View {
        modifier(WiggleModifier())
    }
}

struct WiggleModifier: ViewModifier {
    @State private var isWiggling1 = false
    @State private var buttonRotating = -10.0
    
    private let rotateAnimation = Animation
        .interpolatingSpring(stiffness: 170, damping: 5)
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(Double(buttonRotating)), anchor: .center)
            .animation(rotateAnimation.repeatForever(autoreverses: false), value: buttonRotating)
            .onAppear() {
                withAnimation(Animation.interpolatingSpring(stiffness: 170, damping: 5)) {
                    buttonRotating = 0
                }
            }
    }
}
