//
//  ShowRecsScene.swift
//  MindGarden
//
//  Created by Dante Kim on 1/24/22.
//

import SwiftUI

struct ShowRecsScene: View {
    let mood: Mood
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @State private var animateRow = false
    var meditations: [Meditation]
    var body: some View {
        GeometryReader { g in
            let width = g.size.width

            ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    HStack(spacing: 0) {
                        VStack(alignment: .center, spacing: 0)  {
                            HStack {
                                Text("Based on your mood")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.bold, size: 26))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                Mood.getMoodImage(mood: mood)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 25)
                            }.frame(width: abs(width * 0.8), alignment: .leading)
                            Text("We recommend these: ")
                                .foregroundColor(Clr.black2)
                                .font(Font.mada(.regular, size: 22))
                                .frame(width: abs(width * 0.79), alignment: .leading)
                        }
                        if K.isSmall() {
                            Image(systemName: "xmark")
                                .font(.system(size: 22))
                                .foregroundColor(Clr.black1)
                                .onTapGesture {
                                    Analytics.shared.log(event: .mood_recs_not_now)
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    withAnimation {  presentationMode.wrappedValue.dismiss() }
                                }
                        }
                    }.padding(.top)
                    .frame(width: abs(width * 0.79), alignment: .leading)
                    ForEach(0...3, id: \.self) { index in
                        RecRow(width: width, meditation: meditations[index], meditationModel: meditationModel, viewRouter: viewRouter, isWeekly: false)
                            .padding(.top, 10)
                            .animation(Animation.easeInOut(duration: 1.5).delay(3))
                            .opacity(animateRow ? 1 : 0)
                            .onAppear {
                                withAnimation {
                                    animateRow = true
                                }
                            }
                    }
                    HStack {
                        Button {
                            Analytics.shared.log(event: .mood_recs_not_now)
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            withAnimation {  presentationMode.wrappedValue.dismiss()  }
                        } label: {
                            HStack {
                                Text("Not Now")
                                    .foregroundColor(.black)
                                    .font(Font.mada(.semiBold, size: 20))
                            }.frame(width: g.size.width * 0.40, height: 40, alignment: .center)
                            .background(Clr.yellow)
                            .cornerRadius(25)
                        }.padding(.top)
                        .buttonStyle(NeumorphicPress())
                    }.frame(width: g.size.width, alignment: .center)
                }
            }
        }
    }
}
struct RecRow: View {
    let width: CGFloat
    let meditation: Meditation
    var meditationModel: MeditationViewModel
    var viewRouter: ViewRouter
    @Environment(\.presentationMode) var presentationMode
    let isWeekly: Bool
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        Button {
            if isWeekly {
                Analytics.shared.log(event: .home_tapped_weekly_meditation)
            } else {
                Analytics.shared.log(event: .mood_tapped_meditation_rec)
            }

            presentationMode.wrappedValue.dismiss()
            meditationModel.selectedMeditation = meditation
            withAnimation {
                if meditation.type == .course {
                    viewRouter.currentPage = .middle
                } else {
                    viewRouter.currentPage = .play
                }
            }
        } label: {
            ZStack {
                Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(16)
                    .frame(width: width * 0.85, height: isWeekly ? 140 : 120)
                if isWeekly {
                    Text("Weekly Planting \(Date.weekOfMonth()) (\(Date.fullMonthName()))")
                        .foregroundColor(Color.gray)
                        .font(Font.mada(.semiBold, size: 16))
                        .position(x: sizeCategory > .large ? 150 : 125, y: sizeCategory > .large ? -10 : 30)
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                        .frame(width: abs(width * 0.85), alignment: .leading)
                
                }
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                            Text(meditation.title)
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.mada(.bold, size: 18))
                            HStack(spacing: 3) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(Clr.black2)
                                    .font(.system(size: 12))
                                Text(meditation.type.toString())
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.semiBold, size: 12))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                Circle()
                                    .fill(Clr.black2)
                                    .frame(width: 4, height: 4)
                                    .padding(.horizontal, 4)
                                Image(systemName: "clock")
                                    .foregroundColor(Clr.black2)
                                    .font(.system(size: 12))
                                Text(Int(meditation.duration) == 0 ? "Course" : (Int(meditation.duration/60) == 0 ? "1/2" : "\(Int(meditation.duration/60))") + " mins")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.semiBold, size: 12))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                            HStack(spacing: 3) {
                                Image(systemName: "person.fill")
                                    .foregroundColor(Clr.black2)
                                    .font(.system(size: 12))
                                Text("Instructor:")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.regular, size: 12))
                                    .padding(.leading, 4)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                Text("\(meditation.instructor)")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.semiBold, size: 12))
                            }
                        }.frame(width: width * 0.4, alignment: .leading)
                            .padding()
                            .padding(.leading, 10)
                        if meditation.imgURL != "" {
                            UrlImageView(urlString: meditation.imgURL)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.2, height: 90)
                                .padding()
                                .offset(x: -10, y: isWeekly ? -10 : 0)
                        } else {
                            meditation.img
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.2, height: 90)
                                .padding()
                                .offset(x: -10)
                        }

                    }.frame(width: width * 0.85, alignment: .leading)
                    .offset(y: isWeekly ? 10 : 0)
            }
        }.buttonStyle(BonusPress())
    }
}

struct ShowRecsScene_Previews: PreviewProvider {
    static var previews: some View {
        ShowRecsScene(mood: Mood.stressed, meditations: [Meditation]())
    }
}
