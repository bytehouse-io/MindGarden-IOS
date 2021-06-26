//
//  ShadowViewModifier.swift
//  MindGarden
//
//  Created by Dante Kim on 6/12/21.
//

import SwiftUI
struct ShadowViewModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .shadow(color: Clr.shadow.opacity(0.3), radius: 5 , x: 5, y: 5)
            .shadow(color: Color.white.opacity(0.95), radius: 5, x: -5, y: -5)
    }
}

extension View {
    /// Adds a shadow onto this view with the specified `ShadowStyle`
    func neoShadow() -> some View {
        self.modifier(ShadowViewModifier())
    }
}
