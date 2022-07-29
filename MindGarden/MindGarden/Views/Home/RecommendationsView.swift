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
    private let titles = ["Intro to Meditation", "Intro to Meditation","Basic Confidence Meditation"]
    @State private var playAnim = false
    let width = UIScreen.screenWidth
    @State private var playEntryAnimation = false

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
                            Rectangle().fill(Clr.darkWhite)
                                .font(Font.fredoka(.medium, size: 20))
                                .overlay(LottieAnimationView(filename: "party", loopMode: .playOnce, isPlaying: $playAnim)
                                .scaleEffect(2))
                            VStack(alignment:.leading, spacing: 0) {
                                HStack {
                                   ( Text("You earned")  .foregroundColor(Clr.black2) + Text(" +6 ").foregroundColor(Clr.brightGreen) + Text("coins")  .foregroundColor(Clr.black2))
                                        .font(Font.fredoka(.semiBold, size: 20))
                                        .padding()
                                        .offset(x: 16)
                                    Spacer()
                                }
                                HStack(spacing:20) {
                                    Img.coinBunch
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(.leading,16)
                                        .frame(width: 100)
                                        .offset(x: 16, y: -8)
                                    Spacer()
                                    VStack(alignment: .leading, spacing:10) {
                                        HStack {
                                            Mood.getMoodImage(mood: userModel.selectedMood)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30)
                                            Text("+2")
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
                                            Text("+4")
                                                .foregroundColor(Clr.brightGreen)
                                                .font(Font.fredoka(.semiBold, size: 20)) +
                                            Text(" Journaling")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.fredoka(.regular, size: 20))
                                        }
                                        Spacer()
                                    }
                                    .frame(width: width * 0.45)
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
            ForEach(0..<titles.count) { idx in
                MeditationRow(title: titles[idx])
                    .padding(.vertical,5)
                    .offset(y: playEntryAnimation ? 0 : 100)
                    .opacity(playEntryAnimation ? 1 : 0)
                    .animation(.spring().delay(Double((idx+1))*0.3), value: playEntryAnimation)
            }
            HStack {
                Spacer()
                Text("OR")
                    .foregroundColor(Clr.black2)
                    .font(Font.fredoka(.medium, size: 10))
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
                            .foregroundColor(Clr.black2)
                            .font(Font.fredoka(.medium, size: 16))
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
    
    @State var title:String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Clr.darkWhite)
                .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                .neoShadow()
            HStack(spacing:0) {
                VStack(alignment:.leading,spacing:3) {
                    Text(title)
                        .font(Font.fredoka(.medium, size: 20))
                        .frame(width: UIScreen.screenWidth * 0.5, alignment: .leading)
                        .foregroundColor(Clr.black2)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                    HStack {
                        Image(systemName: "speaker.wave.3.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:10)
                            .padding(.vertical,0)
                        Text("7 day course")
                            .font(Font.fredoka(.medium, size: 12))
                            .foregroundColor(Clr.black2.opacity(0.5))
                            .padding(.vertical,0)
                    }.padding(.vertical,0)
                    let _ = print(title.count)
                    if title.count < 22 {
                        HStack {
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:10)
                                .padding(.vertical,0)
                            Text("1/2 mins")
                                .font(Font.fredoka(.medium, size: 12))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:10)
                                .padding(.vertical,0)
                            Text("Bijan")
                                .font(Font.fredoka(.medium, size: 12))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                    } else {
                        HStack {
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:10)
                                .padding(.vertical,0)
                            Text("1/2 mins")
                                .font(Font.fredoka(.medium, size: 12))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                            Text("•")
                                .font(Font.fredoka(.bold, size: 12))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:10)
                                .padding(.vertical,0)
                            Text("Bijan")
                                .font(Font.fredoka(.medium, size: 12))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                    }
                }
                Spacer()
                Img.happySunflower
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                    .offset(y: 2)
            }
            .frame(height: 100, alignment: .center)
            .offset(y: -7)
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
        }
    }
}


struct RecommendationsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsView()
    }
}
