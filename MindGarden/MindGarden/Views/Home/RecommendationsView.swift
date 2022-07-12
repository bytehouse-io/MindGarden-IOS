//
//  RecommendationsView.swift
//  MindGarden
//
//  Created by Vishal Davara on 06/07/22.
//

import SwiftUI

struct RecommendationsView: View {
    @EnvironmentObject var model: MeditationViewModel
    private let titles = ["Intro to Meditation", "Intro to Meditation","Basic Confidence Meditation"]
    @State private var playAnim = false
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
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
                                viewControllerHolder?.dismissController()
                            }.offset(x:20)
                        }.padding(5)
                            .padding(.bottom,10)
                            .zIndex(2)
                        ZStack {
                            Rectangle().fill(Clr.darkWhite)
                                .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                                .overlay(LottieAnimationView(filename: "party", loopMode: .playOnce, isPlaying: $playAnim)
                                            .scaleEffect(2))
                            
                            VStack(alignment:.leading, spacing: 0) {
                                HStack {
                                    Text("You earned +6 coins")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.medium, size: 20))
                                        .padding()
                                    Spacer()
                                }
                                HStack(spacing:20) {
                                    Img.coinBunch
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(5)
                                        .padding(.leading,10)
                                    Spacer()
                                    VStack(alignment: .leading, spacing:10) {
                                        Spacer()
                                        HStack {
                                            Text("+2")
                                                .foregroundColor(Clr.brightGreen)
                                                .font(Font.fredoka(.semiBold, size: 20)) +
                                            Text(" Mood Check")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.fredoka(.regular, size: 20))
                                            Img.moodCheck
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        HStack {
                                            Text("+4")
                                                .foregroundColor(Clr.brightGreen)
                                                .font(Font.fredoka(.semiBold, size: 20)) +
                                            Text(" Journaling")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.fredoka(.regular, size: 20))
                                            Img.pencil
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        Spacer()
                                    }
                                    .padding(.trailing,30)
                                }
                                Spacer()
                            }
                        }
                        .frame(height:150)
                    }
                    
                    TodaysMeditation
                        .padding(.top,30)
                    Spacer()
                }
                .padding(.horizontal,30)
            }
        }.onAppear() {
            playAnim = true
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
                Img.moodCheck
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
            }
            HStack {
                Spacer()
                Text("OR")
                    .foregroundColor(Clr.black2)
                    .font(Font.fredoka(.medium, size: 10))
                Spacer()
            }
            ZStack {
                Capsule()
                    .fill(Clr.yellow)
                    .frame(height: 44)
                    .addBorder(Color.black, width: 1.5, cornerRadius: 22)
                    .neoShadow()
                    .padding(.horizontal)
                HStack {
                    Text("See More")
                        .foregroundColor(Clr.black2)
                        .font(Font.fredoka(.medium, size: 16))
                    Image(systemName: "arrow.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:16)
                }
            }.onTapGesture {
                //TODO: Implement see more button tap event here
            }
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
                        .frame(width: 200,alignment: .leading)
                        .foregroundColor(Clr.black2)
                        .multilineTextAlignment(.leading)
                    HStack {
                        Image(systemName: "speaker.wave.3.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:8)
                            .padding(.vertical,0)
                        Text("7 day course")
                            .font(Font.fredoka(.medium, size: 10))
                            .foregroundColor(Clr.black2.opacity(0.5))
                            .padding(.vertical,0)
                    }.padding(.vertical,0)
                    let _ = print(title.count)
                    if title.count < 22 {
                        HStack {
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:8)
                                .padding(.vertical,0)
                            Text("1/2 mins")
                                .font(Font.fredoka(.medium, size: 10))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:8)
                                .padding(.vertical,0)
                            Text("Bijan")
                                .font(Font.fredoka(.medium, size: 10))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                    } else {
                        HStack {
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:8)
                                .padding(.vertical,0)
                            Text("1/2 mins")
                                .font(Font.fredoka(.medium, size: 10))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                            Text("•")
                                .font(Font.fredoka(.medium, size: 10))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:8)
                                .padding(.vertical,0)
                            Text("Bijan")
                                .font(Font.fredoka(.medium, size: 10))
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
            }
            .frame(height: 80, alignment: .center)
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
