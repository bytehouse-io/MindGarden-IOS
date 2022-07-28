//
//  MeditationPlayAnimation.swift
//  MindGarden
//
//  Created by Vishal Davara on 25/06/22.
//

import SwiftUI
import AVKit
import MediaPlayer
import AudioToolbox

struct BreathworkPlay : View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var userModel: MeditationViewModel
    @State private var bgAnimation = false
    @State private var fadeAnimation = false
    @State private var title = ""

    @State private var durationCounter = 1
    @State private var sequenceCounter = 0
    @State private var noOfSequence = 0
    @State private var size = 300.0
    @State private var showPanel = true
    @State private var timerCount:TimeInterval = 0.0
    @Binding var totalTime: Int
    @State private var progress = 0.0

    
    // Background Settings
    @State var backgroundPlayer : AVAudioPlayer!
    @State var del = AVdelegate()
    @State var showNatureModal = false
    @State var selectedSound: Sound? = .noSound
    @State var sliderData = SliderData()
    @State var bellSlider = SliderData()
    @State var data : Data = .init(count: 0)

    let panelHideDelay = 2.0
    
    @State var isPaused = false
    @Binding var showPlay:Bool
    
    let breathWork: Breathwork
    
    @State var timer: Timer?
    @State var durationTimer: Timer?
    var body: some View {
        ZStack(alignment:.top) {
            AnimatedBackground(colors:[breathWork.color.primary, Clr.skyBlue.opacity(0.5), Clr.darkWhite]).edgesIgnoringSafeArea(.all).blur(radius: 50)
            VStack {
                Spacer()
                    .frame(height: K.hasNotch() ? 50 : 25)
                HStack {
                    Button {
                        withAnimation(.linear) {
                            viewRouter.currentPage = .meditate
                        }
                    } label: {
                        Image(systemName: "arrow.left.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Clr.darkWhite)
                            .aspectRatio(contentMode: .fit)
                            .frame(height:40)
                            .background(Circle().foregroundColor(Clr.black2).padding(1))
                            .darkShadow()
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
                        .foregroundColor(breathWork.color.primary)
                        .addBorder(.black, width: 2, cornerRadius: size/2)
                        .frame(width:size, height: size)
                    Circle()
                        .fill(breathWork.color.secondary.opacity(0.4))
                        .frame(width:size/2)
                        .clipShape(Circle())
                        .scaleEffect(bgAnimation ? 2 : 1)
                    ZStack {
                        Circle()
                            .foregroundColor(breathWork.color.secondary)
                            .addBorder(.black, width: 2, cornerRadius: size/2)
                            .frame(width:size/2, height: size/2)
                        VStack {
                            Spacer()
                            Text(title)
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.1)
                            Text("  \(durationCounter)  ")
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
                            ).background(
                                ZStack {
                                    if progress >= 0.75 {
                                        userModel.selectedPlant?.coverImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height:150)
                                            .offset(y:-80)
                                            .animation(Animation
                                                        .spring(response: 0.3, dampingFraction: 3.0))
                                            .transition(.opacity)
                                    } else {
                                        EmptyView()
                                    }
                                }
                            )
                            .frame(maxWidth:.infinity)
                        ZStack {
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Clr.darkGray)
                                    .frame(width:geometry.size.width, height:15)
                                    .cornerRadius(25,corners: [.bottomLeft, .bottomRight])
                                Rectangle()
                                    .fill(breathWork.color.secondary)
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
                                if !isPaused {
                                isPaused = true
                                } else {
                                    isPaused = false
                                    playAnimation()
                                }
                            }
                        } label : {
                            ZStack {
                                Capsule()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text(isPaused ? "Play" : "Pause")
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
                                withAnimation {
                                    viewRouter.currentPage  = .finished
                                }
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
            }.padding(.top, 50)
            if showNatureModal  {
                Color.black
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
            }
            NatureModal(show: $showNatureModal, sound: $selectedSound, change: self.changeSound, player: backgroundPlayer, sliderData: $sliderData, bellSlider: $bellSlider)
                .offset(y: showNatureModal ? 0 : UIScreen.screenHeight)
                .animation(.default)
        }
        .onAppear {
            if let plantTitle = UserDefaults.standard.string(forKey: K.defaults.selectedPlant) {
                userModel.selectedPlant = Plant.allPlants.first(where: { plant in
                    return plant.title == plantTitle
                })
            }
            
            let singleTime = breathWork.sequence.map { $0.0 }.reduce(0, +)
            noOfSequence = Int(Double(totalTime)/Double(singleTime))
            DispatchQueue.main.async {
                playAnimation()
                toggleControllPanel()
            }
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if !isPaused {
                    if timerCount < Double(totalTime) {
                        timerCount += 1
                        withAnimation(.linear(duration: 1.0)) {
                            progress = timerCount/Double(totalTime)
                            print(progress, timerCount, totalTime, "bick back")
                        }
                    } else {
                        timer.invalidate()
                    }
                }
            }

        }
        .onDisappear() {
            timer?.invalidate()
            durationTimer?.invalidate()
        }
        .onTapGesture {
            toggleControllPanel()
        }
        
    }
    
    private func playAnimation() {
        let time =  breathWork.sequence[sequenceCounter].0
        let status = breathWork.sequence[sequenceCounter].1
        
        if noOfSequence > 0 && !isPaused {
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
            durationTimer = nil
            if time > 0 {
                fadeAnimation = true
                withAnimation(.linear(duration: 0.5)) {
                    fadeAnimation = false
                    durationCounter = time
                }
                durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    fadeAnimation = true
                    withAnimation(.linear(duration: 0.5)) {
                        fadeAnimation = false
                        durationCounter -= 1
                    }
                    if durationCounter<=1 {
                        timer.invalidate()
                    }
                }
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
    //MARK: - nav
    var plantView: some View {
        ZStack {
            if progress < 0.25 {
                Img.seed
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:40)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0))
                    .transition(.opacity)
                
            } else if progress < 0.50 {
                userModel.selectedPlant?.one
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:50)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0))
                    .transition(.opacity)
            } else if progress < 0.75 {
                userModel.selectedPlant?.two
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:60)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0))
                    .transition(.opacity)
            } else {
                EmptyView()
            }
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
