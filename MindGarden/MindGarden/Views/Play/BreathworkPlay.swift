//
//  MeditationPlayAnimation.swift
//  MindGarden
//
//  Created by Vishal Davara on 25/06/22.
//

import SwiftUI
import AVKit
import MediaPlayer

struct BreathworkPlay : View {
    
    @State private var bgAnimation = false
    @State private var fadeAnimation = false
    @State private var isBally = false
    @State private var title = "Belly"
    
    @State var meditateTimer: Timer?
    
    @State var time = 3.0
    @State var size = 300.0
    @State private var showPanel = true
    @State private var timerCount:TimeInterval = 1.0
    @State private var scale = 0.0
    
    // Background Settings
    @State var backgroundPlayer : AVAudioPlayer!
    @State var del = AVdelegate()
    @State var showNatureModal = false
    @State var selectedSound: Sound? = .noSound
    @State var sliderData = SliderData()
    @State var bellSlider = SliderData()
    @State var data : Data = .init(count: 0)

    let panelHideDelay = 2.0
    let progress = 0.5
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack(alignment:.top) {
//            Clr.darkWhite.ignoresSafeArea()
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
                            .frame(height:40)
                            .background(Circle().foregroundColor(Clr.black2).padding(1))
                            .neoShadow()
                    }
                    Spacer()
                    HStack{
                        sound
                        heart
                    }
                }
                .frame(width: UIScreen.screenWidth * 0.85)
                .padding()
                .opacity(showPanel ? 1 : 0)
                .disabled(!showPanel)
                ZStack {
                    Circle()
                        .foregroundColor(Clr.brightGreen)
                        .addBorder(.black, width: 2, cornerRadius: size/2)
                        .frame(width:size, height: size)
                    Circle()
                        .stroke(lineWidth:isBally ? 5 : size/2)
                        .fill(Clr.yellow)
                        .frame(width:size/2)
                        .clipShape(Circle())
                        .scaleEffect(bgAnimation ? 2 : 1)
                        .opacity(fadeAnimation ? 0 : 1)
                    ZStack {
                        Circle()
                            .foregroundColor(Clr.darkgreen)
                            .addBorder(.black, width: 2, cornerRadius: size/2)
                            .frame(width:size/2, height: size/2)
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
                            .background(
                                Img.grassSunflower
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height:150)
                                    .offset(y:-80)
                                    .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
                                    .animation(Animation
                                                .spring(response: 0.3, dampingFraction: 3.0), value: scale)
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
                        }.frame(height:15)
                    }
                    .padding(.top,150)
                    VStack {
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                // TODO when paused
                            }
                        } label : {
                            ZStack {
                                Capsule()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Pause")
                                            .font(Font.fredoka(.medium, size: 20))
                                            .foregroundColor(Clr.black2)
                                    ).addBorder(.black, width: 1, cornerRadius: 30)
                               
                            }
                        }
                        .frame(height:50)
                        .buttonStyle(ScalePress())
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                // TODO when paused
                            }
                        } label: {
                            Text("I'm Done")
                                .font(Font.fredoka(.medium, size: 20))
                                .foregroundColor(Clr.black2)
                                .underline()
                        }.padding(.top)
                    }
                    .padding(.vertical)
                    .disabled(!showPanel)
                    .opacity(showPanel ? 1.0 : 0.0)
                }.padding(.horizontal,30)
            }
            if showNatureModal  {
                Color.black
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
            }
            NatureModal(show: $showNatureModal, sound: $selectedSound, change: self.changeSound, player: backgroundPlayer, sliderData: $sliderData, bellSlider: $bellSlider)
                .offset(y: showNatureModal ? 0 : UIScreen.screenHeight)
                .animation(.default)
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
            
            DispatchQueue.main.async {
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 3.0)) {
                    scale = 1.0
                }
            }
        }
        .onDisappear() {
            meditateTimer?.invalidate()
        }
        .onTapGesture {
            toggleControllPanel()
        }
        .onReceive(timer) { input in
            timerCount += 1
        }
    }
    
    func changeSound() {
        backgroundPlayer.stop()
       let url = Bundle.main.path(forResource: selectedSound?.title, ofType: "mp3")
        backgroundPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
        backgroundPlayer.delegate = self.del
        backgroundPlayer.numberOfLoops = -1
        backgroundPlayer.volume = sliderData.sliderValue
       self.data = .init(count: 0)
        backgroundPlayer.prepareToPlay()
       self.backgroundPlayer.play()
       self.sliderData.setPlayer(player: backgroundPlayer!)
   }
    
    //MARK: - nav
    var backArrow: some View {
        Image(systemName: "arrow.backward")
            .font(.system(size: 32))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
            }
    }
    var sound: some View {
        Image(systemName: "gearshape.fill")
            .font(.system(size: 32))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
                withAnimation {
                    showNatureModal = true
                }
            }
    }
    var heart: some View {
        LikeButton(isLiked: false, size:32) {
        }
    }
    
    private func toggleControllPanel() {
        withAnimation {
            showPanel = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + panelHideDelay) {
            withAnimation {
                showPanel = false
            }
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
