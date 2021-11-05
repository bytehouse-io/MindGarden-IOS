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
    let description: String
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
                                .minimumScaleFactor(0.005)
                                .lineLimit(2)
                            Text(description)
                                .frame(width: width * 0.2, alignment: .leading)
                                .font(Font.mada(.regular, size: K.isPad() ? 24 : 10))
                                .lineLimit(4)
                                .foregroundColor(Clr.black2)
                                .padding(.top, 5)
                                .truncationMode(.tail)
                            HStack(spacing: 3) {
                                Image(systemName: "timer")
                                    .font(.caption)
                                Text(Int(duration) == 0 ? "Course" : (Int(duration/60) == 0 ? "1/2" : "\(Int(duration/60))") + " mins")
                                    .font(.caption)
                            }
                            .padding(.top, 5)
                            Spacer()
                    }.padding(.leading, 25)
                        .frame(width: width * 0.25, height: height * 0.18, alignment: .top)
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.175, height: height * 0.135, alignment: .center)
                        .padding(.leading, -20)
                }.frame(width: width * 0.40, height: height * 0.225, alignment: .leading)
                         , alignment: .topLeading)
        }
    }
}

struct HomeSquare_Previews: PreviewProvider {
    static var previews: some View {
        HomeSquare(width: 425, height: 800, img: Img.chatBubble, title: "Open Ended Meditation", id: 0, description: "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum", duration: 15)
    }
}
