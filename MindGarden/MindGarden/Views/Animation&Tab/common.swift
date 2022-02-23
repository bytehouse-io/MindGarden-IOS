//
//  common.swift
//  MindGarden
//
//  Created by Vishal Davara on 20/02/22.
//

import SwiftUI

extension View {

    func plusPopupStyle(size:CGSize, scale:CGFloat) -> some View {
        self.frame(width: size.width/2, height: size.width/2)
            .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
            .animation(.spring())
    }
    
    func plusButtonStyle(scale:CGFloat) -> some View {
        self.frame(width: 55, height: 55)
            .overlay(Image(systemName: "plus")
                        .foregroundColor(Color.green)
                        .font(Font.title.weight(.semibold))
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(scale < 1.0 ? .degrees(0) : .degrees(135) )
                        .animation(.spring())
                        )
            
    }
    func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(StrokeStyleNew(cornerRadius: cornerRadius))
    }
}

struct StrokeStyleNew: ViewModifier {
    var cornerRadius: CGFloat
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.6 : 0.3),
                            .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                        ], startPoint: .top, endPoint: .bottom
                    )
                )
                .blendMode(.overlay)
        )
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
