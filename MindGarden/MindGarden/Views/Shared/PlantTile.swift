//
//  PlantTile.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI

struct PlantTile: View {
    @EnvironmentObject var userModel: UserViewModel
    let width, height: CGFloat
    let plant: Plant
    let isShop: Bool
    var isOwned: Bool = false

    var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(isOwned ? .gray.opacity(0.2) : Clr.darkWhite)
                    .frame(width: width * 0.35, height: height * 0.3)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                    .stroke(Clr.darkgreen, lineWidth: !isShop && plant == userModel.selectedPlant ? 3 : 0))
                    .padding()
                VStack(alignment: isShop ? .leading : .center, spacing: 0) {
                    isShop ? plant.packetImage
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.30, height: height * 0.18)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
                        .opacity(isOwned ? 0.4 : 1)
                        : plant.coverImage
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.30, height: height * 0.18)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
                        .opacity(1)
                    Text(plant.title)
                        .font(Font.mada(.bold, size: 20))
                        .foregroundColor(Clr.black1)
                        .opacity(isOwned ? 0.4 : 1)
                    if isShop {
                        if isOwned {
                            Text("Bought")
                                .font(Font.mada(.bold, size: 20))
                                .foregroundColor(Clr.darkgreen)
                                .opacity(0.4)
                        } else {
                            HStack {
                                Img.coin
                                    .renderingMode(.original)
                                Text(String(plant.price))
                                    .font(Font.mada(.bold, size: 20))
                                    .foregroundColor(Clr.black2)
                            }
                        }
                    } else {
                        Capsule()
                            .fill(plant == userModel.selectedPlant  ? Clr.yellow : Clr.darkgreen)
                            .overlay(Text(plant == userModel.selectedPlant ? "Selected" : "Select")
                                        .font(Font.mada(.semiBold, size: 18))
                                        .foregroundColor(plant == userModel.selectedPlant ? Clr.black1 : .white)
                                        .padding()
                            )
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
        PlantTile(width: 300, height: 700, plant: Plant(title: "White Daisy", price: 100, selected: false, description: "With their white petals and yellow centers, white daisies symbolize innocence and the other classic daisy traits, such as babies, motherhood, hope, and new beginnings.", packetImage: Img.blueTulipsPacket, coverImage: Img.daisy, head: Img.daisyHead, badge: Img.redditIcon), isShop: false)
    }
}
