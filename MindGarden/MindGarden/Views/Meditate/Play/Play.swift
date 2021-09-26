//
//  Play.swift
//  MindGarden
//
//  Created by Dante Kim on 6/18/21.
//

import SwiftUI
import AVKit

struct Play: View {
    var progressValue: Float {
        if model.isOpenEnded {
            return 1
        } else {
            return 1 - (model.secondsRemaining/model.totalTime)
        }
    }
    @State var timerStarted: Bool = true
    @State var favorited: Bool = false
    @State var player : AVAudioPlayer!
    @State var mainPlayer: AVAudioPlayer!
    @State var data : Data = .init(count: 0)
    @State var title = ""
    @State var del = AVdelegate()
    @State var finish = false
    @State var showNatureModal = false
    @State var selectedSound: Sound? = .noSound
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { g in
                    let width = g.size.width
                    let height = g.size.height
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center) {
                            HStack(alignment: .center) {
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 20.0)
                                        .foregroundColor(Clr.superLightGray)
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(min(self.progressValue, 1.0)))
                                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                        .foregroundColor(Clr.brightGreen)
                                        .rotationEffect(Angle(degrees: 270.0))
                                        .animation(.linear(duration: 2), value: model.secondsRemaining)
                                    Circle()
                                        .frame(width: 230)
                                        .foregroundColor(Clr.darkWhite)
                                        .shadow(color: .black.opacity(0.35), radius: 20, x: 10, y: 5)
                                    //four different plant stages
                                    if model.secondsRemaining <= model.totalTime * 0.25 { //secoond
                                        withAnimation {
                                            model.playImage
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: model.lastSeconds ? width/2 : width/4, height: model.lastSeconds ? height/4 : height/6)
                                                .animation(.easeIn(duration: 2.0))
                                        }
                                    } else if model.secondsRemaining <= model.totalTime * 0.5 {
                                        model.playImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .animation(.easeIn(duration: 2.0))
                                            .frame(width: width/4, height: height/6)
                                            .offset(y: 25)
                                        
                                    } else if model.secondsRemaining <= model.totalTime * 0.75 {
                                        model.playImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .animation(.easeIn(duration: 2.0))
                                            .frame(width: width/6, height: height/8)
                                            .offset(y: 50)
                                    } else {
                                        model.playImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .animation(.easeIn(duration: 1.0))
                                            .frame(width: width/10, height: height/12)
                                            .offset(y: 75)
                                    }
                                }
                                .frame(width: 250)
                            }
                            Text(model.secondsToMinutesSeconds(totalSeconds: model.isOpenEnded ? model.secondsCounted : model.secondsRemaining))
                                .foregroundColor(Clr.black1)
                                .font(Font.mada(.bold, size: 60))
                                .padding(.horizontal)
                            HStack(alignment: .center, spacing: 20) {
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    if model.secondsRemaining + 15 <= model.selectedMeditation?.duration ?? 0.0 {
                                        if model.selectedMeditation?.belongsTo != "Timed Meditation" {
                                            mainPlayer.currentTime += 15
                                        }
                                        model.secondsRemaining += 15
                                    } else {
                                        if model.selectedMeditation?.belongsTo != "Timed Meditation" {
                                            mainPlayer.currentTime = Double(model.selectedMeditation?.duration ?? 0.0)
                                        }
                                        model.secondsRemaining = model.selectedMeditation?.duration ?? 0.0
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(Clr.darkWhite)
                                            .frame(width: 70)
                                            .neoShadow()
                                        VStack {
                                            Image(systemName: "backward.fill")
                                                .foregroundColor(Clr.brightGreen)
                                                .font(.title)
                                            Text("15")
                                                .font(.caption)
                                                .foregroundColor(Clr.darkgreen)
                                        }
                                    }
                                }
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    if model.selectedMeditation?.belongsTo != "Timed Meditation" {
                                        if mainPlayer.isPlaying {
                                            mainPlayer.pause()
                                        } else {
                                            mainPlayer.play()
                                        }
                                    }

                                    if timerStarted {
                                        model.stop()
                                    } else {
                                        model.isOpenEnded ? model.startTimer() : model.startCountdown()
                                    }

                                    timerStarted.toggle()
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(Clr.darkWhite)
                                            .frame(width: 90)
                                            .neoShadow()
                                        Image(systemName: timerStarted ? "pause.fill" : "play.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Clr.brightGreen)
                                            .frame(width: 35)
                                            .padding(.leading, 5)
                                    }
                                }
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    if model.secondsRemaining >= 15 {
                                        if model.selectedMeditation?.belongsTo != "Timed Meditation" {
                                            mainPlayer.currentTime -= 15
                                        }
                                        model.secondsRemaining -= 15
                                    } else {
                                        if model.selectedMeditation?.belongsTo != "Timed Meditation" {
                                            mainPlayer.currentTime = 0
                                        }
                                        model.secondsRemaining = 0
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(Clr.darkWhite)
                                            .frame(width: 70)
                                            .neoShadow()
                                        VStack {
                                            Image(systemName: "forward.fill")
                                                .foregroundColor(Clr.brightGreen)
                                                .font(.title)
                                            Text("15")
                                                .font(.caption)
                                                .foregroundColor(Clr.darkgreen)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }.opacity(showNatureModal ? 0.3 : 1)
                    if showNatureModal {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                    }
                    NatureModal(show: $showNatureModal, sound: $selectedSound, change: self.changeSound, player: player).offset(y: showNatureModal ? 0 : g.size.height)
                        .animation(.default)
                }
            }.animation(nil)
            .navigationBarTitle(Text(model.selectedMeditation?.title ?? ""), displayMode: .inline)
            .navigationBarItems(leading: UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" ? backArrow.opacity(0) : backArrow.opacity(1),
                                trailing: HStack{sound; heart}
            )
        }.transition(.move(edge: .trailing))
        .animation(.easeIn)
        .onAppear {
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                model.selectedMeditation = Meditation.allMeditations[2]
            } else {

            }
            if let defaultSound = UserDefaults.standard.string(forKey: "sound") {
                if defaultSound != "noSound"  {
                    selectedSound = Sound.getSound(str: defaultSound)
                    let url = Bundle.main.path(forResource: selectedSound?.title, ofType: "mp3")
                    player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
                    player.delegate = self.del
                    player.prepareToPlay()

                    if selectedSound == .beach {
                        player.volume = 0.3
                    } else {
                        player.volume = 3
                    }
                    player.numberOfLoops = -1
                    player.play()
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main) { (_) in
                        self.finish = true
                    }
                }
            }

            //bell at the end of a session
            let url = Bundle.main.path(forResource: "bell", ofType: "mp3")
            model.bellPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            model.bellPlayer.delegate = self.del

            if model.selectedMeditation?.belongsTo != "Timed Meditation" {
                let url = Bundle.main.path(forResource: "fire", ofType: "mp3")
                mainPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
                mainPlayer.delegate = self.del
                mainPlayer.prepareToPlay()
                mainPlayer.play()
                model.startCountdown()
                NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main) { (_) in
                    self.finish = true
                }
            } else {
                model.startCountdown()
            }


        }
        .onDisappear {
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                UserDefaults.standard.setValue("meditate", forKey: K.defaults.onboarding)
            }
        }
        .onAppear {
            model.checkIfFavorited()
            favorited = model.isFavorited
            model.setup(viewRouter)
        }
    }

    //MARK: - nav
    var backArrow: some View {
        Image(systemName: "arrow.backward")
            .font(.system(size: 22))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
                withAnimation {
                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude" {
                        viewRouter.currentPage = .meditate
                    }
                }
            }
    }
    var sound: some View {
        Image(systemName: "music.note.list")
            .font(.system(size: 22))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    showNatureModal = true
                }
            }
    }
    var heart: some View {
        Image(systemName: favorited ? "heart.fill" : "heart")
            .font(.system(size: 22))
            .foregroundColor(favorited ? Color.red : Clr.lightGray)
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if let med = model.selectedMeditation {
                    model.favorite(selectMeditation: med)
                }
                favorited.toggle()
            }
    }


    //MARK: - modal
    struct NatureModal: View {
        @Binding var show: Bool
        @Binding var sound: Sound?
        var change: () -> Void
        var player: AVAudioPlayer?

        var  body: some View {
            GeometryReader { g in
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Text("Background Noise")
                                .foregroundColor(Clr.black1)
                                .font(Font.mada(.bold, size: 24))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                            HStack {
                                SoundButton(type: .nature, selectedType: $sound, change: self.change, player: player)
                                SoundButton(type: .rain, selectedType: $sound, change: self.change, player: player)
                                SoundButton(type: .night, selectedType: $sound, change: self.change, player: player)
                                SoundButton(type: .beach, selectedType: $sound, change: self.change, player: player)
                                SoundButton(type: .fire, selectedType: $sound, change: self.change, player: player)
                            }
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    show = false
                                }
                            } label: {
                                Text("Done")
                                    .font(Font.mada(.bold, size: 18))
                                    .foregroundColor(Clr.black2)
                                    .frame(width: g.size.width/3, height: 35)
                                    .background(Clr.yellow)
                                    .clipShape(Capsule())
                                    .padding(.top, 25)
                            }
                            .neoShadow()
                            .animation(.default)
                        }.frame(width: g.size.width * 0.85, height: g.size.height * 0.30, alignment: .center)
                        .background(Clr.darkWhite)
                        .cornerRadius(20)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }

    struct SoundButton: View {
        var type: Sound?
        @Binding var selectedType: Sound?
        var change: () -> Void
        var player: AVAudioPlayer?

        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    if selectedType == type {
                        selectedType = .noSound
                        player?.pause()

                    } else {
                        selectedType = type
                        change()
                    }
                    UserDefaults.standard.setValue(selectedType?.title, forKey: "sound")
                }
            } label: {
                ZStack {
                    Rectangle()
                        .fill(selectedType == type ? Clr.darkgreen : Color.gray.opacity(0.5))
                        .aspectRatio(1.0, contentMode: .fit)
                        .cornerRadius(12)
                    type?.img
                        .resizable()
                        .renderingMode(.template)
                        .padding(10)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: type != selectedType ? 40 : 0, height: 3)
                        .opacity(0.9)
                        .rotationEffect(.degrees(-45))
                }.frame(width: 50, height: 50)
            }.buttonStyle(NeumorphicPress())
        }
    }


     func changeSound() {
        let url = Bundle.main.path(forResource: selectedSound?.title, ofType: "mp3")
        player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
        player.delegate = self.del
        if selectedSound == .beach {
            player.volume = 0.3
        } else {
            player.volume = 3
        }
        player.numberOfLoops = -1
        self.data = .init(count: 0)
        player.prepareToPlay()
        self.player.play()
    }
}

class AVdelegate : NSObject,AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}


struct Play_Previews: PreviewProvider {
    static var previews: some View {
        Play()
            .environmentObject(MeditationViewModel())
    }
}
