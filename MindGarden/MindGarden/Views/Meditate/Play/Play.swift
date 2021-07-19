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
    var unGuided: Bool = true
    @State var timerStarted: Bool = false
    @State var favorited: Bool = false
    @State var player : AVAudioPlayer!
    @State var data : Data = .init(count: 0)
    @State var title = ""
    @State var del = AVdelegate()
    @State var finish = false
    @State var showNatureModal = true
    @State var selectedSound: Sound? = .noSound
    @ObservedObject var model: PlayViewModel
    @ObservedObject var viewRouter: ViewRouter

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { g in
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
                                        .animation(.linear)
                                    Circle()
                                        .frame(width: 230)
                                        .foregroundColor(Clr.darkWhite)
                                        .shadow(color: .black.opacity(0.35), radius: 20, x: 10, y: 5)
                                }
                                .frame(width: 250)
                            }
                            Text(model.secondsToMinutesSeconds(totalSeconds: model.isOpenEnded ? model.secondsCounted : model.secondsRemaining))
                                .foregroundColor(Clr.black1)
                                .font(Font.mada(.bold, size: 60))
                                .padding(.horizontal)
                            HStack(alignment: .center, spacing: 20) {
                                Button {
                                    player.currentTime -= 15
                                    model.secondsRemaining -= 15
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
                                    if player.isPlaying {
                                        player.pause()
                                    } else {
                                        player.play()
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
                                    player.currentTime += 15
                                    model.secondsRemaining += 15
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
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: backArrow,
                                trailing: HStack{sound; heart}
            )
        }.transition(.move(edge: .trailing))
        .animation(.easeIn)
        .onAppear {
            if unGuided {
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
                        getData()
                        //            player.play()
                        NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main) { (_) in
                            self.finish = true
                        }
                    }
                }
            }
        }
    }

    //MARK: - nav
    var backArrow: some View {
        Image(systemName: "arrow.backward")
            .font(.title)
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
                withAnimation {
                    viewRouter.currentPage = .meditate
                }
            }
    }
    var sound: some View {
        Image(systemName: "music.note.list")
            .font(.title)
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
                withAnimation {
                    showNatureModal = true
                }
            }
    }
    var heart: some View {
        Image(systemName: favorited ? "heart.fill" : "heart")
            .font(.title)
            .foregroundColor(favorited ? Color.red : Clr.lightGray)
            .onTapGesture {
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

    //MARK: - Sonud
    enum Sound {
        case rain
        case night
        case nature
        case fire
        case beach
        case noSound

        var img: Image {
            switch self {
            case .rain:
                return Image(systemName: "cloud.rain")
            case .night:
                return Image(systemName: "moon.stars")
            case .nature:
                return Image(systemName: "leaf")
            case .beach:
                return Image("beach")
            case .fire:
                return Image(systemName: "flame")
            case .noSound:
                return Image("beach")
            }
        }

        var title: String {
            switch self {
            case .rain:
                return "rain"
            case .night:
                return "night"
            case .nature:
                return "nature"
            case .beach:
                return "beach"
            case .fire:
                return "fire"
            case .noSound:
                return "noSound"
            }
        }

        static func getSound(str: String) -> Sound {
            switch str {
            case "rain":
                return .rain
            case "night":
                return .night
            case "nature":
                return .nature
            case "beach":
                return .beach
            case "fire":
                return .fire
            case "noSound":
                return .noSound
            default:
                return .noSound
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
                withAnimation {
                    if selectedType == type {
                        selectedType = .noSound
                        player?.pause()

                    } else {
                        selectedType = type
                        change()
                    }
                    UserDefaults.standard.set(selectedType?.title, forKey: "sound")
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
        getData()
    }

     func getData() {
        let asset = AVAsset(url: self.player.url!)
        for i in asset.commonMetadata{
            if i.commonKey?.rawValue == "title"{
                let title = i.value as! String
                self.title = title
            }
        }
    }
}

class AVdelegate : NSObject,AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}


struct Play_Previews: PreviewProvider {
    static var previews: some View {
        Play(model: PlayViewModel(), viewRouter: ViewRouter())
    }
}
