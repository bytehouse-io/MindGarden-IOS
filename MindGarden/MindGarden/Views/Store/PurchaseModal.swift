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
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .center) {
                    Text(title)
                        .font(Font.mada(.bold, size: 30))
                        .foregroundColor(Clr.black1)
                    Img.blueTulipsPacket
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: g.size.width * 0.35, height: g.size.height * 0.25, alignment: .center)
                    HStack {
                        Text("Tulips ").font(Font.mada(.bold, size: 16)).foregroundColor(Clr.black1) +
                        Text("are a bulbous spring-flowering plant of the lily family, with boldly colored cup-shaped flowers.")             .font(Font.mada(.regular, size: 16))
                            .foregroundColor(Clr.black1)
                    }.padding(.horizontal, 30)
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
                                    .foregroundColor(Clr.black1)
                                    .font(Font.mada(.bold, size: 20))
                            })

                    }
                }.frame(width: g.size.width * 0.75, height: g.size.height * 0.55, alignment: .center)
                .background(Clr.darkWhite)
                .cornerRadius(12)
                Spacer()
            }

        }.background(Clr.black1.opacity(0.25))
    }
}

struct PurchaseModal_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseModal(shown: .constant(true))
    }
}
