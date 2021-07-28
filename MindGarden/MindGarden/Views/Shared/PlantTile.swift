//
//  PlantTile.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI

struct PlantTile: View {
    let width, height: CGFloat
    let plant: Plant
    let isShop: Bool

    var body: some View {

            ZStack {
                Rectangle()
                    .foregroundColor(Clr.darkWhite)
                    .frame(width: width * 0.35, height: height * 0.3)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Clr.darkgreen, lineWidth: 3))
                    .padding()
                VStack(alignment: isShop ? .leading : .center, spacing: 0) {
                    plant.packetImage
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.30, height: height * 0.18)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)

                    Text(plant.title)
                        .font(Font.mada(.bold, size: 20))
                        .foregroundColor(Clr.black1)
                    if isShop {
                        HStack {
                            Img.coin
                                .renderingMode(.original)
                            Text("20")
                                .font(Font.mada(.bold, size: 20))
                                .foregroundColor(Clr.black2)
                        }
                    } else {
                        Button {
                            
                        } label: {
                            Capsule()
                                .fill(Clr.yellow)
                                .overlay(Text("Select")
                                            .font(Font.mada(.semiBold, size: 18))
                                            .foregroundColor(Clr.black1)
                                            .padding()
                                )
                        }
                        .frame(width: width * 0.30, height: height * 0.04)
                        .buttonStyle(NeumorphicPress())
                        .padding(.top, 5)
                    }
                }
            }
       
    }
}

struct PlantTile_Previews: PreviewProvider {
    static var previews: some View {
        PlantTile(width: 300, height: 700, plant: Plant(title: "White Daisy", price: 100, selected: false, description: "With their white petals and yellow centers, white daisies symbolize innocence and the other classic daisy traits, such as babies, motherhood, hope, and new beginnings.", packetImage: Img.blueTulipsPacket, coverImage: Img.daisy), isShop: false)
    }
}
