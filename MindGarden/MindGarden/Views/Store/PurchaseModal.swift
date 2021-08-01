//
//  PurchaseModal.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI

struct PurchaseModal: View {
    @Binding var shown: Bool
    @Binding var showConfirm: Bool
    @EnvironmentObject var userModel: UserViewModel
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
                            Text(userModel.willBuyPlant?.title ?? "")
                                .font(Font.mada(.bold, size: 30))
                                .foregroundColor(Clr.black1)
                                .padding()
                                .padding(.leading, 10)
                            Spacer()
                        }

                        userModel.willBuyPlant?.packetImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: g.size.width * 0.35, height: g.size.height * 0.25, alignment: .center)
                        HStack(spacing: 5) {
                            Text(" \(userModel.willBuyPlant?.description ?? "")")
                                .font(Font.mada(.semiBold, size: 16))
                                .foregroundColor(Clr.black1)
                        }.padding(.horizontal, 40)
                        .minimumScaleFactor(0.05)
                        .lineLimit(5)
                        HStack(spacing: 10){
                            Img.seed
                            Image(systemName: "arrow.right")
                            Img.redTulips1
                            Image(systemName: "arrow.right")
                            Img.redTulips2
                            Image(systemName: "arrow.right")
                            Img.redTulips3
                        }
                        Button {
                            if userModel.coins >= userModel.willBuyPlant?.price ?? 0 {
                                withAnimation {
                                    showConfirm = true
                                }
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.darkWhite)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.045)
                                .neoShadow()
                                .padding()
                                .overlay(HStack{
                                    Img.coin
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: g.size.width * 0.05, height: g.size.width * 0.05)
                                    Text("\(userModel.willBuyPlant?.price ?? 0)")
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
            PurchaseModal(shown: .constant(true), showConfirm: .constant(false))
        }
    }
}
