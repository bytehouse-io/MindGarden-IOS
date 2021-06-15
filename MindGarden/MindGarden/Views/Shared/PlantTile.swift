//
//  PlantTile.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI

struct PlantTile: View {
    let width, height: CGFloat
    let title: String
    let img: Image

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Clr.darkWhite)
                .frame(width: width * 0.35, height: height * 0.27)
                .cornerRadius(15)
                .neoShadow()
                .padding()
            VStack(alignment: .leading, spacing: 0) {
                img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width * 0.30, height: height * 0.18)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
                Text(title)
                    .font(Font.mada(.bold, size: 20))
                    .foregroundColor(Clr.black1)
                HStack {
                    Img.coin
                    Text("20")
                        .font(Font.mada(.bold, size: 20))
                        .foregroundColor(Clr.black2)
                }
            }
        }
    }
}

struct PlantTile_Previews: PreviewProvider {
    static var previews: some View {
        PlantTile(width: 300, height: 700, title: "Blue Tulips", img: Img.blueTulipsPacket)
    }
}
