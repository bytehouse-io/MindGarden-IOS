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
    let imgURL: String
    let isNew: Bool
    var body: some View {
        ZStack() {
            Rectangle()
                .fill(Clr.darkWhite)
                .border(Clr.darkWhite)
                .cornerRadius(25)
                .frame(width: width * 0.41, height: height * (K.hasNotch() ? 0.225 : 0.25), alignment: .center)
                .overlay(
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: -2) {
                            Spacer()
                            Text(title)
                                .frame(width: width * 0.225, alignment: .leading)
                                .font(Font.mada(.semiBold, size: K.isPad() ? 28 : K.isSmall() ? 16 : 16))
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
                    .frame(width: width * 0.25, height: height * (K.hasNotch() ? 0.18 : 0.2), alignment: .top)
                        if imgURL != "" {
                            AsyncImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/Panda%204.png?alt=media&token=b7a1be36-3c81-46e2-9125-104e104765c4")!,
                                          placeholder: { Text("Loading ...") },
                                       image: {
                                Image(uiImage: $0)
                               })
                                .frame(width: width * 0.17, height: height * 0.14, alignment: .center)
                                .padding(.leading, -17)
                                .padding(.top, 10)
                        } else {
                            img
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.17, height: height * 0.14, alignment: .center)
                                .padding(.leading, -17)
                                .padding(.top, 10)
                        }
                }.frame(width: width * 0.40, height: height * (K.hasNotch() ? 0.225 : 0.25), alignment: .leading)
                         , alignment: .topLeading)
            if !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(id) {
                Image(systemName: "lock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .position(x:  width * 0.4, y: 30)
            }
            if isNew {
                Capsule()
                    .fill(Clr.redGradientBottom)
                    .frame(width: 45, height: 20)
                    .overlay(
                        Text("New")
                            .font(Font.mada(.semiBold, size: 14))
                            .foregroundColor(.white)
                    )
                    .position(x:  width * 0.34, y: height * 0.03)
                    .opacity(0.8)
            }
        }
        
    }
}

struct HomeSquare_Previews: PreviewProvider {
    static var previews: some View {
        HomeSquare(width: 425, height: 800, img: Img.chatBubble, title: "Open Ended Meditation", id: 0, instructor: "None", duration: 15, imgURL: "", isNew: false)
    }
}
