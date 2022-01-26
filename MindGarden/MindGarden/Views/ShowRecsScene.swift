//
//  ShowRecsScene.swift
//  MindGarden
//
//  Created by Dante Kim on 1/24/22.
//

import SwiftUI

struct ShowRecsScene: View {
    let mood: Mood
    @State private var animateRow = false
    var meditations: [Meditation]
    var body: some View {
        GeometryReader { g in
            let width = g.size.width

            ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 0)  {
                        HStack {
                            Text("Based on your mood")
                                .foregroundColor(Clr.black2)
                                .font(Font.mada(.bold, size: 30))
                            Mood.getMoodImage(mood: mood)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                        }
                        Text("We recommend these: ")
                            .foregroundColor(Clr.black2)
                            .font(Font.mada(.regular, size: 22))
                    }.padding(.horizontal, width * 0.1)
                    ForEach(0...3, id: \.self) { index in
                        RecRow(width: width, meditation: meditations[index])
                            .padding(.top, 10)
                            .animation(Animation.easeInOut(duration: 1.5).delay(3))
                            .opacity(animateRow ? 1 : 0)
                            .onAppear {
                                withAnimation {
                                    animateRow = true
                                }
                            }
                    }
                }

            }
        }
    }

    struct RecRow: View {
        let width: CGFloat
        let meditation: Meditation

        var body: some View {
            Button {

            } label: {
                ZStack {
                    Rectangle()
                        .fill(Clr.darkWhite)
                        .cornerRadius(16)
                        .frame(height: 120)
                        .padding(.horizontal, width * 0.1)
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(meditation.title)
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.mada(.bold, size: 18))
                            HStack(spacing: 3) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(Clr.black2)
                                    .font(.system(size: 12))
                                Text("Mini Course")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.semiBold, size: 12))
                                Circle()
                                    .fill(Clr.black2)
                                    .frame(width: 4, height: 4)
                                    .padding(.horizontal, 4)
                                Image(systemName: "clock")
                                    .foregroundColor(Clr.black2)
                                    .font(.system(size: 12))
                                Text("12 Mins")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.semiBold, size: 12))
                            }
                            HStack(spacing: 3) {
                                Image(systemName: "person.fill")
                                    .foregroundColor(Clr.black2)
                                    .font(.system(size: 12))
                                Text("Instructor:")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.regular, size: 12))
                                    .padding(.leading, 4)
                                Text("Bijan")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.semiBold, size: 12))
                            }
                        }.frame(width: width * 0.4, alignment: .leading)
                        .padding()
                        .padding(.leading, 10)
                        Img.bee
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.2, height: 90)
                            .padding()
                            .offset(x: -10)
                    }.frame(width: width * 0.8, alignment: .leading)
                }

            }.buttonStyle(NeumorphicPress())
        }
    }
}

struct ShowRecsScene_Previews: PreviewProvider {
    static var previews: some View {
        ShowRecsScene(mood: Mood.stressed, meditations: [Meditation]())
    }
}
