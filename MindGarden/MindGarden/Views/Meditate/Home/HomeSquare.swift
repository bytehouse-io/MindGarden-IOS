//
//  HomeSquare.swift
//  MindGarden
//
//  Created by Dante Kim on 6/13/21.
//

import SwiftUI

struct HomeSquare: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
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
                            HStack(spacing: 4) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10)
                                Text("Meditation")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                    .font(Font.mada(.regular, size: 12))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                            .padding(.top, 10)
                            .foregroundColor(Clr.lightTextGray)
                            HStack(spacing: 4) {
                                Image(systemName: "timer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10)
                                Text(Int(duration) == 0 ? "Course" : (Int(duration/60) == 0 ? "1/2" : "\(Int(duration/60))") + " mins")
                                    .padding(.leading, 2)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                            .padding(.top, 5)
                            .foregroundColor(Clr.lightTextGray)
                            HStack(spacing: 4) {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10)
                                Text("\(instructor)")
                                    .padding(.leading, 2)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                            .padding(.top, 5)
                            .foregroundColor(Clr.lightTextGray)
                            Spacer()
                    }.padding(.leading, 25)
                    .frame(width: width * 0.25, height: height * (K.hasNotch() ? 0.18 : 0.2), alignment: .top)
                        if imgURL != "" {
                            UrlImageView(urlString: imgURL)
                                .aspectRatio(contentMode: .fit)
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
                Img.lockIcon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .position(x: UIScreen.main.bounds.width * (viewRouter.currentPage == .categories || searchScreen ? 0.275 : 0.2), y: height * (K.hasNotch() ? 0.225 : 0.25) * 0.8 + (viewRouter.currentPage == .categories || searchScreen ? 0 : 10))
            }
            if isNew {
                Capsule()
                    .fill(Clr.redGradientBottom)
                    .frame(width: 45, height: 20)
                    .overlay(
                        Text("New")
                            .font(Font.mada(.semiBold, size: 14))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                    )
                    .position(x: width * (viewRouter.currentPage == .categories || searchScreen ? 0.385 : 0.34), y: viewRouter.currentPage == .categories || searchScreen ? 20 : 17)
                    .opacity(0.8)
            }
        }.opacity((!UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(id)) ? 0.45 : 1)
        
    }
}

struct HomeSquare_Previews: PreviewProvider {
    static var previews: some View {
        HomeSquare(width: 425, height: 800, img: Img.chatBubble, title: "Open Ended Meditation", id: 0, instructor: "None", duration: 15, imgURL: "", isNew: false)
    }
}
