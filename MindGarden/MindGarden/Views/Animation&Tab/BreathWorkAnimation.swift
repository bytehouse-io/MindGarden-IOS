//
//  MeditationPlayAnimation.swift
//  MindGarden
//
//  Created by Vishal Davara on 25/06/22.
//

import SwiftUI
import AudioToolbox

struct BreathworkPlay : View {
    
    @State private var bgAnimation = false
    @State private var fadeAnimation = false
    @State private var title = ""
        
    @State var sequenceCounter = 0
    @State var noOfSequence = 0
    @State var size = 300.0
    @State private var showPanel = true
    @State private var timerCount:TimeInterval = 0.0
    @State private var totalTime = 0.0
    @State private var progress = 0.0
    
    let panelHideDelay = 2.0
    
    let images = [Img.seed,Img.sunflower1,Img.sunflower2,Img.sunflower3]
    let breathWork: Breathwork
    
    @State var timer: Timer?
    var body: some View {
        ZStack(alignment:.top) {
            AnimatedBackground(colors:[breathWork.color.primary, breathWork.color.primary, Clr.darkWhite]).edgesIgnoringSafeArea(.all).blur(radius: 50)
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
                            .darkShadow()
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
                        .fill(Clr.yellow)
                        .frame(width:size/2)
                        .clipShape(Circle())
                        .scaleEffect(bgAnimation ? 2 : 1)
                        
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
                            Text("  \(noOfSequence > 0 ? noOfSequence : 1 )  ")
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(.white)
                                .opacity(fadeAnimation ? 0 : 1)
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
            totalTime = Double(breathWork.duration)
            let singleTime = breathWork.sequence.map { $0.0 }.reduce(0, +)
            noOfSequence = Int(totalTime/Double(singleTime))
            DispatchQueue.main.async {
                playAnimation()
                toggleControllPanel()
            }
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if timerCount < totalTime {
                    timerCount += 1
                    withAnimation(.linear(duration: 1.0)) {
                        progress = timerCount/totalTime
                    }
                } else {
                    timer.invalidate()
                }
            }
        }
        .onDisappear() {
            timer?.invalidate()
        }
        .onTapGesture {
            toggleControllPanel()
        }
    }
    
    private func playAnimation(){
        let time =  breathWork.sequence[sequenceCounter].0
        let status = breathWork.sequence[sequenceCounter].1
        
        if noOfSequence > 0 {
            switch status.lowercased() {
            case "i":
                title = "Inhale"
                withAnimation(.linear(duration: Double(time))) {
                    bgAnimation = true
                }
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            case "h":
                title = time > 0 ? "Hold" : ""
            case "e":
                title = "Exhale"
                withAnimation(.linear(duration: Double(time))) {
                    bgAnimation = false
                }
            default: break
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
                playAnimation()
            }
            if sequenceCounter < breathWork.sequence.count-1 {
                sequenceCounter += 1
            } else {
                sequenceCounter = 0
                fadeAnimation = true
                withAnimation(.linear(duration: 1.0)) {
                    noOfSequence -= 1
                    fadeAnimation = false
                }
            }
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
            if progress < 0.25 {
                images[0]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:40)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0))
                    .transition(.opacity)
                
            } else if progress < 0.50 {
                images[1]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:50)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0))
                    .transition(.opacity)
            } else if progress < 0.75 {
                images[2]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:60)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0))
                    .transition(.opacity)
            } else {
                images[3]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:150)
                    .offset(y:-50)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0))
                    .transition(.opacity)
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
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
    @State var colors:[Color]
    
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
