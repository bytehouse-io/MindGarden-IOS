//
//  Store.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI

struct Store: View {
    @State var showModal = false
    
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            GeometryReader { g in
                ScrollView {
                    HStack {
                        Text("menu")
                    }.frame(width: g.size.width, height: g.size.height / 14)
                    .background(Color.red)
                    HStack(alignment: .top, spacing: 20) {
                        VStack(spacing: -10) {
                            Text("🪴 Seed\nShop")
                                .font(Font.mada(.bold, size: 32))
                                .minimumScaleFactor(0.005)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Clr.black1)
                                .padding()
                            Button {
                                withAnimation {
                                    showModal = true
                                }
                            } label: {
                                PlantTile(width: g.size.width, height: g.size.height, title: "Blue Tulips", img: Img.blueTulipsPacket)
                            }
                        }
                        VStack {
                            Rectangle()
                                .foregroundColor(Clr.darkWhite)
                                .frame(width: g.size.width * 0.35, height: g.size.height * 0.27)
                                .cornerRadius(15)
                                .neoShadow()
                                .padding()
                        }
                    }.padding()
                }
                if showModal {
                    Color.black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    Spacer()
                }
                PurchaseModal(shown: $showModal).offset(y: showModal ? 0 : g.size.height)
            }
        }
    }
}

struct Store_Previews: PreviewProvider {
    static var previews: some View {
            Store()
    }
}
