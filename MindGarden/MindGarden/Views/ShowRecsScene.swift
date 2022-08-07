//
//  ShowRecsScene.swift
//  MindGarden
//
//  Created by Dante Kim on 1/24/22.
//

import SwiftUI

struct ShowRecsScene: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @State private var animateRow = false
    var meditations: [Int]
    @Binding var title: String
    
    
    var body: some View {
        GeometryReader { g in
            let width = g.size.width

            ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    HStack {
                        CloseButton() {
                            presentationMode.wrappedValue.dismiss()
                        }.padding(.leading, 32)
                        .padding(.top)
                        Spacer()
                        Text(title)
                            .foregroundColor(Clr.black2)
                            .font(Font.fredoka(.bold, size: 20))
                            .padding(.top)
                        Spacer()
                        CloseButton() {
                        }.opacity(0)
                        .padding(.trailing, 32)
                    }.padding(.top)
                    .frame(width: width, alignment: .center)
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(0...max(0, meditations.count - 1), id: \.self) { index in
                            let isBreath =  Breathwork.breathworks.contains(where: { work in
                                work.id == meditations[index]
                            })
                            MeditationRow(id: meditations[index], isBreathwork: isBreath)
                                .padding(.top, 10)
                                .animation(Animation.easeInOut(duration: 1.5).delay(3))
                                .opacity(animateRow ? 1 : 0)
                                .onAppear {
                                    withAnimation {
                                        animateRow = true
                                    }
                                }.padding(.horizontal, 32)
                        }
                    }.frame(width: width, alignment: .center)
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
                        .font(Font.fredoka(.semiBold, size: 16))
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                        .frame(width: abs(UIScreen.main.bounds.width), alignment: .leading)
                        .position(x: sizeCategory > .large ? 300 : K.isSmall() ? 240 : width * 0.64, y: sizeCategory > .large ? -10 : 30)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                            Text(meditation.title)
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.fredoka(.bold, size: 18))
                            HStack(spacing: 3) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(Clr.black2)
                                    .font(.system(size: 12))
                                Text(meditation.type.toString())
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.semiBold, size: 12))
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
                                    .font(Font.fredoka(.semiBold, size: 12))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                            HStack(spacing: 3) {
                                Image(systemName: "person.fill")
                                    .foregroundColor(Clr.black2)
                                    .font(.system(size: 12))
                                Text("Instructor:")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.regular, size: 12))
                                    .padding(.leading, 4)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                Text("\(meditation.instructor)")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.semiBold, size: 12))
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
        ShowRecsScene(meditations: [0], title: .constant("favs"))
    }
}
