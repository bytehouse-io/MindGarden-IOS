//
//  RecommendationsView.swift
//  MindGarden
//
//  Created by Vishal Davara on 06/07/22.
//

import SwiftUI

struct RecommendationsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @State private var playAnim = false
    let width = UIScreen.screenWidth
    @State private var playEntryAnimation = false
    @Binding var recs: [Int]
    @Binding var coin: Int
    @State private var isOnboarding = false

    var body: some View {
        ZStack {
            Clr.darkWhite.ignoresSafeArea()
            ScrollView(.vertical,showsIndicators: false) {
                VStack {
                    Spacer()
                        .frame(height:20)
                    VStack(spacing:0) {
                        HStack {
                            Text("Hooray!")
                                .foregroundColor(Clr.brightGreen)
                                .font(Font.fredoka(.semiBold, size: 28))
                            Spacer()
                            CloseButton() {
                                withAnimation { viewRouter.currentPage = .meditate }
                            }
                        }.padding(5)
                            .padding(.bottom,10)
                            .zIndex(2)
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(colors: [Clr.brightGreen.opacity(0.8), Clr.yellow], startPoint: .leading, endPoint: .trailing))
                                .font(Font.fredoka(.medium, size: 20))
                                .overlay(LottieAnimationView(filename: "party", loopMode: .playOnce, isPlaying: $playAnim)
                                .scaleEffect(2))
                            VStack(alignment:.leading, spacing: 0) {
                                HStack {
                                    ( Text("You earned")  .foregroundColor(.white) + Text(" +\(20 + coin) ").foregroundColor(Clr.brightGreen) + Text("coins")  .foregroundColor(.white))
                                        .font(Font.fredoka(.semiBold, size: 20))
                                        .padding()
                                        .offset(x: 24)
                                    Spacer()
                                }
                                HStack(spacing:20) {
                                    Img.coinBunch
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(.leading,16)
                                        .frame(width: 100)
                                        .offset(x: 24, y: -8)
                                    Spacer()
                                    VStack(alignment: .leading, spacing:10) {
                                        HStack {
                                            Mood.getMoodImage(mood: userModel.selectedMood)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30)
                                            Text("+20")
                                                .foregroundColor(Clr.brightGreen)
                                                .font(Font.fredoka(.semiBold, size: 20)) +
                                            Text(" Mood Check")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.fredoka(.regular, size: 20))
                                        }
                                        HStack {
                                            Img.streakPencil
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30)
                                            Text("+\(coin)")
                                                .foregroundColor(Clr.brightGreen)
                                                .font(Font.fredoka(.semiBold, size: 20)) +
                                            Text(" Journaling")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.fredoka(.regular, size: 20))
                                        }
                                        Spacer()
                                    }
                                    .frame(width: width * 0.5)
                                    .padding(.trailing,30)
                                    .padding(.top)
                                }
                                Spacer()
                            }
                        }
                        .frame(width: width * 0.85, height:175)
                        .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                    }
                    
                    TodaysMeditation
                        .padding(.top,30)
                    Spacer()
                }
                .padding(.horizontal,32)
            }
        }.onAppear() {
            withAnimation(.spring()) {
                playAnim = true
                playEntryAnimation = true
            }
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" {
                if UserDefaults.standard.integer(forKey: "numMeds") > 0 {
                    isOnboarding = true
                }
            }
        }
    }
    
    var TodaysMeditation: some View {
        VStack(alignment:.leading) {
            HStack {
                Text("Today’s Meditations")
                    .foregroundColor(Clr.brightGreen)
                    .font(Font.fredoka(.semiBold, size: 20))
                Spacer()
            }
            HStack(spacing:16) {
                Mood.getMoodImage(mood: userModel.selectedMood)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:50)
                Text("Based on how your feeling, we chose these for you:")
                    .foregroundColor(Clr.black2)
                    .font(Font.fredoka(.regular, size: 20))
                    .multilineTextAlignment(.leading)
            }.frame(height:50)
            .padding(.bottom,20)
            ForEach(0..<3) { idx in
                MeditationRow(id: recs[idx], isBreathwork: idx == 0)
                    .padding(.vertical,5)
                    .offset(y: playEntryAnimation ? 0 : 100)
                    .opacity(playEntryAnimation ? 1 : 0)
                    .animation(.spring().delay(Double((idx+1))*0.3), value: playEntryAnimation)
            }
            HStack {
                Spacer()
                Text("OR")
                    .foregroundColor(Clr.black2)
                    .font(Font.fredoka(.medium, size: 16))
                Spacer()
            }
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    viewRouter.currentPage = .learn
                }
            } label: {
                ZStack {
                    Capsule()
                        .fill(Clr.yellow)
                        .frame(height: 44)
                        .addBorder(Color.black, width: 1.5, cornerRadius: 22)
                    HStack {
                        Text("See More")
                            .foregroundColor(Clr.darkWhite)
                            .font(Font.fredoka(.bold, size: 16))
                        Image(systemName: "arrow.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:16)
                    }
                }
            }.buttonStyle(NeoPress())
  
        }
    }
}


