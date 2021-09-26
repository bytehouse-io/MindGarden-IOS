//
//  ButtonStyle.swift
//  Lottery.com
//
//

import SwiftUI

struct NeumorphicPress: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98: 1)
            .animation(.easeOut(duration: 0.1))
            .shadow(color: Clr.shadow.opacity(0.3), radius: configuration.isPressed ? 1 : 5 , x: configuration.isPressed ? 1 : 5, y: configuration.isPressed ? 1 : 5)
            .shadow(color: Color.white.opacity(0.95), radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? -1 : -5, y: configuration.isPressed ? -1 : -5)
    }
}

