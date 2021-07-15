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
    var body: some View {
        ZStack() {
            Rectangle()
                .fill(Clr.darkWhite)
                .border(Clr.darkWhite)
                .cornerRadius(25)
                .frame(width: width * 0.41, height: height * 0.225, alignment: .center)
                .overlay( HStack {
                    VStack(alignment: .leading, spacing: -2) {
                        Text(title)
                                    .frame(width: width * 0.225, alignment: .leading)
                                    .font(Font.mada(.semiBold, size: 16))
                                    .foregroundColor(Clr.black2)
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(2)
                        Text("Lorem Ipsum has been the industry's")
                            .frame(width: width * 0.2, alignment: .leading)
                            .font(Font.mada(.regular, size: 12))
                            .minimumScaleFactor(0.005)
                            .lineLimit(3)
                            .foregroundColor(Clr.black2)
                            .padding(.top, 5)

                        HStack(spacing: 3){
                            Image(systemName: "timer")
                                .font(.caption)
                            Text("15 min")
                                .font(.caption)
                        }
                        .padding(.top, 5)
                    }.padding(.leading, 25)
                    .frame(width: width * 0.25, height: height * 0.18, alignment: .top)

                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.18, height: height * 0.135, alignment: .center)
                        .padding(.leading, -22)

                }.frame(width: width * 0.40, height: height * 0.225, alignment: .leading)
                         , alignment: .topLeading)
        }
    }
}

struct HomeSquare_Previews: PreviewProvider {
    static var previews: some View {
//        PreviewDisparateDevices {
                        HomeSquare(width: 425, height: 800, img: Img.chatBubble, title: "Open Ended Meditation")

//        }
    }
}
