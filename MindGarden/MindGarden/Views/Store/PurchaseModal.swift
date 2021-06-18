//
//  PurchaseModal.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI

struct PurchaseModal: View {
    @Binding var shown: Bool
    var title = "Blue Tulips"
//    var img: Img = Image()

    var body: some View {
        GeometryReader { g in
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center) {
                        HStack {
                            Button {
                                withAnimation {
                                    shown = false
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.title)
                                    .padding()
                            }

                            Text(title)
                                .font(Font.mada(.bold, size: 30))
                                .foregroundColor(Clr.black1)
                                .padding()
                                .padding(.leading, 10)
                            Spacer()
                        }

                        Img.blueTulipsPacket
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: g.size.width * 0.35, height: g.size.height * 0.25, alignment: .center)
                        HStack {
                            Text("Tulips ").font(Font.mada(.bold, size: 16)).foregroundColor(Clr.black1) +
                            Text("are a bulbous spring-flowering plant of the lily family, with boldly colored cup-shaped flowers.")
                                .font(Font.mada(.regular, size: 16))
                                .foregroundColor(Clr.black1)
                        }.padding(.horizontal, 40)
                        HStack(spacing: 10){
                            Img.seed
                            Image(systemName: "arrow.right")
                            Img.tulips1
                            Image(systemName: "arrow.right")
                            Img.tulips2
                            Image(systemName: "arrow.right")
                            Img.tulips3
                        }
                        Button {
                            
                        } label: {
                            Capsule()
                                .fill(Clr.darkWhite)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.045)
                                .neoShadow()
                                .padding()
                                .overlay(HStack{
                                    Img.coin
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: g.size.width * 0.05, height: g.size.width * 0.05)
                                    Text("20")
                                        .font(Font.mada(.bold, size: 20))
                                        .foregroundColor(Clr.black1)
                                })
                        }
                    }.frame(width: g.size.width * 0.85, height: g.size.height * 0.65, alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(12)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct PurchaseModal_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            PurchaseModal(shown: .constant(true))
        }
    }
}
