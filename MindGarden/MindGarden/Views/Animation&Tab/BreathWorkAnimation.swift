//
//  MeditationPlayAnimation.swift
//  MindGarden
//
//  Created by Vishal Davara on 25/06/22.
//

import SwiftUI

struct BreathWorkAnimation : View {
    
    @State private var bgAnimation = false
    @State private var fadeAnimation = false
    @State private var isBally = false
    @State private var title = "Belly"
    
    @State var meditateTimer: Timer?
    
    @State var time = 3.0
    @State var size = 300.0
    @State private var showPanel = true
    @State private var timerCount:TimeInterval = 0.0
    @State private var scale = 0.0
    
    let panelHideDelay = 2.0
    let progress = 0.5
    let totalTime = 120.0
    let images = [Img.seed,Img.sunflower1,Img.sunflower2,Img.sunflower3]
    @State var timer: Timer?
    var body: some View {
        ZStack(alignment:.top) {
            AnimatedBackground().edgesIgnoringSafeArea(.all).blur(radius: 50)
            VStack {
                HStack {
                    Button {
                    } label: {
                        Image(systemName: "arrow.left.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Clr.darkWhite)
                            .aspectRatio(contentMode: .fit)
                            .frame(height:30)
                            .background(Circle().foregroundColor(Clr.black2).padding(1))
                            .neoShadow()
                    }
                    Spacer()
                    Spacer()
                    HStack{
                        sound
                        heart
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
                ZStack {
                    Circle()
                        .frame(width:size)
                        .foregroundColor(Clr.brightGreen)
                    Circle()
                        .stroke(lineWidth:isBally ? 5 : size/2)
                        .fill(Clr.yellow)
                        .frame(width:size/2)
                        .clipShape(Circle())
                        .scaleEffect(bgAnimation ? 2 : 1)
                        .opacity(fadeAnimation ? 0 : 1)
                    ZStack {
                        Circle()
                            .frame(width:size/2)
                            .foregroundColor(Clr.darkgreen)
                        VStack {
                            Spacer()
                            Text(title)
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.1)
                            Text(timerCount.secondsFromTimeInterval())
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(.white)
                                .opacity(showPanel ? 1.0 : 0.0)
                            Spacer()
                        }
                    }
                }.frame(height:size)
                VStack {
                    VStack(spacing:0) {
                        Img.grass
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .overlay(
                                plantView
                            )
                            .frame(maxWidth:.infinity)
                        ZStack {
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Clr.darkGray)
                                    .frame(width:geometry.size.width, height:15)
                                    .cornerRadius(25,corners: [.bottomLeft, .bottomRight])
                                Rectangle()
                                    .fill(Clr.brightGreen)
                                    .frame(width:geometry.size.width*progress, height:15)
                                    .cornerRadius(25,corners: [.bottomLeft, .bottomRight])
                            }
                        }
                        .frame(height:15)
                    }
                    .padding(.top,150)
                    VStack {
                        Button {}
                        label : {
                            ZStack {
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .addBorder(.black, width: 1.5, cornerRadius: 14)
                                Text("Pause")
                                    .font(Font.fredoka(.medium, size: 20))
                                    .foregroundColor(Clr.black2)
                            }
                        }
                        .frame(height:40)
                        Button {}
                        label : {
                            Text("I'm Done")
                                .font(Font.fredoka(.medium, size: 20))
                                .foregroundColor(Clr.black2)
                        }
                        .frame(height:40)
                    }
                    .padding(.top,30)
                    .opacity(showPanel ? 1.0 : 0.0)
                    Spacer()
                }.padding(.horizontal,30)
                Spacer()
            }
        }
        .onAppear() {
            toggleControllPanel()
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
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if timerCount <= totalTime {
                    timerCount += 1
                    if Int(timerCount) == Int(totalTime*0.25) + 1 || Int(timerCount) == Int(totalTime*0.50) + 1 || Int(timerCount) == Int(totalTime*0.75) + 1 {
                        scale = 0.0
                        withAnimation(Animation.spring(response: 0.3, dampingFraction: 3.0)) {
                            scale = 1.0
                        }
                    }
                } else {
                    timer.invalidate()
                }
            }
            
            DispatchQueue.main.async {
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 3.0)) {
                    scale = 1.0
                }
            }
        }
        .onDisappear() {
            meditateTimer?.invalidate()
            timer?.invalidate()
        }
        .onTapGesture {
            toggleControllPanel()
        }
    }
    
    var backArrow: some View {
        Image(systemName: "arrow.backward")
            .font(.system(size: 24))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
            }
    }
    //MARK: - nav
    var plantView: some View {
        ZStack {
            if timerCount <= totalTime*0.25 {
                images[0]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:40)
                    .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0), value: scale)
                    .transition(.scale)
                
            } else if timerCount <= totalTime*0.50 {
                images[1]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:50)
                    .transition(.scale)
                    .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0), value: scale)
            } else if timerCount <= totalTime*0.75 {
                images[2]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:60)
                    .transition(.scale)
                    .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0), value: scale)
            } else {
                images[3]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:150)
                    .offset(y:-50)
                    .transition(.scale)
                    .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0), value: scale)
            }
        }
    }
    var sound: some View {
        Image(systemName: "gearshape")
            .font(.system(size: 24))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
            }
    }
    var heart: some View {
        LikeButton(isLiked: false, size:25.0) {
        }
    }
    
    private func toggleControllPanel() {
        showPanel = true
        DispatchQueue.main.asyncAfter(deadline: .now() + panelHideDelay) {
            showPanel = false
        }
    }
}


struct AnimatedBackground: View {
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    @State var duration = 6.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [Clr.brightGreen, Clr.darkWhite]
    
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
