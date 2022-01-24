//
//  HomeSquare.swift
//  MindGarden
//
//  Created by Dante Kim on 6/13/21.
//

import SwiftUI

struct HomeSquare: View {
    let width, height: CGFloat
    let img: Image
    let title: String
    let id: Int
    let instructor: String
    let duration: Float
    var body: some View {
        ZStack() {
            Rectangle()
                .fill(Clr.darkWhite)
                .border(Clr.darkWhite)
                .cornerRadius(25)
                .frame(width: width * 0.41, height: height * 0.225, alignment: .center)
                .overlay(
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: -2) {
                            Spacer()
                            Text(title)
                                .frame(width: width * 0.225, alignment: .leading)
                                .font(Font.mada(.semiBold, size: K.isPad() ? 28 : K.isSmall() ? 12 : 16))
                                .foregroundColor(Clr.black2)
                                .minimumScaleFactor(0.05)
                                .lineLimit(3)
                            HStack(spacing: 3) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.caption)
                                Text("Meditation")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                    .font(Font.mada(.regular, size: 12))
                            }
                            .padding(.top, 10)
                            HStack(spacing: 3) {
                                Image(systemName: "timer")
                                    .font(.caption)
                                Text(Int(duration) == 0 ? "Course" : (Int(duration/60) == 0 ? "1/2" : "\(Int(duration/60))") + " mins")
                                    .padding(.leading, 2)
                                    .font(.caption)
                            }
                            .padding(.top, 5)
                            HStack(spacing: 3) {
                                Image(systemName: "person.fill")
                                    .font(.caption)
                                Text("\(instructor)")
                                    .padding(.leading, 2)
                                    .font(.caption)
                            }
                            .padding(.top, 5)
                            Spacer()
                    }.padding(.leading, 25)
                        .frame(width: width * 0.25, height: height * 0.18, alignment: .top)
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.17, height: height * 0.14, alignment: .center)
                        .padding(.leading, -17)
                        .padding(.top, 10)
                }.frame(width: width * 0.40, height: height * 0.225, alignment: .leading)
                         , alignment: .topLeading)
            if !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(id) {
                Image(systemName: "lock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .position(x:  width * 0.4, y: 30)
            }
        }
        
    }
}

struct HomeSquare_Previews: PreviewProvider {
    static var previews: some View {
        HomeSquare(width: 425, height: 800, img: Img.chatBubble, title: "Open Ended Meditation", id: 0, instructor: "None", duration: 15)
    }
}
