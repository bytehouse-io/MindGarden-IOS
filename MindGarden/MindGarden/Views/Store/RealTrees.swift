//
//  RealTrees.swift
//  MindGarden
//
//  Created by Dante Kim on 7/8/22.
//

import SwiftUI

struct RealTrees: View {
    var body: some View {
        let width = UIScreen.screenWidth
        let height = UIScreen.screenHeight
        VStack {
            Text("Real Tree")
            ZStack {
                Rectangle()
                    .fill(LinearGradient(colors: [Clr.brightGreen.opacity(0.8), Clr.yellow], startPoint: .leading, endPoint: .trailing))
                    .frame(height: height * 0.125)
                    .addBorder(.black, width: 1.5, cornerRadius: 14)
                    .neoShadow()
                HStack {
                    Img.mgLogo
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.35)
                    Text("X")
                        .font(Font.fredoka(.bold, size: 20))
                        .offset(x: -7)
                    Img.treesLogo
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.3)
                }
            }
                HStack {
                    Text("Trees planted \nby you")
                        .font(Font.fredoka(.regular, size: 20))
                        .foregroundColor(Clr.black2)
                        .lineSpacing(10.0)
                        .frame(width: width * 0.3)
                        .offset(x: 7)
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .frame(width: width * 0.45, height: height * 0.085)
                            .addBorder(.black, width: 1.5, cornerRadius: 14)
                            .neoShadow()
                        HStack {
                            Img.realTree
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.15)
                            Text("0")
                                .font(Font.fredoka(.bold, size: 32))
                                .foregroundColor(Clr.brightGreen)
                            Text("trees")
                                .font(Font.fredoka(.regular, size: 20))
                                .foregroundColor(.gray)
                        }
                    }
            }
            Img.treesKid
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
                .neoShadow()
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                Analytics.shared.log(event: .store_tapped_buy_real_tree)
            } label: {
                Rectangle()
                    .fill(Clr.yellow)
                    .overlay(
                        Text("Continue 👉")
                            .foregroundColor(Clr.darkgreen)
                            .font(Font.fredoka(.bold, size: 20))
                    ).addBorder(Color.black, width: 1.5, cornerRadius: 24)
            }
            Text("Trees for the Future (TREES) trains communities on sustainable  land use so that they can grow vibrant economies, thriving food systems, and a healthier planet.")
                .font(Font.fredoka(.regular, size: 16))
            + Text(" Learn More")
                .font(Font.fredoka(.medium, size: 16))
                .foregroundColor(Clr.darkgreen)
        }.frame(width: width * 0.85)
    }
}

struct RealTrees_Previews: PreviewProvider {
    static var previews: some View {
        RealTrees()
    }
}
