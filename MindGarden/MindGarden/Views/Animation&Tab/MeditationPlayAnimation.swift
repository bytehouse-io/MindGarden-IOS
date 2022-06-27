//
//  MeditationPlayAnimation.swift
//  MindGarden
//
//  Created by Vishal Davara on 25/06/22.
//

import SwiftUI

struct MeditationPlayAnimation : View {
    
    @State private var bgAnimation = false
    @State private var fadeAnimation = false
    @State private var isBally = false
    @State private var title = "Belly"
    
    @State var meditateTimer: Timer?
    
    @State var time = 3.0
    @State var size = 300.0
    
    var body: some View {
        ZStack {
            AnimatedBackground().edgesIgnoringSafeArea(.all)
                        .blur(radius: 50)
            Circle()
                .frame(width:size)
                .foregroundColor(Clr.brightGreen)
            
            Circle()
                .stroke(lineWidth:isBally ? 5 : size/2)
                .fill(Clr.yellow)
                .frame(width:size/2)
                .clipShape(Circle())
                .frame(width: size/2, height: size/2)
                .scaleEffect(bgAnimation ? 2 : 1)
                .opacity(fadeAnimation ? 0 : 1)
            ZStack {
                Circle()
                    .frame(width:size/2)
                    .foregroundColor(Clr.darkgreen)
                Text(title)
                    .font(Font.mada(.bold, size: 20))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.1)
            }
            
        }.onAppear() {
            meditateTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: true) { timer in
                if title == "Chest" {
                    title = "Exhale"
                } else {
                    title =  "Belly"
                    isBally = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + time/2) {
                        title =  "Chest"
                        isBally = false
                        fadeAnimation = true
                        withAnimation(.spring()) {
                            fadeAnimation = false
                        }
                    }
                }
                withAnimation(.linear(duration: time)) {
                    bgAnimation.toggle()
                }
            }
            
        }.onDisappear() {
            meditateTimer?.invalidate()
        }
    }
}


struct AnimatedBackground: View {
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    @State var duration = 6.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [Clr.brightGreen, Clr.yellow, Clr.darkgreen]
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: duration).repeatForever())
            .onReceive(timer, perform: { _ in
                
                self.start = UnitPoint(x: 4, y: 0)
                self.end = UnitPoint(x: 0, y: 2)
                self.start = UnitPoint(x: -4, y: 20)
                self.start = UnitPoint(x: 4, y: 0)
            })
    }
}
