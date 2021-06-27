//
//  BonusModal.swift
//  MindGarden
//
//  Created by Dante Kim on 6/26/21.
//

import SwiftUI

struct BonusModal: View {
    @Binding var shown: Bool
    @State private var progress: CGFloat = 1.5


    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        ZStack {
                            Button {
                                withAnimation {
                                    shown = false
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.title)
                                    .padding()
                            }.position(x: 30, y: 35)
                            HStack(alignment: .center) {
                                Text("Daily Bonus")
                                    .font(Font.mada(.bold, size: 30))
                                    .foregroundColor(Clr.black1)
                                    .padding()
                            }.padding(.bottom, -5)
                        }.frame(height: g.size.height * 0.08)

                        Button {

                        } label: {
                            BonusBox(width: g.size.width, height: g.size.height, video: false)
                        }.padding(.bottom, 10)

                        Button {

                        } label: {
                            BonusBox(width: g.size.width, height: g.size.height, video: true)
                        }

                        Spacer()
                        if !K.isIpod() {
                            Text("Streaks")
                                .font(Font.mada(.bold, size: 30))
                                .foregroundColor(Clr.black1)
                                .frame(alignment: .center)
                                .padding(.bottom, 5)
                        }
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .neoShadow()
                            HStack(spacing: 0) {
                                VStack {
                                    Img.daisy
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    Text("6 ").bold().foregroundColor(Clr.black1) + Text("days").foregroundColor(Clr.black1)
                                }.frame(width: g.size.width * 0.15)
                                .padding()
                                VStack(spacing: -5) {
                                    Text("7 days")
                                        .font(Font.mada(.bold, size: 20))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.center)
                                    Button {

                                    } label: {
                                        ProgressBar(width: g.size.width, height: g.size.height, weekly: true, progress: progress)
                                    }

                                    Text("30 days")
                                        .font(Font.mada(.bold, size: 20))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.center)
                                        .padding(.top)
                                    Button {

                                    } label: {
                                        ProgressBar(width: g.size.width, height: g.size.height, weekly: false, progress: progress)
                                    }
                                }
                                .padding()
                            }.padding(.leading)
                        }.frame(width: g.size.width * 0.65, height: g.size.height * 0.25, alignment: .center)
                        Spacer()
                    }
                    .frame(width: g.size.width * 0.85, height: g.size.height * 0.65, alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(12)
                    Spacer()
                }
                Spacer()
            }
        }
    }
    struct ProgressBar: View {
        let width, height: CGFloat
        let weekly: Bool
        let progress: CGFloat

        var body: some View {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: width/3 , height: height/25)
                    .foregroundColor(Clr.darkWhite)
                Rectangle()
                    .frame(width: min((CGFloat(progress)*width)/3, width/3), height: height/25)
                    .cornerRadius(50)
                    .foregroundColor(Clr.yellow)
                    .animation(.linear)
                HStack {
                    if progress >= 1.0 && !K.isIpod() {
                        Text("CLAIM!")
                            .foregroundColor(Clr.black1)
                            .font(Font.mada(.bold, size: 16))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    } else {
                        Spacer()
                    }
                    Img.coin
                        .renderingMode(.original)
                    Text(weekly ? "80" : "200")
                        .foregroundColor(Clr.black1)
                        .font(Font.mada(.semiBold, size: 16))
                    Spacer()
                }.padding()
                .frame(alignment: .center)
            }
            .neoShadow()
        }
    }

    struct BonusBox: View {
        let width, height: CGFloat
        let video: Bool

        var body: some View {
            ZStack(alignment: .center){
                Rectangle()
                    .fill(Clr.darkWhite)
                    .frame(width: width * 0.65, height: height * 0.07)
                    .cornerRadius(15)
                    .neoShadow()
                HStack {
                    Img.coin
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.07)
                    Text("30")
                        .foregroundColor(Clr.black1)
                        .font(Font.mada(.semiBold, size: 24))
                        .minimumScaleFactor(0.5)
                        .padding(.trailing)
                    Capsule()
                        .fill(Clr.brightGreen)
                        .overlay(
                            Group {
                                if video {
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.white)
                                } else {
                                    Text("CLAIM")
                                        .font(Font.mada(.bold, size: 20))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                }
                            }
                        )
                        .frame(width: width * 0.3, height: height * 0.04)
                        .padding(.leading)
                        .neoShadow()
                }.padding()
            }
        }
    }
}

struct BonusModal_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            BonusModal(shown: .constant(true))
        }
    }
}
