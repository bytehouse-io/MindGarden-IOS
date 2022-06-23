//
//  CircularLoading.swift
//  MindGarden
//
//  Created by Vishal Davara on 22/06/22.
//

import SwiftUI

struct CircleLoadingView<Content>: View where Content: View {
    struct ActivityIndicator: UIViewRepresentable {

        @Binding var isAnimating: Bool
        let style: UIActivityIndicatorView.Style

        func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
            return UIActivityIndicatorView(style: style)
        }

        func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
            isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        }
    }

    @Binding var isShowing: Bool
    @State var animationDuration = 5000
    var content: () -> Content
    
    @State private var playanim = false
    @State private var percentage = 0
    var body: some View {
            ZStack {
                self.content()
                    .disabled(self.isShowing)
                Circle().fill(.white)
                    .frame(width:100)
                Img.circle
                    .resizable()
                    .frame(width:120,height:115)
                    .foregroundColor(.white.opacity(0.4))
                    .rotationEffect(Angle(degrees: playanim ? 360 : 0 ))
                    .animation(.linear(duration: 6).repeatForever(autoreverses: false))
                    .offset(y:-10)
                Img.circle
                    .resizable()
                    .frame(width:110,height:110)
                    .foregroundColor(.white.opacity(0.4))
                    .rotationEffect(Angle(degrees: playanim ? 360 : 0 ))
                    .animation(.linear(duration: 6).repeatForever(autoreverses: false))
                    .offset(y:10)
                Img.circle
                    .resizable()
                    .frame(width:120,height:115)
                    .foregroundColor(.white.opacity(0.4))
                    .rotationEffect(Angle(degrees: playanim ? -360 : 0 ))
                    .animation(.linear(duration: 5).repeatForever(autoreverses: false))
                    .offset(x:5)
                Img.circle
                    .resizable()
                    .frame(width:125,height:110)
                    .foregroundColor(.white.opacity(0.4))
                    .rotationEffect(Angle(degrees: playanim ? -360 : 0 ))
                    .animation(.linear(duration:4).repeatForever(autoreverses: false))
                    .offset(x:-5)
            Text("  \(percentage)%  ")
                .foregroundColor(Clr.black2)
                .minimumScaleFactor(0.5)
                .font(Font.mada(.bold, size: 16))
                .animation(.linear(duration: 5))
            }
            .opacity(self.isShowing ? 1 : 0)
            .onAppear() {
                withAnimation {
                    playanim = true
                }
                addNumberWithRollingAnimation()
            }
    }
    
    private func addNumberWithRollingAnimation() {
        withAnimation {
            let steps = 100
            let stepDuration = (animationDuration / steps)
            
            percentage += 100 % steps
            (0..<steps).forEach { step in
                let updateTimeInterval = DispatchTimeInterval.milliseconds(step * stepDuration)
                let deadline = DispatchTime.now() + updateTimeInterval
                
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    self.percentage += Int(100 / steps)
                }
            }
        }
    }

}