struct MeditationRow: View {
    var id:Int
    var isBreathwork: Bool
    @State var meditation: Meditation = Meditation.allMeditations[0]
    @State var breathwork: Breathwork = Breathwork.breathworks[0]
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Clr.darkWhite)
                .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                .neoShadow()
            HStack(spacing:0) {
                VStack(alignment:.leading,spacing:3) {
                    Text(isBreathwork ? breathwork.title : meditation.title)
                        .font(Font.fredoka(.semiBold, size: 20))
                        .frame(width: UIScreen.screenWidth * 0.5, height: !isBreathwork
                               && meditation.title.count > 20 ? 55 : 25, alignment: .leading)
                        .foregroundColor(Clr.black2)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                        .lineLimit(2)
                        .offset(y:!isBreathwork && meditation.title.count > 19 ? 5 : 0)
                    HStack {
                        Image(systemName: isBreathwork ? "wind" : "speaker.wave.3.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:12)
                            .padding(.vertical,0)
                        Text(isBreathwork ? "Breathwork" : " Meditation")
                            .font(Font.fredoka(.medium, size: 16))
                            .foregroundColor(Clr.black2.opacity(0.5))
                            .padding(.vertical,0)
                    }.padding(.vertical,0)
                        .frame(width: UIScreen.screenWidth/2.5, alignment: .leading)

                        HStack {
                            Image(systemName: isBreathwork ? breathwork.color.image : "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:13)
                                .padding(.vertical,0)
                            Text(isBreathwork ? breathwork.color.name.capitalized : Int(meditation.duration) == 0 ? "Course" : (Int(meditation.duration/60) == 0 ? "1/2" : "\(Int(meditation.duration/60))") + " mins")
                                .font(Font.fredoka(.medium, size: 16))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                            Text("•")
                                .font(Font.fredoka(.bold, size: 16))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:12)
                                .padding(.vertical,0)
                            Text(isBreathwork ? "Visual" : "\(meditation.instructor)")
                                .font(Font.fredoka(.medium, size: 16))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                        .frame(width: UIScreen.screenWidth/2.25, alignment: .leading)
                }
                Spacer()
                Group {
                    if isBreathwork {
                        breathwork.img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        if meditation.imgURL != "" {
                            UrlImageView(urlString: meditation.imgURL)
                                .aspectRatio(contentMode: .fit)
                        } else {
                            meditation.img
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
    
                    }
                }.frame(width: 80, height: 80)
                    .offset(y: 2)
            }
            .frame(height: 100, alignment: .center)
            .offset(y: -7)
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
        }.onAppear {
            if isBreathwork {
                if let breath = Breathwork.breathworks.first(where: { $0.id == id }) {
                    breathwork = breath
                }
            } else {
                if let med = Meditation.allMeditations.first(where: { $0.id == id }) {
                    meditation = med
                }
            }
        }
    }
}


struct RecommendationsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsView(recs: .constant([-1,1,2]), coin: .constant(3))
    }
}
